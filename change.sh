#!/usr/bin/bash
# Add this file to you respective rc file
# If you are using bash then .bashrc if zsh then .zshrc


# Change the background type to image from
# Preferences -> Appearance -> Background
# Change this to your desired folder of images
path=$HOME/Pictures/terminal


# default config files
xfce_conf_path=$HOME/.config/xfce4/terminal
config=$xfce_conf_path"/terminalrc"


# This will create a terminalrc file if doesn't exists and if exists it will just update its timestamp
touch $config

# This stores a copy of your current config so if you messed up you can easily get things to default
if [[ `ls $xfce_conf_path | grep "terminalrc.bak"` == "" ]]; then
       cp $xfce_conf_path/terminalrc $xfce_conf_path/terminalrc.bak
fi       


# Getting all image files that are supported by xfce4-terminal
# Using this approach to avoid picking up directories and wrong files 
files=($(ls $path | grep ".png"))
files+=($(ls $path | grep ".jpg"))
files+=($(ls $path | grep ".jpeg"))

len=${#files[@]}

index=$[ $RANDOM % $len ]

file=${files[$index]}

# This the old string we need to replace
# This is really a hacky way to do it
old_line=`cat $config | grep "BackgroundImageFile=.*"` 

# If the BackgroundImageFile isn't in the file then we will append our values in it
# This will probably because the user hasn't used terminal background before
if [[ "$old_line" == "" ]]; then
	if [[ `cat $config | grep "[Configuration]"` == "" ]]; then
		echo "[Configuration]" >> $config
	fi
	echo "BackgroundImageFile="$path/$file >> $config
	echo "BackgroundImageStyle=TERMINAL_BACKGROUND_STYLE_STRETCHED" >> $config
else


	# New path image path
	new_line="BackgroundImageFile="$path/$file

	# Changing the old line with new line and I used '+' as a separator as our path contains '/'
	sed  -i "s+${old_line}+${new_line}+" $config

	# Making the terminal background image streched
	sed -i "s/BackgroundImageStyle=.*/BackgroundImageStyle=TERMINAL_BACKGROUND_STYLE_STRETCHED/" $config
fi

