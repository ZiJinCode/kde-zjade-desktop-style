#!/bin/sh

# pargma 有参则屏蔽安装软件流程 参数随意 例：command.sh 1 or a or b ...

# window style name
WINDOW_STYLE_NAME="RoundedSBE"

# default install
# + theme
#   + icon
#   + cursors
#   + fonts
#   + plasma theme
#   + gtk theme
#   + kvantum theme
#   + sddm theme
#   + grub theme
#   + window style
# + extensions
# + desktop_style_config

# --------------------------------------------------
this_script_path=$0
script_path=$(cd $(dirname $0);pwd)
main_path=$(dirname $script_path)
# --------------------------------------------------

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

# Icon
# cp to /usr/share/icons/
find $main_path/theme/icons/* -mindepth 1 -type d ! -name './' -exec cp -Rf {} /usr/share/icons/{}"_icon" \;
# Cursors
# cp to /usr/share/icons/*-cursors
find $main_path/theme/cursors/* -mindepth 1 -type d ! -name './' -exec cp -Rf {} /usr/share/icons/{}"_cursors" \;

# plasma Theme
# cp to /usr/share/plasma/desktoptheme
cp $main_path/theme/plasma_theme/* /usr/share/plasma/desktoptheme

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

# Kvantum manager
if [ -z $1 ];then
    installSoft
else 
    echo "Jmp Install"
fi

# window style
sudo rm -rf /opt/local/kdemodule/$WINDOW_STYLE_NAME
mkdir -p /opt/local/kdemodule
cp -Rf $main_path/theme/window_style/$WINDOW_STYLE_NAME /opt/local/kdemodule/
cd /opt/local/kdemodule/$WINDOW_STYLE_NAME
sudo ./install.sh