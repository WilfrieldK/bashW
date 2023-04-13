#!/usr/bin/env bash

_list() {
    if [ -s ${CONFIG_PATH}/entreprise/aliasme/path ];then
        echo "PATH:"
        while read name
        do
            read value
            echo "$name : $value"
        done < ${CONFIG_PATH}/entreprise/aliasme/path
    fi

    if [ -s ${CONFIG_PATH}/entreprise/aliasme/cmd ];then
        echo "CMD:"
        while read name
        do
            read value
            echo "$name : $value"
        done < ${CONFIG_PATH}/entreprise/aliasme/cmd
    fi
}

_path() {
    #read name
    name=$1
    if [ -z $1 ]; then
        read -ep "Input name to add:" name
    fi

    #read path
    path=$2
    if [ -z $2 ]; then
        read -ep "Input path to add:" path
    fi
    path=$(cd $path;pwd)

    echo $name >> ${CONFIG_PATH}/entreprise/aliasme/path
    echo $path >> ${CONFIG_PATH}/entreprise/aliasme/path

    _autocomplete
}

_cmd() {
    #read name
    name=$1
    if [ -z $1 ]; then
        read -ep "Input name to add:" name
    fi

    #read path
    cmd="$2"
    if [ -z "$2" ]; then
        read -ep "Input cmd to add:" cmd
    fi

    echo $name >> ${CONFIG_PATH}/entreprise/aliasme/cmd
    echo $cmd >> ${CONFIG_PATH}/entreprise/aliasme/cmd

    _autocomplete
}

_remove() {
    #read name
    name=$1
    if [ -z $1 ]; then
        read -pr "Input name to remove:" name
    fi

    # read and replace file
    if [ -s ${CONFIG_PATH}/entreprise/aliasme/path ];then
        touch ${CONFIG_PATH}/entreprise/aliasme/pathtemp
        while read line
        do
            if [ $line = $name ]; then
                read line #skip one more line
            else
                echo $line >> ${CONFIG_PATH}/entreprise/aliasme/pathtemp
            fi
        done < ${CONFIG_PATH}/entreprise/aliasme/path
        mv ${CONFIG_PATH}/entreprise/aliasme/pathtemp ${CONFIG_PATH}/entreprise/aliasme/path
    fi
    if [ -s ${CONFIG_PATH}/entreprise/aliasme/cmd ];then
        touch ${CONFIG_PATH}/entreprise/aliasme/cmdtemp
        while read line
        do
            if [ $line = $name ]; then
                read line #skip one more line
            else
                echo $line >> ${CONFIG_PATH}/entreprise/aliasme/cmdtemp
            fi
        done < ${CONFIG_PATH}/entreprise/aliasme/cmd
        mv ${CONFIG_PATH}/entreprise/aliasme/cmdtemp ${CONFIG_PATH}/entreprise/aliasme/cmd
    fi
    _autocomplete
}

_jump() {
    if [ -s ${CONFIG_PATH}/entreprise/aliasme/path ];then
        while read line
        do
            if [ $1 = $line ]; then
                read line
                cd $line
                return 0
            fi
        done < ${CONFIG_PATH}/entreprise/aliasme/path
    fi
    return 1
}

_excute() {
    if [ -s ${CONFIG_PATH}/entreprise/aliasme/cmd ];then
        while read line
        do
            if [ $1 = $line ]; then
                read line
                eval $line
                return 0
            fi
        done < ${CONFIG_PATH}/entreprise/aliasme/cmd
    fi
    return 1
}

_bashauto()
{
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    opts=""
    if [ -s ${CONFIG_PATH}/entreprise/aliasme/path ];then
        while read line
        do
            opts+=" $line"
            read line
        done < ${CONFIG_PATH}/entreprise/aliasme/path
    fi
    if [ -s ${CONFIG_PATH}/entreprise/aliasme/cmd ];then
        while read line
        do
            opts+=" $line"
            read line
        done < ${CONFIG_PATH}/entreprise/aliasme/cmd
    fi
    COMPREPLY=( $(compgen -W "${opts}" ${cur}) )
    return 0
}

_autocomplete()
{
    if [ $ZSH_VERSION ]; then
        # zsh
        opts=""
        if [ -s ${CONFIG_PATH}/entreprise/aliasme/path ];then
            while read line
            do
                opts+="$line "
                read line
            done < ${CONFIG_PATH}/entreprise/aliasme/path
        fi
        if [ -s ${CONFIG_PATH}/entreprise/aliasme/cmd ];then
            while read line
            do
                opts+="$line "
                read line
            done < ${CONFIG_PATH}/entreprise/aliasme/cmd
        fi
        compctl -k "($opts)" al
    else
        # bash
        complete -F _bashauto al
    fi
}

_autocomplete

al(){
    if [ ! -z $1 ]; then
        if [ $1 = "ls" ]; then
            _list
        elif [ $1 = "path" ]; then
            _path $2 $3
        elif [ $1 = "cmd" ]; then
            _cmd $2 "$3"
        elif [ $1 = "rm" ]; then
            _remove $2
        elif [ $1 = "-h" ]; then
            echo "Usage:"
            echo "al path [name] [value]       # add alias path with name"
            echo "al cmd [name] [command]      # add alias command with name"
            echo "al rm [name]                 # remove alias by name"
            echo "al ls                        # alias list"
            echo "al [name]                    # execute alias associate with [name]"
            echo "al -v                        # version information"
            echo "al -h                        # help"
        elif [ $1 = "-v" ]; then
            echo "aliasme 2.0.0"
            echo "visit https://github.com/Jintin/aliasme for more information"
        else
            if ! _jump $1 && ! _excute $1 ; then
                echo "not found"
            fi
        fi
    fi
}
