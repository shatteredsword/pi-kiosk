#!/usr/bin/env bash
apt-get -y update
apt-get -y install samba omxplayer
adduser --system shareuser
mkdir -m 1777 /home/pi/pi-kiosk/kiosk
chown shareuser /home/pi/pi-kiosk/kiosk
wget -O /home/pi/pi-kiosk/kiosk/video.mp4 https://raw.githubusercontent.com/mediaelement/mediaelement-files/master/big_buck_bunny.mp4
chmod 777 -R /home/pi/pi-kiosk/kiosk
tee /etc/samba/smb.conf > /dev/null <<EOF
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
/etc/init.d/samba restart
cd /home/pi/pi-kiosk
git clone https://github.com/adafruit/pi_video_looper.git
cd /home/pi/pi-kiosk/pi_video_looper
./install.sh
sed -i 's/^file_reader = usb_drive/file_reader = directory/g' /root/video_looper.ini
sed -i 's-^path = /home/pi-path = /home/pi/pi-kiosk/kiosk-g' /root/video_looper.ini