#!/bin/bash

set -e

source functions.sh

if [ -z ${deb_pkg}  ]; then
export deb_pkg=0
fi

build_firefox() {
    # Copy configuration
    echo "Copying mozconfig..."
    cp ../mozconfig .
    ./mach configure

    echo "Starting build..."
    ./mach build

    echo "Packaging..."
    ./mach package
}

setup_and_build() {
    if [ ! -d $srcdir ]; then
        echo "Cloning repository..."
        sync_ver
        cd $srcdir
        #bootstrap
        ./mach --no-interactive bootstrap --application-choice browser
        build_firefox
    else
        cd $srcdir
        build_firefox
    fi

    cd ..

    if [[ $deb_pkg == 1 ]]; then
        echo "building .deb"
        build_deb
    elif [[ -z $deb_pkg || $deb_pkg == 0 ]]; then
        echo "not building .deb"
    fi
}

# Main execution
setup_and_build
