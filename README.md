# Tiyan-Media-Server
 Tiyan Media Server
 
 Media server - wowza & nimble killer :)

Run the following commands on a freshly installed Ubuntu 18 Server

```
sudo -s
```
```
apt-get install curl -y
```
```
curl -sL https://raw.githubusercontent.com/upggr/IELKO-MEDIA-SERVER/master/install.sh | sudo bash -
```

++++ receiving streams ++++
Stream to rtmp://ipofyourserver/hls/stream1   (or any other streamname other than stream1)


++++ retrieving streams ++++
your hls address is : http://ipofyourserver:8080/hls/stream1.m3u8
you can test your stream from http://ipofyourserver/player/play.php?play=http://ipofyourserver:8080/hls/stream1.m3u8
or you can just visit http://ipofyourserver for sample links to streams : stream1,stream2,stream3,stream4

++++ restream from your server another stream ++++
restream a youtube video to http://ipofyourserver:8080/hls/stream1.m3u8 :
ffmpeg -re -i `youtube-dl  --get-url https://www.youtube.com/watch?v=qRY56sJJ2to `  -c:v copy -ar 44100 -ab 128k -ac 2 -strict -2 -f flv rtmp://ipofyourserver/hls/stream1
for non youtube streams ommmit the livestreamer command and put an rtmp, for m3u8 use livestreamer.

++++ usefull commands ++++

Test the configuration file
/usr/local/nginx/sbin/nginx -t

Start nginx in the background
/usr/local/nginx/sbin/nginx

Start nginx in the foreground
/usr/local/nginx/sbin/nginx -g 'daemon off;'

Reload the config on the go
/usr/local/nginx/sbin/nginx -t && nginx -s reload

Kill nginx
/usr/local/nginx/sbin/nginx -s stop

Location of html
/usr/local/nginx/html

Update player
cd /usr/local/nginx/html/player
git pull

edit nginx.conf
nano /usr/local/nginx/conf/nginx.conf

Update www directory with new default values and player
curl -sL https://raw.githubusercontent.com/upggr/IELKO-MEDIA-SERVER/master/update_html.sh | sudo bash -

Update www directory with new default values and player using a custom domain (you will be asked for the domain in the script)!
curl -sL https://raw.githubusercontent.com/upggr/IELKO-MEDIA-SERVER/master/update_html_custom_domain.sh | sudo bash -


++++ use domain name ++++
just nano /usr/local/nginx/conf/nginx.conf
Replace line : "#server_name yourdomain.com www.yourdomain.com xxx.xxx.xxx.xxx" with your domain name or ip etc (and remove the #) :)
