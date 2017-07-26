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

CWD=`pwd`

cd "src"
cd qtcreator-opt-git

list=`ls *.pkg.tar.xz`
mv *.pkg.tar.xz "$CWD/bin/"

cd "$CWD/bin"
repo-remove "qtcreator-opt.db.tar.gz" qtcreator-opt-git qtcreator-opt-git-debug
repo-add "qtcreator-opt.db.tar.gz" $list

# Update pacman cache
sudo pacman -Sy

cd "$CWD"

{ set +ex; } 2>/dev/null
