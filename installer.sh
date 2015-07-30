#!/bin/bash

cd "$(dirname "$0")"

declare -a installList
declare -a conflist
declare -a remotelist
command="null"
repopath=$PWD
githubRepo=https://github.com/artur-shaik/vimmer-dotfiles/

function usage() {
    echo "./installer.sh [install [configuration [configuration [...]]]]"
}

function readArguments() {
    while [[ $# > 0 ]]; do
        key="$1"

        case $key in
            install)
                command="install"
                shift
                ;;
            *)
                if [[ "$command" = "install" ]]; then
                    installList+=($key)
                fi
                shift
                ;;
        esac
    done
}

ignore=(.gitignore dests.txt installer.sh)

function fetchRemoteList() {
    echo "fetching list from github..."
    for conf in `wget -qO- $githubRepo/tree/master | grep js-directory-link | sed 's/.*<a.*>\(.*\)<\/a>.*/\1/g'`; do
        if [[ " ${ignore[@]} " =~ " ${conf} " ]]; then
            continue
        fi

        if [[ " ${conflist[@]} " =~ " ${conf} " ]]; then
            echo "local $conf"
        else
            echo "remote $conf"
            conflist+=($conf)
            remotelist+=($conf)
        fi
    done
}

function fillListLocal() {
    i=1
    for file in `ls -d */ | grep -v "backups" | cut -d/ -f 1`; do
        echo $i: $file
        conflist[$i]=$file
        let i+=1
    done
}

function backup() {
    if [[ ! -d $repopath/backups ]]; then
        mkdir $repopath/backups
    fi

    mv $1 $repopath/backups
}

function fetchRemoteDirectory() {
    if ! hash svn 2> /dev/null; then
        echo "you need 'svn' to fetch remote directories"
        return 1
    fi

    echo "fetching $1 from remote repository..."
    svn checkout $githubRepo/trunk/$1
    return $?
}

function install() {
    for install in ${installList[*]}; do
        if [[ " ${remotelist[@]} " =~ " ${install} " ]]; then
            fetchRemoteDirectory $install
            if [[ $? -eq 1 ]]; then
                continue
            fi
        fi

        dest=$(eval echo `cat $repopath/dests.txt | grep "^$install*" | cut -d'=' -f 2`)
        if [[ $dest = '' ]]; then
            dest=~/
        fi
        echo "Creating symlink for $install in $dest"
        if [[ -f ~/$file ]]; then
            if ! cmp -s $repopath/$install $dest/$install; then
                echo "backup old config"
                backup $dest/$install
            else
                echo "Files are the same. Continue next."
                continue
            fi
        elif [[ -d $dest/$install ]]; then
            rm -rf $repopath/backups/$install
            if [[ ! -L $dest/$install ]]; then
                echo "backup old config directory"
                backup $dest/$install
            else
                echo -n "$install configuration is link (already installed?), remove? (Y/n): "
                read answer
                if [[ $answer == 'Y' ]]; then
                    rm $dest/$install
                else
                    echo "can't install configuration: $install"
                    continue
                fi
            fi
        fi
        
        if ln -s $repopath/$install $dest/$install 2> /dev/null; then
            echo "$install linked!"
        else
            echo "Can not create link to configuration $install."
            echo "You can try do it with this command:"
            echo "ln -s $repopath/$install $dest/$install"
        fi
    done
}

function list() {
    i=1
    while [ ${conflist[i]} ]; do
        for install in ${installList[@]}; do
            if [[ "$install" = "${conflist[i]}" ]]; then
                echo -n "*"
                break
            fi
        done
        echo $i: ${conflist[i]}
        let i+=1
    done
}

function parseIds() {
    IN=$1
    declare -a resultIds
    commaIds=(${IN//,/ })
    for id in ${commaIds[*]}; do
        periodIds=(${id//-/ })
        if [[ ${#periodIds[@]} -eq 2 ]]; then
            resultIds+=($(seq ${periodIds[0]} ${periodIds[1]}))
        else
            resultIds+=($id)
        fi
    done

    toggleIds=(`echo ${resultIds[*]}|tr ' ' '\n' | sort -u | tr '\n' ' '`)
}

function toggle() {
    if [[ ${#command[@]} -eq 1 ]]; then
        echo -n "toggle what?: "
        read id
    else
        id=${command[1]}
    fi
    parseIds $id
    for id in ${toggleIds[@]}; do
        if [[ ${conflist[id]} ]]; then
            toggled=0
            for (( i = 0 ; i <= ${#installList[*]} + 1 ; i++ )); do
                if [[ ${installList[i]} = ${conflist[id]} ]]; then
                    unset installList[$i]
                    toggled=1
                fi
            done
            if [[ $toggled -eq 0 ]]; then
                installList+=(${conflist[id]})
            fi
        fi
    done
}

function process() {
    case ${command[0]} in
        help)
            echo "TODO: help"
            ;;
        list)
            list
            ;;
        install)
            install
            ;;
        toggle)
            toggle
            ;;
        exit|quit)
            exit 0
            ;;
        *)
            echo
    esac

    command="null"
}

function main() {

    readArguments $@

    fillListLocal
    fetchRemoteList

    while true; do
        if [[ $command = "null" ]]; then
            echo -n "enter command: "
            read -a command
        fi

        process
    done
}

main $@
