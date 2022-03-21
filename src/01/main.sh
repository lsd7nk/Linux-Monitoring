#!/bin/bash

if ! [[ $1 =~ ^-?[0-9]+([.][0-9]+)?$ ]]
then
    echo $1
else
    echo "Invalid input"
fi
