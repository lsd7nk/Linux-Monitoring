#!/bin/bash

function checkArg {
    for var in $1 $2 $3 $4
    do
        if ! [[ $var =~ ^-?[0-9]+([.][0-9]+)?$ ]]
        then
            return 3
        elif [[ $var -gt 6 ]] || [[ $var -lt 1 ]]
        then
            return 2
        fi
    done

    if [[ $1 -eq $2 ]] || [[ $3 -eq $4 ]]
    then
        return 1
    else
        return 0
    fi
}

function parseArg {
    findedStringFragmentsCount=0
    errorCount=0

    for var in "column1_background" "column1_font_color" "column2_background" "column2_font_color"
    do
        if [[ $(grep -c $var config.txt) -eq 1 ]]
        then
            findedStringFragmentsCount=$(($findedStringFragmentsCount + 1))
	fi
    done

    if [[ $findedStringFragmentsCount -eq 4 ]]
    then
        column1_background=$(grep column1_background config.txt | awk -F = '{printf("%i", $2)}')
        column1_font_color=$(grep column1_font_color config.txt | awk -F = '{printf("%i", $2)}')
        column2_background=$(grep column2_background config.txt | awk -F = '{printf("%i", $2)}')
        column2_font_color=$(grep column2_font_color config.txt | awk -F = '{printf("%i", $2)}')
    else
        errorCount=$(($errorCount + 1))
    fi

    if [[ $errorCount -gt 0 ]]
    then
        echo "Invalid config"
        exit
    fi

    checkArg $column1_background $column1_font_color $column2_background $column2_font_color
    errorCount=$(($errorCount + $?))

    return $errorCount
}

function withdrawalDecision {
    nameColors=("white" "red" "green" "blue" "purple" "black")

    LeftBC=$column1_background
    LeftFC=$column1_font_color
    RightBC=$column2_background
    RightFC=$column2_font_color

    if [[ $1 -eq 0 ]]
    then
        chmod +x ../03/main.sh && ../03/main.sh $LeftBC $LeftFC $RightBC $RightFC
        echo
        echo Column 1 background = $LeftBC ${nameColors[$LeftBC - 1]}
        echo Column 1 font color = $LeftFC ${nameColors[$LeftFC - 1]}
        echo Column 2 background = $RightBC ${nameColors[$RightBC - 1]}
        echo Column 2 font color = $RightFC ${nameColors[$RightFC - 1]}
    else
        chmod +x ../03/main.sh && ../03/main.sh 6 1 2 4
        echo
        echo Column 1 background = default ${nameColors[5]}
        echo Column 1 font color = default ${nameColors[0]}
        echo Column 2 background = default ${nameColors[1]}
        echo Column 2 font color = default ${nameColors[3]}
    fi
}

parseArg
withdrawalDecision $?
