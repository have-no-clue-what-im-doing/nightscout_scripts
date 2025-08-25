#!/bin/bash

sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -y \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confnew" upgrade
sudo curl -fsSl https://get.docker.com | bash
wget https://raw.githubusercontent.com/have-no-clue-what-im-doing/nightscout_scripts/refs/heads/main/docker-compose.yaml
