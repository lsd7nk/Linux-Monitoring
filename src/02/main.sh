#!/bin/bash

fileName="data.txt"

function setData {
    sudo timedatectl set-timezone Asia/Novosibirsk
    sudo apt install ipcalc
    sudo apt install tee
    clear

    hostname=$(hostname)
    
    # get time zone
    zone=$(timedatectl status | sed -n '4'p | awk '{printf("%s", $3)}')
    utc=$(timedatectl status | sed -n '2'p | awk '{printf("%s", $6)}')
    difference_in_time=$(timedatectl status | sed -n '1'p | awk '{printf("%s", $6)}')
    #

    timezone="$zone $utc $difference_in_time" 
    user=$(whoami)
    os=$(cat /etc/issue | sed -n '1'p | awk '{printf("%s %s", $1, $2)}')
    date=$(date +"%d %b %Y %H:%M:%S")
    uptime=$(uptime -p)
    uptime_sec=$(cat /proc/uptime | awk '{printf("%s", $1)}')
    ip=$(ip a | grep inet | sed -n '3'p | awk '{printf("%s", $2)}')
    mask=$(ipcalc $ip | sed -n '2'p | awk '{printf("%s", $2)}')
    gateway=$(ip route | sed -n '1'p | awk '{printf("%s", $3)}')
    ram_total=$(free | sed -n '2'p | awk '{printf("%.3f Gb", $2 / 1024 / 1024)}')
    ram_used=$(free | sed -n '2'p | awk '{printf("%.3f Gb", $3 / 1024 / 1024)}')
    ram_free=$(free | sed -n '2'p | awk '{printf("%.3f Gb", $4 / 1024 / 1024)}')
    space_root_used=$(df | sed -n '4'p | awk '{printf("%.3f Gb", $3 / 1024 / 1024)}')
    space_root_free=$(df | sed -n '4'p | awk '{printf("%.3f Gb", $4 / 1024 / 1024)}')
}

function getData {
    touch $fileName

    echo "HOSTNAME = $hostname" | tee -a $fileName
    echo "TIMEZONE = $timezone" | tee -a $fileName
    echo "USER = $user" | tee -a $fileName
    echo "OS = $os" | tee -a $fileName
    echo "DATE = $date" | tee -a $fileName
    echo "UPTIME = $uptime" | tee -a $fileName
    echo "UPTIME_SEC = $uptime_sec" | tee -a $fileName
    echo "IP = $ip" | tee -a $fileName
    echo "MASK = $mask" | tee -a $fileName
    echo "GATEWAY = $gateway" | tee -a $fileName
    echo "RAM_TOTAL = $ram_total" | tee -a $fileName
    echo "RAM_USED = $ram_used" | tee -a $fileName
    echo "RAM_FREE = $ram_free" | tee -a $fileName
    echo "SPACE_ROOT_USED = $space_root_used" | tee -a $fileName
    echo "SPACE_ROOT_FREE = $space_root_free" | tee -a $fileName

    read -p "Do you want save data to file '$fileName' [Y/N]? " answer

    case $answer in
        [Yy]* ) mv $fileName $(date '+%d_%m_%Y_%H_%M_%S').status;;
        [Nn]* ) rm -rf $fileName;;
    esac
}

setData
getData
