#!/bin/bash

set -e

source functions.sh

export deb_pkg=1

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
    if [ ! -d mozilla-unified ]; then
        echo "Downloading bootstrap script..."
        wget https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py -O bootstrap.py

        echo "Setting up repository..."
        python bootstrap.py --application-choice=browser --no-interactive
    fi

    cd mozilla-unified
    sync_ver
    build_firefox
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
