#!/bin/sh

# Commands
declare -A properties
commands=()
commands[0]="--noinstall"
commands[1]="--local"

# Setting ==========================================
# window style name
WINDOW_STYLE_NAME="RoundedSBE"
# ==================================================

# --------------------------------------------------
this_script_path=$0
script_path=$(cd $(dirname $0);pwd)
main_path=$(dirname $script_path)
# --------------------------------------------------

printHelp() {

}

printBasePath() {
    echo "============================="
    echo "Base Path: "
    echo "this_script_path: $this_script_path"
    echo "script_path: $script_path"
    echo "main_path: $main_path"
    echo -e "=============================\n"
}

installSoft() {
    echo "depend pacman"
    echo "Install >>>>>>>>>>>>>>>"
    sudo pacman -Syy kvantum
}

check_params() {
    for command in ${commands[@]};do
        if [[ $command == $1 && $command != '' ]];then
            return 0
        fi
    done
    return 1
}

# param home_apth
localInstallTheme() {
    local home_path=$1
    local local_share_path=$home_path/.local/share
    # Icon
    # cp to /usr/share/icons/
    find $main_path/theme/icons/* -mindepth 1 -type d ! -name './' -exec cp -Rf {} $local_share_path/icons/{}"_icon" \;

    # Cursors
    # cp to /usr/share/icons/*-cursors
    find $main_path/theme/cursors/* -mindepth 1 -type d ! -name './' -exec cp -Rf {} $local_share_path/icons/{}"_cursors" \;

    # plasma Theme
    # cp to /usr/share/plasma/desktoptheme
    cp $main_path/theme/plasma_theme/* $local_share_path/plasma/desktoptheme
}

globalInstallTheme() {
    # Icon
    # cp to /usr/share/icons/
    find $main_path/theme/icons/* -mindepth 1 -type d ! -name './' -exec cp -Rf {} /usr/share/icons/{}"_icon" \;

    # Cursors
    # cp to /usr/share/icons/*-cursors
    find $main_path/theme/cursors/* -mindepth 1 -type d ! -name './' -exec cp -Rf {} /usr/share/icons/{}"_cursors" \;

    # plasma Theme
    # cp to /usr/share/plasma/desktoptheme
    cp $main_path/theme/plasma_theme/* /usr/share/plasma/desktoptheme
}

shareInstallTheme() {
    # gtk_theme
    # cp to /usr/share/themes
    cp $main_path/theme/gtk_theme/* /usr/share/themes

    # sddm
    # /usr/share/sddm/themes
    cp $main_path/theme/sddm_theme/* /usr/share/sddm/themes

    # grub
    # /usr/share/grub/themes
    cp $main_path/theme/grub_theme/* /usr/share/grub/themes

    # Fonts
    # /usr/share/fonts
    cp $main_path/theme/fonts/* /usr/share/fonts
    fc-cache -f -v
}

kvantumInstall() {
    # Kvantum manager
    isExistKey '--noinstall'
    if [[ $? == '0' ]];then
        installSoft
    else 
        echo "Jmp Install"
    fi
}

windowStyleInstall() {
    # window style
    sudo rm -rf /opt/local/kdemodule/$WINDOW_STYLE_NAME
    mkdir -p /opt/local/kdemodule
    cp -Rf $main_path/theme/window_style/$WINDOW_STYLE_NAME /opt/local/kdemodule/
    cd /opt/local/kdemodule/$WINDOW_STYLE_NAME
    sudo ./install.sh
}

setKeyValue() {
    local key=$1
    local value=$2
    if [ -z $value ];then
        properties["$key"]='0'
    else
        properties["$key"]=$value
    fi
}

isExistKey() {
    local i_key=$1
    for key in ${!properties[@]};do
        if [[ $i_key == key ]];then
            return 0
        fi
    done
    return 1
}
# ---------------------------------------------------------
# Main
if [ $1 == 'help' ];then
    printHelp
    exit 0
fi

## init properties
while [[ $# -gt 0 ]];do
    # Check Key
    check_params $1
    if [[ $? == '0' ]];then
        key=$param
    else
        echo "输入s错误"
        exit 1
    fi

    # Check Value
    check_params $2
    if [[ $? == '0' ]];then
        value=''
    else
        value=$2
    fi
        
    setKeyValue $key $value
    if [[ -z $value ]];then; shift 1; else shift 2; fi
    done
done

## Main Flow
isExistKey '--local'
if [[ $? == '0' ]];then
    localInstallTheme "${properties['--local']}"
else 
    globalInstallTheme
fi

shareInstallTheme
kvantumInstall
windowStyleInstall