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
git clone https://aur.archlinux.org/qtcreator-opt-git.git
cd qtcreator-opt-git

# Install depends to build
cat .SRCINFO | grep 'makedepeds =\|depends =' | grep -v 'optdepends =' | awk '{print $3}' | xargs sudo pacman -S --noconfirm

# Get sources
makepkg -o -s --noconfirm

cd "$CWD"

{ set +ex; } 2>/dev/null
