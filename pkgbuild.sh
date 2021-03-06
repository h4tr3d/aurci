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
aursync --repo "qtcreator-opt" --root "bin" -nr ${pkglist[@]}

{ set +ex; } 2>/dev/null
