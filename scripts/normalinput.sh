#!/bin/bash

param=$1

if [[ `inputmode.sh` == "NORMAL" ]]; then 
    if [[ $param == "ctrl+a" || $param == "0" ]]; then
        key=Home; 
    elif [[ $param == "ctrl+e" || $param == "$" ]]; then
        key=End; 
    elif [[ $param == "ctrl+d" ]]; then
        key=Next; 
    elif [[ $param == "ctrl+u" ]]; then
        key=Prior; 
    elif [[ $param == "ctrl+w" ]]; then
        key="ctrl+shift+Left BackSpace"; 
    elif [[ $param == "h" ]]; then
        key=Left
    elif [[ $param == "H" ]]; then
        key=shift+Left
    elif [[ $param == "j" ]]; then
        key=Down
    elif [[ $param == "J" ]]; then
        key=shift+Down 
    elif [[ $param == "k" ]]; then
        key=Up
    elif [[ $param == "K" ]]; then
        key=shift+Up
    elif [[ $param == "l" ]]; then
        key=Right
    elif [[ $param == "L" ]]; then
        key=shift+Right
    elif [[ $param == "w" ]]; then
        key=ctrl+Right
    elif [[ $param == "b" ]]; then
        key=ctrl+Left
    elif [[ $param == "g" ]]; then
        key=ctrl+Home
    elif [[ $param == "G" ]]; then
        key=ctrl+End
    elif [[ $param == "d" ]]; then
        key=Delete
    elif [[ $param == "i" ]]; then
        inputmode.sh t I;
    fi
else
    xdotool type --window `xdotool getactivewindow` $param
fi

if [[ -n "$key" ]]; then 
    xdotool key --window `xdotool getactivewindow` $key
fi
