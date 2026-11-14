#!/bin/bash
DIR="/etc/X11/xorg.conf.d/"
TARGET="$DIR/10-monitor.conf"
modeline='Modeline "1280x1024_60.00"  108.88  1280 1360 1496 1712  1024 1025 1028 1060  -HSync +Vsync'
if [ "$EUID" -eq 0 ]; then
	echo "Running as root"
else
	echo "Insuffecient previliges. Run the script as sudo."
	exit 1
fi

if [ -d "$DIR" ]; then
	echo "$DIR exists."
else
	mkdir -v "$DIR"
	echo "$DIR created."
fi

if [ -f "$TARGET" ]; then
	echo "$TARGET exists."
	if [ -f "$TARGET.pak" ]; then
		echo "File Backup created in $DIR."
	else
		cp "$TARGET" "$TARGET.pak"
	fi
else
	touch "$TARGET"
	echo "$TARGET created."
fi

if grep -q "##1280x1024##" "$TARGET"; then
	echo "The 1280x1024 resolution was already added. aborting!"
	exit 1
else
	cat >> "$TARGET" <<EOF
##1280x1024##
Section "Monitor"
	Identifier "VGA-1"
	$modeline
EndSection
EOF
fi

echo -e "\e[42m\e[33m SESSION WILL RESET IN 10 SECONDS!\nPRESS Ctrl + C TO ABORT!\e[0m"
sleep 10
systemctl restart lightdm
