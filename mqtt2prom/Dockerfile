FROM debian:12 as prepare
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
FROM prepare as make_git_id
WORKDIR /tmp/repo
ADD .git /tmp/repo/.git
RUN git rev-parse HEAD > /tmp/git_id
FROM prepare as runner
ENV GIT_ID=unknown
COPY --from=make_git_id /tmp/git_id /var/lib/git_id

CMD ["/usr/local/bin/entrypoint"]
