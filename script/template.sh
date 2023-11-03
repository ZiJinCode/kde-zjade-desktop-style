#!/bin/sh

# ========== Setting Variable ==========
SCRIPT_NAME=desktop_style_script
WINDOW_STYLE_NAME="RoundedSBE"
# ======================================


# --------------------------------------
# ---------- Main Variable ----------

MAIN_PATH="$(dirname $(cd $(dirname $0);pwd))"
SCRIPT_PATH="$MAIN_PATH/script"
SCRIPT_FILE_PATH="$SCRIPT_PATH/$(basename $0)"

DESKTOP_STYLE_CONFIG="$MAIN_PATH/desktop_style_config"

declare -A properties
commands=()
# -----------------------------------


# -------------- Base Function --------------
printVariable() {
    echo ">>> ==================================="
    echo ">>> MAIN_PATH: $MAIN_PATH"
    echo ">>> SCRIPT_PATH: $SCRIPT_PATH"
    echo ">>> SCRIPT_FILE_PATH: $SCRIPT_FILE_PATH"
    echo ">>> ==================================="
}

printProperties() {
    # Print Properties
    echo ">>> ==================================="
    for key in ${!properties[@]};do
        echo "K: $key -> V: ${properties["$key"]}}"
    done
    echo ">>> ==================================="
}

# param1: command
check_command() {
    local i_command=$1
    for command in ${commands[@]};do
        if [[ $command == $i_command ]];then
            return 0
        fi
    done
    return 1
}

# param1: key
# param2: value
setProperty() {
    properties["$1"]=$2
}

# param1: key
isExistKey() {
    local i_key=$1
    for key in ${!properties[@]};do
        if [[ $i_key == $key ]];then
            return 0
        fi
    done
    return 1
}

# -------------------------------------------

# param1: config path
copyConfig() {
    local SYS_CONFIG_PATH=$1

    if [[ -d "$DESKTOP_STYLE_CONFIG" ]];then
        rm -rf $DESKTOP_STYLE_CONFIG
    fi

    mkdir -p $DESKTOP_STYLE_CONFIG

    # plasma config
    cp -rf "$SYS_CONFIG_PATH/plasma-org.kde.plasma.desktop-appletsrc" "$config_path/"
    cp -rf "$SYS_CONFIG_PATH/plasmarc" "$DESKTOP_STYLE_CONFIG/"
    cp -rf "$SYS_CONFIG_PATH/plasmashellrc" "$DESKTOP_STYLE_CONFIG/"
    cp -rf "$SYS_CONFIG_PATH/kdeglobals" "$DESKTOP_STYLE_CONFIG/"
    cp -rf "$SYS_CONFIG_PATH/kdedefaults" "$DESKTOP_STYLE_CONFIG/"

    # kwin condig
    cp -rf "$SYS_CONFIG_PATH/kwinrc" "$DESKTOP_STYLE_CONFIG/"
    cp -rf "$SYS_CONFIG_PATH/kwinrulesrc" "$DESKTOP_STYLE_CONFIG/"
}

# param1: config path
setStyle() {
    local SYS_CONFIG_PATH=$1
    sudo cp -Rf $DESKTOP_STYLE_CONFIG/* $SYS_CONFIG_PATH
}

# Main
printVariable
printProperties

## Init Properties
while [[ $# -gt 0 ]];do
    # Key
    check_command $1
    if [[ $? == '0' ]];then
        key=$1
    else
        echo "没有这个命令"
        exit 1
    fi

    # Value
    check_command $2
    if [[ $? == '0' ]];then
        value=''
    else
        if [[ -z $2 ]];then
            value=''
        else
            value=$2
        fi
    fi

    setProperty $key $value
    if [[ -z $value ]];then shift 1; else shift 2; fi 
done

## Main Flow
isExistKey '--copy'
if [[ $? == '0' ]];then 
    copyConfig "${properties['--copy']}"
fi

isExistKey 'run'
if [[ $? == '0' ]];then
    setStyle "${properties['run']}"
else
    echo -e "!!!ERROR: command"
fi