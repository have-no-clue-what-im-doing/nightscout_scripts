#!/bin/bash

set -e
CONFIG_POLICY="confnew"
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt -o Dpkg::Options::="--force-${CONFIG_POLICY}" -y upgrade
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt -o Dpkg::Options::="--force-${CONFIG_POLICY}" install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
sudo usermod -aG docker "$USER"
