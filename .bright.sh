#!/bin/bash

if [ "$1" == "up" ]; then
    brightnessctl set -d "intel_backlight" "10%+"
else 
    brightnessctl set -d "intel_backlight" "10%-"
fi
