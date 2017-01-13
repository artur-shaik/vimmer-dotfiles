#!/bin/bash

MODEFILE=/dev/shm/inputmode

function toggle() {
    if [[ -f $MODEFILE ]]; then
        INPUTMODE=`cat $MODEFILE`;
    else
        INPUTMODE="INPUT";
    fi;

    updateConf=0
    if [[ $# -eq 0 ]]; then 
        if [[ $INPUTMODE == "NORMAL" ]]; then updateConf=1; fi

        if [[ $INPUTMODE == "INPUT" ]]; then 
            INPUTMODE="MOUSE"
        else 
            INPUTMODE="INPUT"
        fi
    else
        OLD=$INPUTMODE
        case $1 in
        I) INPUTMODE="INPUT";;
        M) INPUTMODE="MOUSE";;
        N) INPUTMODE="NORMAL";;
        *) INPUTMODE="INPUT";;
        esac
        if [[ $OLD != $INPUTMODE ]]; then updateConf=1; fi
    fi

    if [[ $updateConf -eq 1 ]]; then
        rm ~/.config/sxhkd/sxhkdrc
        if [[ $INPUTMODE == "NORMAL" ]]; then
            ln -s ~/.config/sxhkd/sxhkdrc_control ~/.config/sxhkd/sxhkdrc
        elif [[ $INPUTMODE == "MOUSE" ]]; then
            ln -s ~/.config/sxhkd/sxhkdrc_mouse ~/.config/sxhkd/sxhkdrc
        else
            ln -s ~/.config/sxhkd/sxhkdrc_input ~/.config/sxhkd/sxhkdrc
        fi

        killall -SIGUSR1 sxhkd
        pidof sxhkd > /dev/null
        if [ $? -ne 0 ]; then
            sxhkd &
        fi
    fi

    echo $INPUTMODE > $MODEFILE
}

function show() {
    if [[ -f $MODEFILE ]]; then
        INPUTMODE=`cat $MODEFILE`;
    else
        INPUTMODE="INPUT";
    fi;

    echo $INPUTMODE
}

case $1 in
t) toggle $2;;
*) show;;
esac
