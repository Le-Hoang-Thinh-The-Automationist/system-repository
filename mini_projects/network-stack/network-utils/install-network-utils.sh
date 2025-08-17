#!/bin/bash

# Detect OS package manager
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
else
    echo "Unsupported package manager. Exiting."
    exit 1
fi

# Update package lists
echo "Updating package lists..."
sudo $PKG_MANAGER update -y

# Install basic network utilities
echo "Installing basic network utilities..."
sudo $PKG_MANAGER install -y net-tools traceroute iputils-ping curl wget nmap tcpdump telnet

# Install DNS utilities
echo "Installing DNS utilities..."
sudo $PKG_MANAGER install -y bind-utils dnsutils

# Install network troubleshooting & debugging tools
echo "Installing network troubleshooting & debugging tools..."
sudo $PKG_MANAGER install -y tcpdump nmap netcat iperf3

# Install DHCP management tools
echo "Installing DHCP management tools..."
sudo $PKG_MANAGER install -y isc-dhcp-server dhclient dnsmasq

# Installation complete
echo "Installation completed successfully!"
