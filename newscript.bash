#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
sudo apt update && sudo apt upgrade -y
sudo curl -fsSl https://get.docker.com | bash
