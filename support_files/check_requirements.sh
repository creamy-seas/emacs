#!/usr/bin/env bash

while read -r dependency; do
    if [ -z $(which "$dependency") ]; then
	echo ">>>> Missing $dependency"
    fi
done < $1
