#!/bin/bash


index=`pacmd list-sources | grep "* index" | sed 's/ //g' | cut -d ':' -f 2`
if [ "$1" == "up" ]; then
    pactl set-sink-volume $index +5%
elif [ "$1" == "down" ]; then
    pactl set-sink-volume $index -5%
elif [ "$1" == "mute" ]; then
    pactl set-sink-mute $index toggle
fi
