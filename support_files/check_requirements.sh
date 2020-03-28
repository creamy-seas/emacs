#!/usr/bin/env bash

# Package dependencies
while read -r dependency; do
    if [ -z $(which "$dependency") ]; then
	echo ">>>> Missing $dependency"
    fi
done < $1

# ttf dependencies
while read -r ttfdependency; do
    if [ -z "$(fc-list | grep "$ttfdependency")" ]; then
	echo ">>>> Missing $ttfdependency"
    fi
done < $2
