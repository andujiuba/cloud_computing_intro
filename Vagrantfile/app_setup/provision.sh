!#/bin/bash

# Let's automate the installation of nginx
# Creating provision.sh to run the script

sudo apt-get update -y

sudo apt-get upgrade -y

sudo apt-get install nginx -y

# Automating dependencies installation

sudo apt-get install npm -y

sudo apt-get install python-software-properties -y

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

sudo apt-get install nodejs -y

# Change directories

cd /home/ubuntu/app
sudo npm install pm2 -g -y

npm install

# Change default nginx config file with new default in app_setup/rev_proxy folder

sudo rm /etc/nginx/sites-available/default

sudo ln -s /home/ubuntu/rev_proxy/default.txt /etc/nginx/sites-available/default

sudo systemctl restart nginx





