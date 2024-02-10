# Linux Monitoring v1.0

## Introduction

- The written Bash scripts are located in the src folder
- For each task, a folder has been created with the name of the type: **0x**, where x is the task number
- All scripts are decomposed and split into several files
- The file with the main script for each task is called **main.sh**
- All scripts have checks for incorrect input (not all parameters are specified, incorrect format parameters, etc.)

## 1. First effort
The script runs with one parameter. The parameter is text-based.
The script outputs the value of the parameter.
If the parameter is a number, a message about incorrect input is displayed.

## 2. System research
The script displays information on the screen in the form:

**HOSTNAME** = _network name_
**TIMEZONE** = _temporal zone in the form: **America/New_York UTC -5** (the time zone is taken from the system and is correct for the current location)_
**USER** = _the current user who started the script_
**OS** = _ type and version of the operating system_
**DATE** = _the current time in the form: **12 May 2020 12:24:36**_
**UPTIME** = _time of the system_
**UPTIME_SEC** = _time of the system in seconds_
**IP** = _ip address of the machine in any of the network interfaces_
**MASK** = _network mask of any of the network interfaces in the form: **xxx.xxx.xxx.xxx**_
**GATEWAY** = default gateway _ip_
**RAM_TOTAL** = _ RAM size in GB with an accuracy of three decimal places in the form: **3.125 Gb**_
**RAM_USED** = _the size of the memory used in GB with an accuracy of three decimal places_
**RAM_FREE** = _the size of free memory in GB with an accuracy of three decimal places_
**SPACE_ROOT** = _ the size of the root partition in MB with an accuracy of two decimal places in the form: **254.25 MB**_
**SPACE_ROOT_USED** = _the size of the occupied space of the root partition in Mb with an accuracy of two decimal places_
**SPACE_ROOT_FREE** = _ the size of the root partition in MB with an accuracy of two decimal places_

After displaying the values, it is suggested to write the data to a file (the user is asked to answer **Y/N**).
The answers **Y** and **y** are considered positive, all others are negative.
With the user's consent, a file is created in the current directory containing the information that was displayed on the screen.
The file name has the form: **DD_MM_YY_HH_MM_SS.status**(the time in the file name indicates the moment when the data was saved).

## 3. Visual output design for the system research script
The script from "[**2. System research**](#2-system-research)" and the part responsible for saving data to a file has been removed from it.
The script runs with 4 parameters. The parameters are numeric. From 1 to 6, for example:
`script03.sh 1 3 4 5`

Color designations: (1 - white, 2 - red, 3 - green, 4 - blue, 5 – purple, 6 - black)
**Parameter 1** is the background of the value names (HOSTNAME, TIMEZONE, USER, etc.)
**Parameter 2** is the font color of the value names (HOSTNAME, TIMEZONE, USER, etc.)
**Parameter 3** is the background of the values (after the '=' sign)
**Parameter 4** is the font color of the values (after the '=' sign)

The font and background colors of the same column should not match.
When you enter matching values, a message describing the problem is displayed and a suggestion to call the script again.
After the message is displayed, the program terminates correctly.

## Part 4. Configuring visual output design for the system research script
The script from "[**3. Visual output design for the system research script**](#part-3-visual-output-design-for-the-system-research-script)". The color designations are similar.
The script runs without parameters. The parameters are set in the configuration file before running the script.

The configuration file looks like:
```
column1_background=2
column1_font_color=4
column2_background=5
column2_font_color=1
```
If one or more parameters are not specified in the configuration file, then the color is substituted from the default color scheme.

After the system information is output from "[**3. Visual output design for the system research script**](#part-3-visual-output-design-for-the-system-research-script)", the color scheme is displayed as follows:
```
Column 1 background = 2 (red)
Column 1 font color = 4 (blue)
Column 2 background = 5 (purple)
Column 2 font color = 1 (white)
```

When running a script with a default color scheme, the output looks like:
```
Column 1 background = default (black)
Column 1 font color = default (white)
Column 2 background = default (red)
Column 2 font color = default (blue)
```

## 5. File system research
The script runs with one parameter.
A parameter is an absolute or relative path to a directory. The parameter must end with a '/' sign, for example: 
`script05.sh /var/log/`

The script outputs the following information about the directory specified in the parameter:
- The total number of folders, including nested ones
- Top 5 folders with the highest weight in descending order(path and size)
- Total number of files
- The number of configuration files(with the .conf extension), text files, executable files, logs(files with the .log extension), archives, symbolic links
- Top 10 files with the highest weight in descending order(path, size and type)
- Top 10 executable files with the highest weight in descending order(path, size and hash)
- Script execution time

The script displays information on the screen in the form:
```
Total number of folders (including all nested ones) = 6  
TOP 5 folders of maximum size arranged in descending order (path and size):  
1 - /var/log/one/, 100 Gb  
1 - /var/log/two/, 100 Mb  
etc up to 5
Total number of files = 30
Number of:  
Configuration files (with the .conf extension) = 1 
Text files = 10  
Executable files = 5
Log files (with the extension .log) = 2  
Archive files = 3  
Symbolic links = 4  
TOP 10 files of maximum size arranged in descending order (path, size and type):  
1 - /var/log/one/one.exe, 10 Gb, exe  
2 - /var/log/two/two.log, 10 Mb, log  
etc up to 10  
TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file)  
1 - /var/log/one/one.exe, 10 Gb, 3abb17b66815bc7946cefe727737d295  
2 - /var/log/two/two.exe, 9 Mb, 53c8fdfcbb60cf8e1a1ee90601cc8fe2  
etc up to 10  
Script execution time (in seconds) = 1.5
```
