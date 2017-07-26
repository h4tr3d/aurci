#!/bin/bash

set -ex

# Variables declaration.
declare pkgslug="${1}"
declare pkgtag="${2}"

# Download or create repository database for "qtcreator-opt"
cd "bin"
if curl -f -L "https://github.com/${pkgslug}/releases/download/${pkgtag}/qtcreator-opt.{db,files}.tar.gz" -o "qtcreator-opt.#1.tar.gz"; then
  ln -s "qtcreator-opt.db.tar.gz" "qtcreator-opt.db"
  ln -s "qtcreator-opt.files.tar.gz" "qtcreator-opt.files"
else
  rm -f "qtcreator-opt.db.tar.gz" "qtcreator-opt.files.tar.gz"
  repo-add "qtcreator-opt.db.tar.gz"
fi
cd ".."

# Enable "multilib" repository.
sudo sed -i -e "/\[multilib\]/,/Include/s/^#//" "/etc/pacman.conf"

# Add configuration for repository "qtcreator-opt".
sudo tee -a "/etc/pacman.d/qtcreator-opt" << EOF
[options]
CacheDir = /var/cache/pacman/pkg
CacheDir = /home/pkguser/bin
CleanMethod = KeepCurrent

[qtcreator-opt]
SigLevel = Optional TrustAll
Server = file:///home/pkguser/bin
Server = https://github.com/${pkgslug}/releases/download/${pkgtag}
EOF

# Add repository "aurutilsci" and include "qtcreator-opt".
sudo tee -a "/etc/pacman.conf" << EOF

[aurutilsci]
SigLevel = Optional TrustAll
Server = https://github.com/localnet/aurutilsci/releases/download/repository

Include = /etc/pacman.d/qtcreator-opt
EOF

# Sync repositories and install "aurutils".
sudo pacman -Sy --noconfirm aurutils

{ set +ex; } 2>/dev/null
