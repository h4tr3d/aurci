#!/bin/bash

set -ex

# Environment variables.
export PACKAGER="https://travis-ci.org/${1}/builds/${2}"
export AURDEST="$(pwd)/src"
export VSCODE_NONFREE=1

# Variables declaration.
declare -a pkglist=()
declare -a pkgkey=()

# Load files.
mapfile pkglist < "pkglist"
mapfile pkgkeys < "pkgkeys"

# Build outdated packages.
#aursync --repo "qtcreator-opt" --root "bin" -nr ${pkglist[@]}

CWD=`pwd`

cd "src"
cd qtcreator-opt-git

# Check, that already build
count=`ls *.pkg.tar.xz 2>/dev/null | wc -l`

if [ $count -eq 2 ]; then
    # just repackage...
    makepkg -R
else
    # Build, using existing srcdir
    set +e
    timeout 30m makepkg -e
    status=$?
    if [ $status -ne 0 -or $status -ne 124 ]; then
        exit 1
    fi
    set -e
fi

cd "$CWD"

{ set +ex; } 2>/dev/null
