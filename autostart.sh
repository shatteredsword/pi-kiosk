#!/usr/bin/env bash
while true
do
	omxplayer -o hdmi kiosk/* 2>> error.log 1> /dev/null
done
