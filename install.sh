#!/bin/bash

localisation=$1

mkdir -p $localisation
mkdir -p $localisation/share
mkdir -p $localisation/share/vunit
mkdir -p $localisation/share/vunit/src

cp ./vunit $localisation/share/vunit/
cp -r ./src/* $localisation/share/vunit/src

echo $localisation'/share/vunit/vunit $@' > $localisation/bin/vunit
chmod +x $localisation/bin/vunit

