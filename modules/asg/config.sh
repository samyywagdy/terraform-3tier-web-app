#!/bin/bash
sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
echo "Welcome from Samy" >/var/www/html/index.nginx-debian.html