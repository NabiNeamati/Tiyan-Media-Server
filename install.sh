#!/bin/bash
#sudo add-apt-repository ppa:mc3man/trusty-media -y
sudo apt-get update -y
sudo apt-get install livestreamer build-essential libpcre3 libpcre3-dev libssl-dev  libpcre3 git  software-properties-common php-fpm php-mysql libsybdb5 php-gettext libgd-dev libgeoip-dev libxslt-dev zlibc zlib1g zlib1g-dev -y
sudo apt-get install ffmpeg  -y
sudo apt-get install stunnel4 -y

mkdir ~/working
mkdir ~/working/Tiyan
mkdir ~/working/nginx-rtmp-module
mkdir ~/working/ngx_devel_kit
mkdir ~/working/set-misc-nginx-module
mkdir ~/working/nginx
mkdir ~/working/nginx-hmac-secure-link
git clone https://github.com/NabiNeamati/Tiyan-Media-Server.git ~/working/Tiyan
git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module.git ~/working/nginx-rtmp-module
git clone https://github.com/openresty/set-misc-nginx-module.git ~/working/set-misc-nginx-module
git clone https://github.com/simpl/ngx_devel_kit.git ~/working/ngx_devel_kit
git clone https://github.com/nginx-modules/nginx-hmac-secure-link.git ~/working/nginx-hmac-secure-link
wget http://nginx.org/download/nginx-1.16.1.tar.gz -P ~/working
tar -xf ~/working/nginx-1.16.1.tar.gz -C ~/working/nginx --strip-components=1
rm ~/working/nginx-1.16.1.tar.gz
cd ~/working/nginx
#./configure --with-http_ssl_module --add-module=../nginx-rtmp-module --add-module=../ngx_devel_kit --add-module=../set-misc-nginx-module --add-module=../nginx-hmac-secure-link
./configure --with-http_ssl_module --add-module=../nginx-rtmp-module --add-module=../ngx_devel_kit --add-module=../set-misc-nginx-module --with-debug  --with-cc-opt="-Wimplicit-fallthrough=0"
make -j 2
sudo make install
cp ~/working/Tiyan/conf/nginx.conf /usr/local/nginx/conf/nginx.conf
cp ~/working/Tiyan/conf/nginx.service /etc/init.d/nginx
sudo chmod +x /etc/init.d/nginx
sudo /usr/sbin/update-rc.d -f nginx defaults
ufw allow 8080
ufw allow 80
ufw allow 1935
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp --dport 1935 -j ACCEPT
iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
#rm /usr/local/nginx/html/*
cp ~/working/Tiyan/www/crossdomain.xml /usr/local/nginx/html/crossdomain.xml
#cp ~/working/Tiyan/www/index.php /usr/local/nginx/html/index.php
#cp ~/working/Tiyan/www/ielko-media-server.css /usr/local/nginx/html/ielko-media-server.css
#cp ~/working/Tiyan/www/stream.xml /usr/local/nginx/html/stream.xml
#cp ~/working/Tiyan/www/testing.png /usr/local/nginx/html/testing.png
#cp ~/working/Tiyan/www/favicon.ico /usr/local/nginx/html/favicon.ico
#git clone https://github.com/upggr/ielko-video-player /usr/local/nginx/html/player
#ip=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//' )
#sed -i -- 's/replaceip/'"$ip"'/g' /usr/local/nginx/html/stream.xml
#sed -i -- 's/replaceip/'"$ip"'/g' /usr/local/nginx/html/index.php

#enable Stunel for Support RTMPS 
# source: https://sites.google.com/view/facebook-rtmp-to-rtmps/home
rm -rf /etc/default/stunnel4
cp ~/working/Tiyan/stunnel/stunnel4 /etc/default/
cp ~/working/Tiyan/stunnel/stunnel.conf /etc/stunnel/
sudo systemctl enable stunnel4.service
sudo systemctl restart stunnel4.service


#
ln -s /usr/local/nginx/sbin/nginx nginx
sudo service nginx start
sudo rm -rf ~/working
sudo chmod -R ugo+rwx /usr/local/nginx
history -c
shutdown -r now