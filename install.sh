#!/usr/bin/env bash
sudo apt-get -y update
sudo apt-get -y install firefox-esr samba xscreensaver unclutter
sudo adduser --system shareuser
sudo mkdir -m 1755 /home/pi/pi-kiosk/kiosk
sudo chown shareuser /home/pi/pi-kiosk/kiosk
sudo wget -O /home/pi/pi-kiosk/kiosk/video.mp4 https://raw.githubusercontent.com/mediaelement/mediaelement-files/master/big_buck_bunny.mp4
sudo cp /home/pi/pi-kiosk/smb.conf /etc/samba/smb.conf
sudo /etc/init.d/samba restart
tee /home/pi/autostart.sh > /dev/null <<EOF
#!/usr/bin/env bash
PAGE="file:///home/pi/pi-kiosk/index.html"
firefox-esr -url \$PAGE
EOF
sudo chmod +x /home/pi/autostart.sh
tee /home/pi/.config/lxsession/LXDE-pi/autostart > /dev/null <<EOF
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
@xset s noblank
@xset s off
@xset -dpms
@point-rpi
@bash /home/pi/autostart.sh
EOF
sudo cp /home/pi/pi-kiosk/\{d320c473-63c2-47ab-87f8-693b1badb5e3\}.xpi /usr/share/mozilla/extensions/\{ec8030f7-c20a-464f-9b0e-13a3a9e97384\}/

