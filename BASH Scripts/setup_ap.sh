#!/bin/bash

# Prompt for SSID and password
read -p "Enter SSID for the access point: " ssid
read -sp "Enter password for the access point: " password
echo

# Update and upgrade
echo "Updating and upgrading..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "Installing required packages..."
sudo apt install -y hostapd dnsmasq iptables

# Stop wpa supplicant
# systemctl stop wpa_supplicant

#Following 2 commands @ 1:31 of yt video to be put into dnsmasq.conf
####################################################################
echo "Configuring dnsmasq.conf"
cat <<EOF | sudo tee /etc/dnsmasq.conf
# Set Wireless Interface
interface=wlan0

# Set IP Range for Clients
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
EOF

# Set wlan country code
cat <<EOF | sudo tee /boot/firmware/cmdline.txt
 cfg80211.ieee80211_regdom=GB
EOF

# hostapd.conf
####################################################################
echo "Configuring hostapd"
cat <<EOF | sudo tee /etc/hostapd/hostapd.conf

# Set Wireless Interface
interface=wlan0

# Set Network Name
ssid=$ssid

# Set Channel
channel=1

# Set Deiver
driver=nl80211

# Set country code for AP
country_code=GB
EOF

# BASH COMMAND
###################################################################
# unmask hostapd
sudo systemctl unmask hostapd

# Make hostapd initalise with the newly created hostapd.conf file
# edit /etc/default/hostapd
echo "making hostapd run with hostapd.conf on startup"
cat <<EOF | sudo tee /etc/default/hostapd
DAEMON_OPTS="/etc/hostapd/hostapd.conf"
EOF

# restart hostapd
sudo systemctl restart hostapd

