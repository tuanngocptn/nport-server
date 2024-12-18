#!/bin/bash

chmod 600 .github/scripts/id_rsa.pem

ssh -i .github/scripts/id_rsa.pem ubuntu@3.0.159.106 "rm -rf ~/files && mkdir -p ~/files"

scp -i .github/scripts/id_rsa.pem -r .github/files/* ubuntu@3.0.159.106:~/files/

ssh -i .github/scripts/id_rsa.pem ubuntu@3.0.159.106 <<'EOF'
sudo apt update -y
sudo apt install git -y
sudo apt install nginx -y
sudo apt install certbot -y

sudo rm -rf /opt/node
wget https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.xz
tar -xvf node-v8.9.4-linux-x64.tar.xz
sudo mv node-v8.9.4-linux-x64 /opt/node
rm -rf node-v8.9.4-linux-x64.tar.xz
echo 'PATH=/opt/node/bin:$PATH' >>~/.profile
source ~/.profile
npm install -g esm

rm -rf server
git clone https://github.com/tuanngocptn/nport.git server
cd server
npm install

cd ~/
sudo cp -R ~/files/etc/systemd/system/nport.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start nport
sudo systemctl restart nport

rm -rf ~/.secrets
mkdir -p ~/.secrets
sudo cp -R ~/files/home/ubuntu/.secrets/* ~/.secrets/

sudo apt install python3-pip -y
sudo apt install python3-certbot-dns-cloudflare -y
pip install certbot-dns-cloudflare
chmod 600 /home/ubuntu/.secrets/credentials.ini
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /home/ubuntu/.secrets/credentials.ini --server https://acme-v02.api.letsencrypt.org/directory --preferred-challenges dns -d '*.nport.link' --non-interactive --agree-tos -m tuanngocptn@gmail.com

sudo rm -rf /etc/nginx/sites-available/*
sudo rm -rf /etc/nginx/sites-enabled/*
sudo cp ~/files/etc/nginx/sites-available/nport.link.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/nport.link.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

EOF
