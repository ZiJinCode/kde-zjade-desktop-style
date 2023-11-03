#!/bin/sh

# ========== Setting Variable ==========
SCRIPT_NAME=theme_script
WINDOW_STYLE_NAME="RoundedSBE"
# ======================================

# --------------------------------------
# ---------- Main Variable ----------

MAIN_PATH="$(dirname $(cd $(dirname $0);pwd))"
SCRIPT_PATH="$MAIN_PATH/script"
SCRIPT_FILE_PATH="$SCRIPT_PATH/$(basename $0)"

THEME_PATH="$MAIN_PATH/theme"

declare -A properties
commands=()
commands[0]='--local'
commands[1]='--kvantum_no_install'
commands[2]='--roundedsbe_dep_no_install'
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

# param Home_Path
localInstallTheme() {
    local HOME_PATH=$1
    local SHARE_PATH="$HOME_PATH/.local/share"

    # Icon
    # cp to /usr/share/icons/
    for dir_path in "$THEME_PATH/icons"/*;do
        new_dir_name="$(basename $dir_path)-icon"
        cp -Rf $dir_path $SHARE_PATH/icons/$new_dir_name
    done

    # Cursors
    # cp to /usr/share/icons/*-cursors
    for dir_path in "$THEME_PATH/cursors"/*;do
        new_dir_name="$(basename $dir_path)-cursors"
        cp -Rf $dir_path $SHARE_PATH/icons/$new_dir_name
    done

    # plasma Theme
    # cp to /usr/share/plasma/desktoptheme
    for dir_path in "$THEME_PATH/plasma_theme"/*;do
        cp -Rf $dir_path $SHARE_PATH/icons/
    done
}

globalInstallTheme() {
    # Icon
    # cp to /usr/share/icons/
    for dir_path in "$THEME_PATH/icons"/*;do
        new_dir_name="$(basename $dir_path)-icon"
        sudo cp -Rf $dir_path /usr/share/icons/$new_dir_name
    done

    # Cursors
    # cp to /usr/share/icons/*-cursors
    for dir_path in "$THEME_PATH/cursors"/*;do
        new_dir_name="$(basename $dir_path)-cursors"
        sudo cp -Rf $dir_path /usr/share/icons/$new_dir_name
    done

    # plasma Theme
    # cp to /usr/share/plasma/desktoptheme
    for dir_path in "$THEME_PATH/plasma_theme"/*;do
        sudo cp -Rf $dir_path /usr/share/plasma/desktoptheme/
    done
}

shareInstallTheme() {
    # gtk_theme
    # cp to /usr/share/themes
    sudo cp -Rf $THEME_PATH/gtk_theme/* /usr/share/themes

    # sddm
    # /usr/share/sddm/themes
    sudo cp -Rf $THEME_PATH/sddm_theme/* /usr/share/sddm/themes

    # grub
    # /usr/share/grub/themes
    sudo cp -Rf $THEME_PATH/grub_theme/* /usr/share/grub/themes

    # Fonts
    # /usr/share/fonts
    sudo cp -Rf $THEME_PATH/fonts/* /usr/share/fonts
    sudo fc-cache -f -v
}

# param HomePath
kvantumInstall() {
    local HOME_PATH=$1
    # Kvantum manager
    isExistKey '--noinstall'
    if [[ $? == '0' ]];then
        echo "Jmp Install"
    else 
        echo "depend pacman"
        echo "Install >>>>>>>>>>>>>>>>>>>>>>>>"
        sudo pacman -Syy kvantum
    fi

    if [ ! -d "$HOME_PATH/.config/Kvantum" ];then
        echo "!!!ERROR: 不存在!!! $HOME_PATH/.config/Kvantum"
        echo ">>> 已创建"
        mkdir $HOME_PATH/.config/Kvantum
    fi

    sudo cp -Rf $THEME_PATH/kvantum_theme/* $HOME_PATH/.config/Kvantum
}

windowStyleInstall() {
    # window style
    if [ ! -d "/opt/local/kdemodule" ];then
        sudo mkdir -p /opt/local/kdemodule
    fi

    if [ -d "/opt/local/kdemodule/$WINDOW_STYLE_NAME" ];then
        sudo rm -rf /opt/local/kdemodule/$WINDOW_STYLE_NAME
    fi

    sudo cp -Rf $THEME_PATH/window_style/$WINDOW_STYLE_NAME /opt/local/kdemodule/

    isExistKey '--roundedsbe_dep_no_install'
    if [[ $? != '0' ]];then
        sudo pacman -Syy git make cmake gcc gettext extra-cmake-modules qt5-tools kcrash kglobalaccel kde-dev-utils kio knotifications kinit kwin kdecoration qt5-declarative qt5-x11extras
    fi

    cd /opt/local/kdemodule/$WINDOW_STYLE_NAME
    sudo ./install.sh
}

# Main --------------------------------

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
isExistKey '--local'
if [[ $? == '0' ]];then
    localInstallTheme "${properties['--local']}"
else 
    globalInstallTheme
fi

shareInstallTheme
kvantumInstall "${properties['--local']}"
windowStyleInstall