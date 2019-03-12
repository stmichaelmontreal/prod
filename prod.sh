#!/usr/bin/env bash

# install
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-16-04
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install git
sudo apt-get install nginx -y
sudo apt-get install -y nodejs
sudo npm install -g pm2

# web client
git clone https://github.com/stmichaelmontreal/web.git web
npm install --prefix web
sudo npm run --prefix web prod

# api
sudo useradd wwwapi
sudo git clone https://github.com/stmichaelmontreal/api.git /var/www/api
sudo npm install --prefix /var/www/api --production
sudo find /var/www/api/fdb/ -exec chown wwwapi: {} \;

# pm2
pm2 start /var/www/api/server.js
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u wwwapi --hp /home/wwwapi

# nginx
sudo cp nginx-default /etc/nginx/sites-enabled/default
sudo systemctl enable nginx
