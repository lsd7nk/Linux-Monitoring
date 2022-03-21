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

function getData {
    fontColors=("\033[97m" "\033[31m" "\033[32m" "\033[34m" "\033[95m" "\033[30m")
    backgroundColors=("\033[107m" "\033[41m" "\033[42m" "\033[44m" "\033[105m" "\033[40m")

    LeftBC=${backgroundColors[$1 - 1]}
    LeftFC=${fontColors[$2 - 1]}
    RightBC=${backgroundColors[$3 - 1]}
    RightFC=${fontColors[$4 - 1]}
    NC="\e[0m"

    echo -e ${LeftBC}${LeftFC}HOSTNAME${NC} = ${RightBC}${RightFC}$(hostname)${NC}

    # get time zone
    zone=$(timedatectl status | sed -n '4'p | awk '{printf("%s", $3)}')
    utc=$(timedatectl status | sed -n '2'p | awk '{printf("%s", $6)}')
    difference_in_time=$(timedatectl status | sed -n '1'p | awk '{printf("%s", $6)}')
    #

    echo -e ${LeftBC}${LeftFC}TIMEZONE${NC} = ${RightBC}${RightFC}$zone $utc $difference_in_time${NC}
    echo -e ${LeftBC}${LeftFC}USER${NC} = ${RightBC}${RightFC}$(whoami)${NC}
    echo -e ${LeftBC}${LeftFC}OS${NC} = ${RightBC}${RightFC}$(cat /etc/issue | sed -n '1'p | awk '{printf("%s %s", $1, $2)}')${NC}
    echo -e ${LeftBC}${LeftFC}DATE${NC} = ${RightBC}${RightFC}$(date +"%d %b %Y %H:%M:%S")${NC}
    echo -e ${LeftBC}${LeftFC}UPTIME${NC} = ${RightBC}${RightFC}$(uptime -p)${NC}
    echo -e ${LeftBC}${LeftFC}UPTIME_SEC${NC} = ${RightBC}${RightFC}$(cat /proc/uptime | awk '{printf("%s", $1)}')${NC}

    ip=$(ip a | grep inet | sed -n '3'p | awk '{printf("%s", $2)}')

    echo -e ${LeftBC}${LeftFC}IP${NC} = ${RightBC}${RightFC}$ip${NC}
    echo -e ${LeftBC}${LeftFC}MASK${NC} = ${RightBC}${RightFC}$(ipcalc $ip | sed -n '2'p | awk '{printf("%s", $2)}')${NC}
    echo -e ${LeftBC}${LeftFC}GATEWAY${NC} = ${RightBC}${RightFC}$(ip route | sed -n '1'p | awk '{printf("%s", $3)}')${NC}
    echo -e ${LeftBC}${LeftFC}RAM_TOTAL${NC} = ${RightBC}${RightFC}$(free | sed -n '2'p | awk '{printf("%.3f Gb", $2 / 1024 / 1024)}')${NC}
    echo -e ${LeftBC}${LeftFC}RAM_USED${NC} = ${RightBC}${RightFC}$(free | sed -n '2'p | awk '{printf("%.3f Gb", $3 / 1024 / 1024)}')${NC}
    echo -e ${LeftBC}${LeftFC}RAM_FREE${NC} = ${RightBC}${RightFC}$(free | sed -n '2'p | awk '{printf("%.3f Gb", $4 / 1024 / 1024)}')${NC}
    echo -e ${LeftBC}${LeftFC}SPACE_ROOT_USED${NC} = ${RightBC}${RightFC}$(df | sed -n '4'p | awk '{printf("%.3f Gb", $3 / 1024 / 1024)}')${NC}
    echo -e ${LeftBC}${LeftFC}SPACE_ROOT_FREE${NC} = ${RightBC}${RightFC}$(df | sed -n '4'p | awk '{printf("%.3f Gb", $4 / 1024 / 1024)}')${NC}
}

function reboot {
    messageAboutCallScript="Do you want re-invoke script"

    messageAboutInvalidArg="Error: Invalid arg(one of args not a number). ${messageAboutCallScript}."
    messageAboutArgGtNumbSix="Error: One of args gt 6 or lt 1. ${messageAboutCallScript}"
    messageAboutEqArg="Error: Have eq args. ${messageAboutCallScript}"

    messageOfError=""

    if [[ $1 -eq 3 ]]
    then
        messageOfError+=$messageAboutInvalidArg
    elif [[ $1 -eq 2 ]]
    then
        messageOfError+=$messageAboutArgGtNumbSix
    elif [[ $1 -eq 1 ]]
    then
        messageOfError+=$messageAboutEqArg
    fi

    read -p "$messageOfError [Y/N]? " answer

    case $answer in
        [Yy]* ) IFS=' '; declare -a AR; read -p "./main.sh " args; read -a AR <<<"$args"; ./main.sh ${AR[0]} ${AR[1]} ${AR[2]} ${AR[3]};;
        [Nn]* ) exit;;
    esac
}

checkArg $1 $2 $3 $4
resultCheckArg=$?

if [[ $resultCheckArg -eq 3 ]]
then
    reboot 3
elif [[ $resultCheckArg -eq 2 ]]
then
    reboot 2
elif [[ $resultCheckArg -eq 1 ]]
then
    reboot 1
elif [[ $resultCheckArg -eq 0 ]]
then
    sudo apt install ipcalc
    clear
    getData $1 $2 $3 $4
fi


