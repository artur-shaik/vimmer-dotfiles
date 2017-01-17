
# in case everything goes wrong, we at least fall back to a plain xterm

trap "exec $failsafe" EXIT SIGHUP SIGINT SIGPIPE SIGTERM SIGIO

# source common code shared between the
# X session and X init scripts
. /etc/X11/xinit/xinitrc.common

# current theme and background
. ~/bin/vars

export QT_STYLE_OVERRIDE=qtcurve

mpd
compton --config ~/.compton.conf -b &

wmname compiz
AWT_TOOLKIT=MToolkit; export AWT_TOOLKIT
_JAVA_AWT_WM_NONREPARENTING=1; export _JAVA_AWT_WM_NONREPARENTING

xset +fp ~/.fonts
xset -b                 # disable pc speaker
xsetroot -cursor_name left_ptr&
sxhkd &
udiskie -n -T &
kbdd
export DE=kde
/usr/sbin/bitlbee -F -c /etc/bitlbee/bitlbee.conf
xautolock -locker 'i3lock -i ~/.wallpaper.png' &
bash -c "export LC_TYPE=en_EN.UTF-8; export LANG=en_EN.UTF-8; conky -c ~/.conky/conkyrc_lunatico;" &
bash -c "conky -c ~/.conky/conkyrc_tasks;" &
setxkbmap -layout 'us,ru' -option 'grp:alt_space_toggle,grp_led:caps,ctrl:nocaps'
pulseaudio -D
rm "/tmp/bspwm_0_0-socket"
after_theme_hook.sh ~/.config/themer/current/
exec bspwm -c ~/.config/bspwm/bspwmrc
exit 0
