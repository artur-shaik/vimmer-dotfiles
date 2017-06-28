urxvt*perl-lib:			/usr/local/lib/urxvt/perl
urxvt*perl-ext-common:	default,matcher,clipboard-osc,font-size,rotate-colors
URxvt*matcher.button:   1
urxvt*cursorUnderline:  0
urxvt*letterspace:      4
urxvt*fading: 			11
urxvt*fadeColor: 		#000000
urxvt*cursorBlink:		true
urxvt*scrollBar:		false
urxvt*depth:			32 
urxvt*internalBorder: 	4
urxvt*dynamicColors:    on
urxvt.urgentOnBell:     true
urxvt*transparent: false
urxvt*shading: 4

!# xcursor
Xcursor.theme:~/.icons/ATER-yellow

!# font change settings
URxvt.iso14755:         false
URxvt.iso14755_52:      false
URxvt.keysym.C-equal:	perl:font-size:increase
URxvt.keysym.C-minus:   perl:font-size:decrease
URxvt.keysym.C-S-Up:   perl:font-size:incglobal
URxvt.keysym.C-S-Down: perl:font-size:decglobal

!# xft settings
Xft.antialias: true
Xft.autohint: 0
Xft.dpi: 104.47
Xft.hinting: 1
Xft.hintstyle: hintfull
Xft.lcdfilter: lcddefault
Xft.rgba: rgb

#include ".Xfont"

*simple_background: {% if background %}{{ background }}{% else %}{{ black }}{% endif %}
*background: {% if transparency %}[{{ transparency }}]{% endif %}{% if background %}{{ background }}{% else %}{{ black }}{% endif %}
*foreground: {% if foreground %}{{ foreground }}{% else %}{{ white }}{% endif %}
*cursorColor: {{ white }}

! black
*color0: {{ black }}
*color8: {{ alt_black }}
! red
*color1: {{ red }}
*color9: {{ alt_red }}
! green
*color2: {{ green }}
*color10: {{ alt_green }}
! yellow
*color3: {{ yellow }}
*color11: {{ alt_yellow }}
! blue
*color4: {{ blue }}
*color12: {{ alt_blue }}
! magenta
*color5: {{ magenta }}
*color13: {{ alt_magenta }}
! cyan
*color6: {{ cyan }}
*color14: {{ alt_cyan }}
! white
*color7: {{ white }}
*color15: {{ alt_white }}
! underline when default
*colorUL: {% if underline %}{{ underline }}{% else %}{{ white }}{% endif %}
