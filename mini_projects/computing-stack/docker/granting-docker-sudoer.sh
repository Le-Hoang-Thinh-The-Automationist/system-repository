#!/bin/bash

echo "Checking if 'docker' group exists..."

if ! getent group docker > /dev/null; then
    echo "'docker' group does not exist. Creating..."
    sudo groupadd docker
else
    echo "'docker' group already exists."
fi

echo "Adding user $(whoami) to the 'docker' group..."
sudo usermod -aG docker $USER

# Apply changes without reboot
newgrp docker

# Restart Docker service
sudo systemctl restart docker

echo "User $(whoami) has been granted permission to run Docker without sudo."
echo "Please log out and log back in for changes to take effect."
