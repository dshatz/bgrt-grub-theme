#! /usr/bin/env bash

THEME='bgrt-grub-theme'

# Pre-authorise sudo

# Detect existence of BGRT
if [[ ! -r /sys/firmware/acpi/bgrt/image ]]; then
	echo "Sorry, I can't read /sys/firmware/acpi/bgrt/image"
	echo "Exiting..."
	exit 1
fi

if [[ ! -r /sys/firmware/acpi/bgrt/xoffset ]]; then
	echo "Sorry, I can't read /sys/firmware/acpi/bgrt/xoffset"
	echo "Exiting..."
	exit 1
fi

if [[ ! -r /sys/firmware/acpi/bgrt/image ]]; then
	echo "Sorry, I can't read /sys/firmware/acpi/bgrt/yoffset"
	echo "Exiting..."
	exit 1
fi

# detect an instance of imagemagick to convert the BMP to GRUB-readable PNG
MAGICK='magick'

# Check if magick is installed
if ! command -v magick &> /dev/null
then
	if ! command -v convert &> /dev/null
	then
		echo "Could not find either magick or convert from ImageMagick. Please install it before running this script."
		exit 1
	else
		MAGICK='convert'
	fi
fi

echo 'Loading BGRT image'
"$MAGICK" /sys/firmware/acpi/bgrt/image PNG24:./theme/bgrt.png

cp ./theme.txt ./theme/theme.txt
echo '' >> ./theme/theme.txt
echo '+ image {' >> ./theme/theme.txt
echo "    left = $(</sys/firmware/acpi/bgrt/xoffset)" >> ./theme/theme.txt
echo "    top  = $(</sys/firmware/acpi/bgrt/yoffset)" >> ./theme/theme.txt
echo '    file = "bgrt.png"' >> ./theme/theme.txt
echo '}' >> ./theme/theme.txt

echo 'Copying theme to GRUB themes directory'
cp -r ./theme/* $1

echo 'Cleaning up temporary files...'
rm ./theme/theme.txt
rm ./theme/bgrt.png
