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
#