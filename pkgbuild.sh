#!/bin/bash

set -ex

# Environment variables.
export PACKAGER="https://travis-ci.org/${1}/builds/${2}"
export AURDEST="$(pwd)/src"
export VSCODE_NONFREE=1

# Variables declaration.
declare -a pkglist=()
declare -a pkgkey=()

# Remove comments or blank lines.
for file in "pkglist" "pkgkeys"; do
  sed -i -e "/\s*#.*/s/\s*#.*//" -e "/^\s*$/d" ${file}
done

# Create pkglist based on .gitmodules
cat .gitmodules | grep aur.archlinux.org | grep -v '^#' | sed 's|^.*/\(.*\)\.git$|\1|' > pkglist

# Load files.
mapfile pkglist < "pkglist"
mapfile pkgkeys < "pkgkeys"

# Remove packages from repository.
cd "bin"
while read pkg; do
  repo-remove "qtcreator-opt.db.tar.gz" ${pkg}
done < <(comm -23 <(pacman -Sl "qtcreator-opt" | cut -d" " -f2 | sort) <(aurchain ${pkglist[@]} | sort))
cd ".."

# Get package gpg keys.
for key in ${pkgkeys[@]}; do
  gpg --recv-keys --keyserver hkp://pgp.mit.edu ${key}
done

# Build outdated packages.
aursync --repo "qtcreator-opt" --root "bin" -nr ${pkglist[@]}

{ set +ex; } 2>/dev/null
