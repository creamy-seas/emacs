#!/usr/bin/env bash

BASE_DIR=$(pwd)
FIRA_BUILD_DIR=$(pwd)/fira-code-emacs
FIRA_EL_DIR=$(pwd)/manual_el/fira-code

echo "🐋 Cloning from git"
git clone https://github.com/johnw42/fira-code-emacs $FIRA_BUILD_DIR
echo "----------"

echo "🐋 Building"
cd $FIRA_BUILD_DIR
make
echo "----------"

echo "🐋 Copying over el files"
mkdir -p $FIRA_EL_DIR/fonts
cp fira-code-data.el $FIRA_EL_DIR
cp fira-code.el $FIRA_EL_DIR
cp ligature-font.el $FIRA_EL_DIR
cp -r modified/* $FIRA_EL_DIR/fonts
echo "----------"

rm -rf $FIRA_BUILD_DIR
