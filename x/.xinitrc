# in case everything goes wrong, we at least fall back to a plain xterm
failsafe="xterm -ls -T Failsafe -geometry 80x24-0-0"
trap "exec $failsafe" EXIT SIGHUP SIGINT SIGPIPE SIGTERM SIGIO

# some bash (1 and 2) settings to avoid trouble on a
# failed program call.
set +e > /dev/null 2>&1
set +u > /dev/null 2>&1
set +o posix  > /dev/null 2>&1
if type shopt > /dev/null 2>&1 ; then
    shopt -s execfail
else
    no_exit_on_failed_exec=1
fi

# run user xinit scripts.
for script in /etc/X11/xinit/xinitrc.d/*; do
    test -d $script && continue
    test -x $script || continue
    case "$script" in
	.*)		continue ;;
	*.rpm*)		continue ;;
	*.swap)		continue ;;
	*.bak)		continue ;;
	*.orig)		continue ;;
	\#*)		continue ;;
	*~)		continue ;;
    esac
    $script
done
unset script

# source common code shared between the
# X session and X init scripts
. /etc/X11/xinit/xinitrc.common


# current theme and background
export DARKBG=~/.backgrounds/peacock.png
export LIGHTBG=~/.backgrounds/peacock.png
export DARKTHEME=~/.colors/peacock_dark
export LIGHTTHEME=~/.colors/peacock

setxkbmap -layout "us,ru"
setxkbmap -option "grp:caps_toggle"
mpd
compton --config ~/.compton.conf -b &
wmname compiz
xset +fp ~/.fonts
xset -b                 # disable pc speaker
sxhkd &
udiskie -T &
kbdd
switchtheme
export DE=kde
rm "/tmp/bspwm_0_0-socket"
exec bspwm -c ~/.config/bspwm/bspwmrc
exit 0
