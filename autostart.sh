#!/usr/bin/env bash
while true
do
	omxplayer -o hdmi /home/pi/pi-kiosk/kiosk/* 2>> /home/pi/pi-kiosk/error.log 1> /dev/null
done
