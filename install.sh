#!/bin/bash

mkdir -p $HOME/.local
mkdir -p $HOME/.local/share
mkdir -p $HOME/.local/share/vunit
mkdir -p $HOME/.local/share/vunit/src

cp ./vunit $HOME/.local/share/vunit/
cp -r ./src/* $HOME/.local/share/vunit/src

echo '$HOME/.local/share/vunit/vunit $@' > $HOME/.local/bin/vunit
chmod +x $HOME/.local/bin/vunit

