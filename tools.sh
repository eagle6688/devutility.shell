#!/bin/sh

function check_file(){
    local -r file="$1"

    if [ ! -e "$file" ]
    then
        echo "$file not found!"
        return 1;
    fi

    return 0;
}

function create_dir(){
    local -r dir="$1"

    if [ ! -e "$dir" ]
    then
        mkdir -p "$dir"
        echo "Create directory $dir"
    fi
}

function extract_file(){
    local -r file="$1"
    local -r targetDir="$2"
    local -r gzDeep=$3
    
    create_dir $targetDir
    tar -xzf "${file}" --strip-components $gzDeep -C "${targetDir}"
    echo "Extract $file to $targetDir"
}

function ln_file(){
    local -r file="$1"
    local -r target="$2"
    ln -sf "$file" "$target"
    echo "Create a soft link from $file to $target"
}

function executable_file(){
    local -r file="$1"
    chmod +x $file
    echo "Make $file executable"
}

function move(){
    local -r source="$1"
    local -r target="$2"
    mv -f $source $target
    echo "Move ${source} to ${target}"
}

function copytodir(){
    local -r source="$1"
    local -r target="$2"
    create_dir "$target"
    cp -rf "$source" "$target"
    echo "Copy from $source to $target"
}

function remove(){
    local -r target="$1"
    rm -rf $target
    echo "Remove $target"
}