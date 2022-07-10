# NGINX
FROM nginx:1.21.3-alpine as prod

COPY . /usr/share/nginx/html/test
COPY /nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
