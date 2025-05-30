#!/bin/bash
set -euo pipefail

echo "Cleaning broken apt lists and command-not-found database..."
sudo rm -rf /var/lib/apt/lists/*
sudo mkdir -p /var/lib/command-not-found
sudo touch /var/lib/command-not-found/db
sudo apt-get clean
####veera

echo "Updating apt cache..."
sudo apt-get update -y

echo "Installing Node.js 18.x, npm, and PM2..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs build-essential

echo "Installing PM2 globally..."
sudo npm install -g pm2


echo "Copying application files..."
sudo mkdir -p /opt/node-app
sudo cp -r /tmp/node-app/. /opt/node-app/

echo "Installing app dependencies..."
cd /opt/node-app
sudo npm install --production
sudo pm2 start index.js 
pm2 startup
sudo systemctl enable pm2-root
sudo pm2 save
####veera

# echo "Starting app with PM2 and enabling startup..."
# sudo pm2 start ecosystem.config.js
# sudo pm2 startup systemd -u ubuntu --hp /home/ubuntu
# sudo pm2 save
