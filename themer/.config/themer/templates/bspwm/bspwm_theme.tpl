#!/bin/sh

bspc config presel_border_color {{ tertiary }}
bspc config focused_border_color {{ primary }}
bspc config normal_border_color {{ background }}
bspc config active_border_color {{ foreground }}
bspc config urgent_border_color {{ special }}

feh --bg-scale ~/.wallpaper.png
