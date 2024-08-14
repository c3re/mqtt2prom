FROM debian:12
RUN apt-get update && apt-get install -y nginx-light
ADD prom.conf /etc/nginx/sites-available
RUN rm /etc/nginx/sites-enabled/*
RUN ln -s /etc/nginx/sites-available/prom.conf /etc/nginx/sites-enabled/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
