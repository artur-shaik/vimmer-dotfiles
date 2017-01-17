[global]
    font = "{{ fontName.title() }} {{ fontSize - 3 }}"
    allow_markup = yes
    format = "<b>%s %p</b>\n%b"
    sort = yes
    indicate_hidden = true
    # geometry = "x5"
    idle_threshold = 0
    geometry = "200x5-20+20"
    alignment = center
    show_age_threshold = 60
    sticky_history = no
    follow = mouse
    word_wrap = yes
    separator_height = 2
    padding = 5
    horizontal_padding = 5
    separator_color = frame
    startup_notification = false
    dmenu = "/usr/bin/dmenu -p dunst: -nb {{ background }} -nf {{ foreground }} -sb {{ black }} -sf {{ white }}"
    browser = /home/ash/bin/defaultbrowser


[frame]
    width = 3
    color = "{{ black }}"

[shortcuts]
    close = ctrl+space
    close_all = ctrl+shift+space
    history = ctrl+grave
    context = ctrl+shift+period

[urgency_low]
    background = "{{ alt_black }}"
    foreground = "{{ alt_white }}"
    timeout = 10

[urgency_normal]
    background = "{{ alt_black }}"
    foreground = "{{ alt_white }}"
    timeout = 10

[urgency_critical]
    background = "{{ red }}"
    foreground = "{{ alt_white }}"
    timeout = 0


[irc]
    appname = weechat
    timeout = 10
    background = "{{ black }}"
    foreground = "{{ white }}"

[espeak]
    summary="*"
    script=notify
