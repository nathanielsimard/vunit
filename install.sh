#!/bin/bash

mkdir -p ~/.local
mkdir -p ~/.local/share
mkdir -p ~/.local/share/vunit
mkdir -p ~/.local/share/vunit/src

cp ./vunit ~/.local/share/vunit/
cp -r ./src/* ~/.local/share/vunit/src

echo '~/.local/share/vunit/vunit $@' > ~/.local/bin/vunit
chmod +x ~/.local/bin/vunit
