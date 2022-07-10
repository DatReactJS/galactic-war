# NGINX
FROM nginx:1.21.3-alpine as prod

COPY . /usr/share/nginx/html
COPY /nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8000
