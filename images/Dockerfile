FROM ubuntu:bionic

ARG UID=1000
ARG GID=1000

ENV PHP_XDEBUG_REMOTE_HOST="" PHP_XDEBUG_IDEKEY="" PHP_XDEBUG_REMOTE_ENABLE="" PHP_XDEBUG_REMOTE_AUTOSTART="" PHP_XDEBUG_REMOTE_PORT="" TZ="Indian/Maldives"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    gperf \
    software-properties-common \
    apt-utils \
    language-pack-en-base

RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    vim \
    curl \
    zip \
    unzip \
    git \
    sqlite3 \
    imagemagick \
    mysql-client \
    apache2 \
    libapache2-mod-php7.3 \
    nano \
    pkg-config \
    composer \
    libmcrypt-dev \
    php7.3 \
    php7.3-cli \
    php7.3-gd \
    php7.3-bcmath \
    php7.3-imap \
    php7.3-xml \
    php7.3-soap \
    php7.3-curl \
    php7.3-gd \
    php7.3-json \
    php7.3-xml \
    php7.3-mbstring \
    php7.3-pdo \
    php7.3-mysql \
    php7.3-sqlite3 \
    php7.3-zip \
    php7.3-xmlrpc \
    php7.3-tidy \
    php7.3-dev \
    php7.3-common \
    php-imagick \
    php-memcached \
    php-redis \
    php-xdebug \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get remove -y --purge software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN a2enmod php7.3 rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.3/apache2/php.ini \
    && sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.3/apache2/php.ini \
    && sed -i "s/;extension=openssl/extension=openssl/" /etc/php/7.3/apache2/php.ini \
    && echo "extension=json" >> /etc/php/7.3/apache2/php.ini \
    && echo "extension=tokenizer" >> /etc/php/7.3/apache2/php.ini \
    && echo "extension=pdo" >> /etc/php/7.3/apache2/php.ini

COPY /images/execute.sh /var/exec/execute.sh
ADD /images/etc/php/7.3/apache2/php.ini /etc/php/7.3/apache2
ADD /images/etc/php/7.3/apache2/conf.d/ /etc/php/7.3/apache2/conf.d/

RUN if grep -q "^appuser" /etc/group; then echo "Group already exists."; else groupadd -g $GID appuser; fi
RUN useradd -m -r -u $UID -g appuser appuser
RUN chown -R appuser:appuser /var/www/

# NVM

RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV SHIPPABLE_NODE_VERSION=v8.11.1

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

RUN chmod 755 $NVM_DIR/nvm.sh

RUN . $NVM_DIR/nvm.sh \
    && nvm install $SHIPPABLE_NODE_VERSION \
    && nvm install v6.12.3 && nvm install v7.7.3 \
    && nvm alias default $SHIPPABLE_NODE_VERSION \
    && nvm use default && npm install grunt-cli gulp-cli babel-cli yarn webpack webpack-cli -g \
    && nvm use v6.12.3 && npm install grunt-cli gulp-cli babel-cli yarn webpack webpack-cli -g \
    && nvm use v7.7.3  && npm install grunt-cli gulp-cli babel-cli yarn webpack webpack-cli -g \
    && nvm use default

RUN touch $HOME/.bash_profile \
    && echo "source ~/.bashrc" >> $HOME/.bash_profile \
    && echo "cd /var/www" >> $HOME/.bash_profile \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

USER appuser
ENV METHOD script
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN . $NVM_DIR/nvm.sh

USER root

EXPOSE 22
RUN git config --global url."https://".insteadOf git://

RUN mkdir -p /usr/local/git-dummy
RUN git init /usr/local/git-dummy
ENV GIT_DIR /usr/local/git-dummy

# NVM

CMD ["/bin/bash","/var/exec/execute.sh"]