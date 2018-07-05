#!/usr/bin/env bash
sudo apt-get -y update
sudo apt-get -y install firefox-esr samba xscreensaver unclutter
sudo adduser --system shareuser
sudo mkdir -m 1755 /home/pi/pi-kiosk/kiosk
sudo chown shareuser /home/pi/pi-kiosk/kiosk
sudo wget -O /home/pi/pi-kiosk/kiosk/video.mp4 https://raw.githubusercontent.com/mediaelement/mediaelement-files/master/big_buck_bunny.mp4
sudo /etc/init.d/samba restart
tee /home/pi/autostart.sh > /dev/null <<EOF
#!/usr/bin/env bash
PAGE="file:///home/pi/pi-kiosk/index.html"
firefox-esr -url $PAGE
EOF
tee /home/pi/.config/lxsession/LXDE-pi/autostart > /dev/null <<EOF
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
@xset s noblank
@xset s off
@xset -dpms
@point-rpi
@bash /home/pi/autostart.sh
EOF
