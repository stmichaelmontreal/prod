#!/usr/bin/env bash

git pull origin master

cd /var/www/api
git pull origin master
npm install --production
cd fdb
sudo bash folders.sh
pm2 restart 0
