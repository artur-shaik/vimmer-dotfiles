#!/usr/bin/env bash

dir=$1

follows_monitor_current=$(bspc config pointer_follows_monitor)
follows_focus_current=$(bspc config pointer_follows_focus)
bspc config pointer_follows_monitor true
bspc config pointer_follows_focus true
if ! bspc node -f $dir.local; then
    bspc config focus_follows_pointer false
    bspc monitor -f $dir
    bspc config focus_follows_pointer true
fi
bspc config pointer_follows_monitor $follows_monitor_current
bspc config pointer_follows_focus $follows_focus_current
