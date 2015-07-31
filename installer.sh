#!/bin/bash

cd "$(dirname "$0")"

declare -a installList
declare -a conflist
declare -a remotelist
command="null"
repopath=$PWD
githubRepo=https://github.com/artur-shaik/vimmer-dotfiles/
singleShot=0

function usage() {
    echo "Usage:"
    echo "  ./installer.sh command"
    echo ""
    echo "commands:"
    echo "  install configuration [configuration [...]]"
    echo "  list - show all available configurations"
    echo "  help - show this help"
    echo ""
    echo "  without command will run interactive mode"
    echo ""
    echo "interactive commands:"
    echo "  toggle x,y-z - switch, what configurations install/don't"
}

function readArguments() {
    while [[ $# > 0 ]]; do
        key="$1"

        case $key in
            install)
                command="install"
                shift
                ;;
            list)
                command="list"
                shift
                ;;
            ?|-h|help|--help)
                usage
                exit 0
                ;;
            *)
                if [[ "$command" = "install" ]]; then
                    installList+=($key)
                fi
                shift
                ;;
        esac
    done

    if [[ ${command} != "null" ]]; then
        singleShot=1
    fi
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

    wget -qO $repopath/dests.txt $githubRepo/raw/master/dests.txt
}

function fillListLocal() {
    i=1
    for file in `ls -d */ | grep -v "backups" | cut -d/ -f 1`; do
        conflist[$i]=$file
        let i+=1
    done
}

function backup() {
    if [[ ! -d $repopath/backups/$2 ]]; then
        mkdir -p $repopath/backups/$2
    fi

    mv $1 $repopath/backups/$2
}

function fetchRemoteDirectory() {
    if ! hash svn 2> /dev/null; then
        echo "you need 'svn' to fetch remote directories"
        return 1
    fi

    echo "fetching $1 from remote repository..."
    svn checkout $githubRepo/trunk/$1 && rm -rf $repopath/$1/.svn
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
        installFiles=`find $repopath/$install -maxdepth 1 -printf '%f\n'`
        first=0
        for file in ${installFiles[@]}; do
            if [[ $first -eq 0 ]]; then
                first=1
                continue
            fi
            echo "file: $file"
            if [[ -f $dest/$file ]]; then
                if ! cmp -s $repopath/$install/$file $dest/$file; then
                    echo "backup old config"
                    backup $dest/$file $install
                else
                    echo "Files are the same. Continue next."
                    continue
                fi
            elif [[ -d $dest/$file ]]; then
                rm -rf $repopath/backups/$install
                if [[ ! -L $dest/$file ]]; then
                    echo "backup old config directory"
                    backup $dest/$file $install
                else
                    echo -n "$install/$file configuration is link (already installed?), remove? (Y/n): "
                    read answer
                    if [[ $answer == 'Y' ]]; then
                        rm $dest/$file
                    else
                        echo "can't install configuration: $install/$file"
                        continue
                    fi
                fi
            fi
            
            if ln -s "$repopath/$install/$file" "$dest/$file"; then
                echo "$install/$file linked!"
            else
                echo "Can not create link to configuration $install/$file."
                echo "You can try do it with this command:"
                echo "ln -s $repopath/$install/$file $dest/$file"
            fi
        done
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
            usage
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

    if [[ $singleShot -eq 1 ]]; then
        process
    else
        while true; do
            if [[ $command = "null" ]]; then
                echo -n "enter command: "
                read -a command
            fi

            process

        done
    fi
}

main $@
