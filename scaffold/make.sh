#!/bin/bash

TEMP_DIR=./out
TRASH_DIR=~/.Trash/
SCAFFOLD="ruby txqs_scaffold.rb"

function create() {
    echo "Create temp directory..."
    if [[ -e $TEMP_DIR ]]; then
        mv $TEMP_DIR $TRASH_DIR/tmp_${RANDOM}
    fi
    mkdir $TEMP_DIR 

   dirs=(model view controller logic delegate datasource item)
   for p in ${dirs[*]}; do
       mkdir $TEMP_DIR/$p
   done
}

function init() {
    echo "Init the temp directory..."
    $($SCAFFOLD)
}

function to_target() {
    echo "Copy the file in temp directory to target directory..."   
    for f in $TEMP_DIR/*; do
        mv $f $1
    done
    rm -rf $TEMP_DIR
}

function start() {
    create
    init
    to_target $1
}

if [[ -z $1 ]]; then
    echo "The target directory is lost."
else
    if [[ -e $1 ]]; then
        read -p "The target directory is exist, this may overwrite it. Are you sure? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mv $1 $TRASH_DIR/out_${RANDOM}
            mkdir -p $1
            start $1
        else
            echo 'Nothing happend.'
        fi
    else
        mkdir -p $1
        start $1
    fi
fi

unset create
unset init
#unset to_target
#unset start
