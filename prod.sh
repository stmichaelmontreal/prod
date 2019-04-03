#!/usr/bin/env bash

# install
# https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-16-04
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y unzip
sudo apt-get install -y nginx
sudo apt-get install -y mysql-server

sudo mysql_secure_installation
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'PutHerePassword'"
sudo mysql -e "FLUSH PRIVILEGES"

sudo npm install -g pm2

# api
sudo useradd -m -d /home/wwwapi wwwapi
sudo passwd wwwapi
sudo git clone https://github.com/stmichaelmontreal/api.git /var/www/api
sudo npm install --prefix /var/www/api --production
sudo find /var/www/api/ -exec chown wwwapi: {} \;
sudo chmod -R u=rwx,g=rx,o=rx /var/www/api/

# pm2
cd /var/www/api/
sudo su -c "pm2 start server.js" -s /bin/sh wwwapi
# pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u wwwapi --hp /home/wwwapi
sudo su -c "pm2 save" -s /bin/sh wwwapi

# nginx
sudo systemctl stop nginx
sudo cp nginx-default /etc/nginx/sites-enabled/default

# web client
git clone https://github.com/stmichaelmontreal/deploy.git
cd deploy
bash git-to-web.sh
