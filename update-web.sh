#!/usr/bin/env bash

cd web
git pull origin master
npm install
sudo npm run prod
