#!/bin/bash
# ash: wallpaper picker as a GRID WITH PREVIEWS (like gh0stzk RiceSelector) + all
# theme_select.sh options (random/random_light/random_dark/light/dark/backend/opacity).
# Previews are thumbnails in ~/.cache/wall-thumbs (convert, incremental). The menu
# returns the same strings as rofi-wal -> the pipeline below is identical to theme_select.

WALLPAPERDIR="$HOME/.backgrounds"
THUMBS="$HOME/.cache/wall-thumbs"
RASI="$HOME/.config/rofi/wall-select.rasi"
ASH_RASI="$HOME/.config/rofi/ash-wal.rasi"

dark='#2A303C'
light='#D8DEE9'

load_defaults() {
    wall=$(cat ~/.cache/wal/current_wall)
    shade=$(cat ~/.cache/wal/current_shade)
    opacity=$(cat ~/.cache/wal/current_opacity)
    backend="$(cat ~/.cache/wal/current_backend)"
}

# ---- wallpaper thumbnails (square crop, only new/changed, parallel) ----
mkdir -p "$THUMBS"
build_thumbs() {
    for f in "$WALLPAPERDIR"/*; do
        [ -f "$f" ] || continue
        local t="$THUMBS/${f##*/}.png"
        if [ ! -f "$t" ] || [ "$f" -nt "$t" ]; then
            printf '%s\n%s\n' "$f" "$t"
        fi
    done | xargs -r -P4 -n2 sh -c \
        'convert "$1" -strip -thumbnail 600x600^ -gravity center -extent 600x600 "$2" 2>/dev/null' _
}

# ---- action tiles: kw|label ----
# IMPORTANT: generate BEFORE launching rofi, not inside menu() command-substitution.
# Otherwise convert writes the file while rofi already async-loads icons -> race
# (a half-written/stale file was read, all tiles showed the same label).
# Single bg+text color — otherwise text blended in on light tiles.
ACT_BG='#2a303c'
ACT_FG='#e8eef7'
ACTIONS='random|RANDOM
random_light|RND LIGHT
random_dark|RND DARK
light|ALL LIGHT
dark|ALL DARK
backend|BACKEND
opacity|OPACITY'

build_action_tiles() {
    echo "$ACTIONS" | while IFS='|' read -r kw label; do
        convert -size 600x600 "xc:$ACT_BG" -gravity center \
            -fill "$ACT_FG" -pointsize 46 -annotate +0+0 "$label" \
            "$THUMBS/_act_$kw.png" 2>/dev/null
    done
}

# first run may churn through thumbnails — give a hint
[ -z "$(ls -A "$THUMBS" 2>/dev/null)" ] && \
    notify-send -t 2000 "wall-select" "generating wallpaper previews…"
build_thumbs
build_action_tiles

# ---- build menu: action tiles first, then wallpapers with previews ----
menu() {
    echo "$ACTIONS" | while IFS='|' read -r kw _; do
        printf '%s\000icon\037%s\n' "$kw" "$THUMBS/_act_$kw.png"
    done
    for f in "$WALLPAPERDIR"/*; do
        [ -f "$f" ] || continue
        printf '%s\000icon\037%s\n' "${f##*/}" "$THUMBS/${f##*/}.png"
    done
}

wall_command=$(menu | rofi -dmenu -i -p "Wallpaper" -theme "$RASI")
[ -z "$wall_command" ] && exit 0

# =========================================================================
# Below — theme_select.sh logic unchanged (dispatch + apply).
# =========================================================================
if [[ $wall_command == random || $wall_command == random_light || $wall_command == random_dark ]]; then
    load_defaults
    if [[ $wall_command == random_light ]]; then
        shade=light
    elif [[ $wall_command == random_dark ]]; then
        shade=dark
    fi
    backend="$(rofi-wal backend | grep -v 'Current:' | grep -v '^$' | shuf | head -n 1)"
    wall=$(ls ~/.backgrounds | grep $shade | shuf | head -n 1)
    wall="$HOME/.backgrounds/$wall"
elif [[ $wall_command == backend ]]; then
    load_defaults
    backend="$(rofi-wal backend | rofi -dmenu -i -theme "$ASH_RASI")"
elif [[ $wall_command == opacity ]]; then
    load_defaults
    opacity=$(rofi-wal opacity | rofi -dmenu -i -theme "$ASH_RASI")
elif [[ $wall_command == light ]]; then
    # ash: ONLY change shade on the CURRENT wallpaper (wall from load_defaults),
    # no shuf. Random wallpaper of this shade = separate RND LIGHT/RND DARK tiles.
    load_defaults
    shade=light
elif [[ $wall_command == dark ]]; then
    load_defaults
    shade=dark
else
    # a specific file was picked: opacity/backend/shade = CURRENT (no prompts).
    load_defaults
    wall="$HOME/.backgrounds/$wall_command"
    # shade from filename: exactly one shade token -> use it; two or none ->
    # keep current (from load_defaults). Token bounded by -_. (like random).
    grep -qiE '(^|[-_.])light([-_.]|$)' <<<"$wall_command" && has_light=1 || has_light=0
    grep -qiE '(^|[-_.])dark([-_.]|$)'  <<<"$wall_command" && has_dark=1  || has_dark=0
    if   [ $has_light -eq 1 ] && [ $has_dark -eq 0 ]; then shade=light
    elif [ $has_dark  -eq 1 ] && [ $has_light -eq 0 ]; then shade=dark
    fi
fi

if [ -f $wall ]; then
    if [[ -z $opacity ]]; then
        opacity=$(rofi-wal opacity | rofi -dmenu -i -theme "$ASH_RASI")
    fi

    if [[ -z $shade ]]; then
        shade="$(rofi-wal shade | rofi -dmenu -i -theme "$ASH_RASI")"
    fi

    if [[ -z $backend ]]; then
        backend="$(rofi-wal backend | rofi -dmenu -i -theme "$ASH_RASI")"
    fi

    is_light=$(rofi-wal "$shade")
    bg=$dark
    if [[ "$is_light" == "-l" ]]; then
        bg=$light
    fi

    theme-step "wall_select wal backend=$backend shade=$shade wall=$wall"
    echo wal --backend=$backend -i "$wall" -a "$opacity" $is_light
    wal --backend=$backend -i "$wall" -a "$opacity" $is_light 2>&1 | tee -a /tmp/wal.log
    wal_exit=${PIPESTATUS[0]}

    # ash: backend 'wal' (imagemagick) fails on poor palettes (pixel-art, few
    # colors): "couldn't generate a suitable palette" -> wal_exit!=0 -> nothing
    # got applied (while brightness/redshift below fired anyway). Retry across
    # robust backends until one succeeds.
    if [ "$wal_exit" -ne 0 ]; then
        for fb in haishoku colorthief colorz schemer2 wal; do
            [ "$fb" = "$backend" ] && continue
            theme-step "wall_select wal RETRY backend=$fb"
            wal --backend="$fb" -i "$wall" -a "$opacity" $is_light 2>&1 | tee -a /tmp/wal.log
            wal_exit=${PIPESTATUS[0]}
            [ "$wal_exit" -eq 0 ] && { backend="$fb"; break; }
        done
    fi

    if [ $wal_exit -eq 0 ]; then
        theme-step "wall_select brightnessctl ($is_light)"
        [[ $is_light == "-l" ]] && brightnessctl set 100%
        # at night (19:00–06:00) warm redshift, daytime — reset
        theme-step "wall_select redshift"
        hour=$(date +%H)
        if (( 10#$hour >= 19 || 10#$hour < 6 )); then
            redshift -l 42.88:74.58 -O 2100K -P -b 0.7
        else
            redshift -l 42.88:74.58 -x
        fi

        echo "$opacity" >~/.cache/wal/current_opacity
        echo "$shade" >~/.cache/wal/current_shade
        echo "$wall" >~/.cache/wal/current_wall
        echo "$backend" >~/.cache/wal/current_backend
        echo "$bg" >~/.cache/wal/current_bg_color

        theme-step "wall_select after_theme_hook"
        "$HOME/bin/after_theme_hook.sh"
        # ensure wallpaper<->colors sync: feh the chosen wallpaper LAST
        theme-step "wall_select feh"
        feh --bg-fill "$wall"
        msg="set <b>$shade</b> background: <b>$wall</b> with opacity: <b>$opacity</b> by <b>$backend</b> backend"
    else
        msg="⚠ wal failed to generate a palette for <b>$wall</b> (all backends). Theme unchanged."
    fi
    theme-step "wall_select DONE"

    sleep 5
    notify-send wal "$msg"
fi
