FROM debian:12
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y php-dev php-cli php-pear php-mbstring php-curl git build-essential libmosquitto-dev libmosquitto-dev php-sqlite3
WORKDIR /tmp
RUN git clone https://github.com/nismoryco/Mosquitto-PHP.git
WORKDIR /tmp/Mosquitto-PHP
RUN phpize
RUN ./configure
RUN make
RUN make install
RUN echo "extension=mosquitto.so" > /etc/php/8.2/cli/php.ini
ADD run /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint
CMD ["/usr/local/bin/entrypoint"]
