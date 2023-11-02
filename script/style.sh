#!/bin/sh

# pargma$1 请输入 0 来执行安装模式

# --------------------------------------------------
this_script_path=$0
script_path=$(cd $(dirname $0);pwd)
main_path=$(dirname $script_path)
# --------------------------------------------------

# --------------------------------------------------
config_path=$main_path/desktop_style_config
# --------------------------------------------------

printBasePath() {
    echo "============================="
    echo "Base Path: "
    echo "this_script_path: $this_script_path"
    echo "script_path: $script_path"
    echo "main_path: $main_path"
    echo -e "=============================\n"
}

initConfigDirectory() {
    rm -rf $main_path/desktop_style_config
    mkdir -p $main_path/desktop_style_config
}

# pargma1 SourceDir
copyConfig() {
    initConfigDirectory
    sys_config_path=$1
    # plasma config
    cp -rf "$sys_config_path/plasma-org.kde.plasma.desktop-appletsrc" "$config_path/"
    cp -rf "$sys_config_path/plasmarc" "$config_path/"
    cp -rf "$sys_config_path/plasmashellrc" "$config_path/"
    cp -rf "$sys_config_path/kdeglobals" "$config_path/"
    cp -rf "$sys_config_path/kdedefaults" "$config_path/"

    # kwin condig
    cp -rf "$sys_config_path/kwinrc" "$config_path/"
    cp -rf "$sys_config_path/kwinrulesrc" "$config_path/"
}

# pargma1 sys_config_path Target Dir
setStyle() {
    local sys_config_path=$1
    cp -Rf $config_path/* $sys_config_path
}

# Main
printBasePath

if [ $1 == 'copy' ];then
    # $2 sysConfigDir
    copyConfig $2
elif [ $1 == '0' ];then
    setStyle $2
else
    echo -e ">>>! command input Error!!!\n"
fi