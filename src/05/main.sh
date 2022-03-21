#!/bin/bash

path=$1

function print {
    echo $1
}

function  printTenExecOfMaxSize  {
    print ""
    print "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):" 
    
    i=1 

    for ((var=2; var<=11; var++))
    do
        name=$(ls -l $path | sed -n "$var"p | awk '{printf("%s", $9)}')
        size=$(ls -l $path | sed -n "$var"p | awk '{printf("%s", $5 / 1024)}')

        if ! [ -z "$name" ] && ! [ -z "$size" ]
        then
             if ! [[ -d "$name" ]] && [[ "${name##*.}" = "exe" ]]
             then
                 hash=$(md5sum "$path$name" | awk '{printf("%s", $1)}')
                 print "$i - $path$name, $size Kb, $hash"
                 i=$(($i + 1))
             fi
        fi
    done

    print ""
}

function printTenFilesOfMaxSize {
    print ""
    print "TOP 10 files of maximum size arranged in descending order (path, size and type):" 
    
    i=1 

    for ((var=2; var<=11; var++))
    do
        name=$(ls -l $path | sed -n "$var"p | awk '{printf("%s", $9)}')
        size=$(ls -l $path | sed -n "$var"p | awk '{printf("%s", $5 / 1024)}')

        if ! [ -z "$name" ] && ! [ -z "$size" ]
        then
             if ! [[ -d "$path$name" ]]
             then
                 print "$i - $path$name, $size Kb, ${name##*.}"
                 i=$(($i + 1))
             fi
        fi
    done
}

# *.conf *.txt *.exec *.log *.tar *symlink
function printFilesExtensionsCount {
    confCount=0
    txtCount=0
    exeCount=0
    logCount=0
    tarCount=0
    symlinkCount=0

    print ""
    print "Number of:"
    
    for file in $1*
        do
            if [[ -f "$file" ]]
            then
                if [[ "${file##*.}" = "conf" ]]
                then
                    confCount=$(($confCount + 1))
                elif [[ "${file##*.}" = "txt" ]]
                then
                    txtCount=$(($txtCount + 1))
                elif [[ "${file##*.}" = "exe" ]]
                then
                    exeCount=$(($exeCount + 1))
                elif [[ "${file##*.}" = "log" ]]
                then
                    logCount=$(($logCount + 1))
                elif [[ "${file##*.}" = "tar" ]]
                then
                    tarCount=$(($tarCount + 1))
                fi
            elif [[ -L "$file" ]]
            then
                symlinkCount=$(($symlink + 1))
            fi
        done

    print "Configuration files (with the .conf extension) = $confCount"
    print "Text files = $txtCount"
    print "Executable files = $exeCount"
    print "Log files (with the extension .log) = $logCount"
    print "Archive files = $tarCount"
    print "Symbolic links = $symlinkCount"
}

# Total number of files
function printTotalNumberOfFiles {
    fileCount=0

    for file in $1*
        do
            if [[ -f "$file" ]]
            then
                fileCount=$(($fileCount + 1))
            fi
        done

    print ""
    print "Total number of files = $fileCount"
}


# TOP 5 folders of maximum size arranged in descending order (path and size)
function printFiveFoldersOfMaxSize {

    print ""
    print "TOP 5 folders of maximum size arranged in descending order (path and size):"

    i=1

    for ((var=2; var<=11; var++))
    do
        pathDir=$(du -m $path | sort -n | sed -n "$var"p | awk '{printf("%s", $2)}')
        size=$(du -m $path | sort -n | sed -n "$var"p | awk '{printf("%s", $1)}')

        if ! [ -z "$pathDir" ] && ! [ -z "$size" ]
        then
            print "$i - $pathDir, $size Mb"
            i=$(($i + 1))
        fi
    done
}

# Total number of folders (including all nested ones) = 6
function printTotalNumberOfFolders {
    dirCount=0

    for file in $1*
        do
            if [[ -d "$file" ]]
            then
                dirCount=$(($dirCount + 1))
            fi
        done

    print "Total number of folders (including all nested ones) = $dirCount"
}

function checkArg {
    if [[ -d "$path" ]]
    then
        endOfPath=$(echo $1 | tail -c 2)

        if [[ "$endOfPath" = "/" ]]
        then
            return 0
        else
            return 1
        fi
    else
        return 2
    fi
}

function main {
    checkArg $path

    if [[ $? -eq 0 ]]
    then
        startExecutionTime=$(date +"%s.%N")

        printTotalNumberOfFolders $path
        printFiveFoldersOfMaxSize $path
        printTotalNumberOfFiles $path
        printFilesExtensionsCount $path
        printTenFilesOfMaxSize $path
        printTenExecOfMaxSize $path
        
        endExecutionTime=$(date +"%s.%N")

        executionTime=$(bc <<< "$startExecutionTime - $endExecutionTime")
        printExecutionTime=$(echo "$executionTime" | sed 's/-/0/g')

        print "Script execution time (in seconds) = $printExecutionTime"
    else
        print "Error: End of path != '/' || Directory isn't exist"
    fi
}

main
