#!/usr/bin/env bash
sudo apt-get -y update
sudo apt-get -y install firefox-esr samba xscreensaver unclutter omxplayer
sudo adduser --system shareuser
sudo mkdir -m 1777 /home/pi/pi-kiosk/kiosk
sudo chown shareuser /home/pi/pi-kiosk/kiosk
sudo chmod 777 -R /home/pi/pi-kiosk/kiosk
sudo wget -O /home/pi/pi-kiosk/kiosk/video.mp4 https://raw.githubusercontent.com/mediaelement/mediaelement-files/master/big_buck_bunny.mp4
sudo tee /etc/samba/smb.conf > /dev/null <<EOF
[global]
   workgroup = WORKGROUP
   dns proxy = no
   log file = /var/log/samba/log.%m
   max log size = 1000
   syslog = 0
   panic action = /usr/share/samba/panic-action %d
   server role = standalone server
   passdb backend = tdbsam
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   map to guest = bad user
   usershare allow guests = yes
[homes]
   comment = Home Directories
   browseable = no
   read only = yes
   create mask = 0700
   directory mask = 0700
   valid users = %S
[printers]
   comment = All Printers
   browseable = no
   path = /var/spool/samba
   printable = yes
   guest ok = no
   read only = yes
   create mask = 0700
[print$]
   comment = Printer Drivers
   path = /var/lib/samba/printers
   browseable = yes
   read only = yes
   guest ok = no
[kiosk]
   path = /home/pi/pi-kiosk/kiosk
   browseable = yes
   writeable = yes   
   read only = no
   guest ok = yes
   create mask = 777
   directory mask = 777
   force user = shareuser
EOF
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
sudo wget -O "/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{d320c473-63c2-47ab-87f8-693b1badb5e3}.xpi" "https://addons.mozilla.org/firefox/downloads/file/860622/autofullscreen-1.0.0.1-an+fx.xpi"