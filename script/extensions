#!/bin/sh

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

printBasePath
# Applets install
cd $main_path/extensions
applets=`ls .`

for applet in $applets
do
    plasmapkg2 -i $applet
done