<!-- deploy -->

cd /home/galactic-war && git pull
rm -rf /var/www/galacticwar.io && mkdir /var/www/galacticwar.io && cp -r /home/galactic-war/\* /var/www/galacticwar.io

<!-- end -->

<!-- server config -->
<!-- /etc/nginx/sites-enabled/galacticwar.io  -->

server {
listen 80;
server_name galacticwar.io;
root /var/www/html;
return 301 https://$host$request_uri;
index index.html;
location /{
root /var/www/galacticwar.io;
}
location /airdrop{
proxy_pass http://galacticwar.io:8000;
}
location /api {
proxy_pass http://galacticwar.io:7000;
}

access_log /var/log/nginx/galacticwar.io.access.log;
error_log /var/log/nginx/galacticwar.io.error.log;
}

server {

listen 443;
server_name galacticwar.io;
ssl on;
#ssl_certificate /root/global/cert_chain.crt;
#ssl_certificate_key /root/global/server.key;
ssl_certificate /etc/ssl/galacticwar.io/cert_chain.crt;
ssl_certificate_key /etc/ssl/galacticwar.io/server.key;
root /var/www/html;
location /{
root /var/www/galacticwar.io;
}
location /airdrop{
proxy_pass http://galacticwar.io:8000;
}  
location /api {
proxy_pass http://galacticwar.io:7000;
}
access_log /var/log/nginx/galacticwar.io.access.log;
error_log /var/log/nginx/galacticwar.io.error.log;

    index index.html;

}

<!-- end -->

<!-- /home/Dockerfile -->

FROM node:14.16.0 as build

WORKDIR /app

COPY ./glwairdrop/package.json package.json

RUN ["/bin/bash", "-c", "npm install"]

COPY ./glwairdrop .

RUN ["/bin/bash", "-c", "npm run build"]

# NGINX

FROM nginx:1.21.3-alpine as prod

COPY ./galactic-war /usr/share/nginx/html

COPY --from=build /app/build /usr/share/nginx/airdrop
COPY --from=build /app/build /usr/share/nginx/airdrop/airdrop

COPY /nginx.conf /etc/nginx/conf.d/default.conf

COPY /cert_chain.crt /etc/nginx/conf.d/cert_chain.crt

COPY /server.key /etc/nginx/conf.d/server.key

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

<!-- /home/docker-compose.yml -->

version: '3.5'

services:
app:
build: .
ports: - 8000:80

backend:
build: ./glw-api-be
ports: - 7000:3000
