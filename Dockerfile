FROM php:7.4-fpm

WORKDIR /

ENV DEBIAN_FRONTEND noninteractive
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12.16.1

RUN apt-get update -qq --fix-missing
RUN apt-get install --no-install-recommends -qy libmcrypt-dev zlib1g-dev sudo zlib1g-dev libidn11-dev curl libcurl4 libpcre3-dev libcurl4-openssl-dev libevent-dev wget git ssh libicu-dev libxml2 libxml2-dev libzip-dev
RUN apt-get install --no-install-recommends -qy gnupg libtidy-dev libgmp-dev

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -qy apt-transport-https libmcrypt-dev zlib1g-dev sudo zlib1g-dev libidn11-dev curl libcurl4 \
    libpcre3-dev libcurl4-openssl-dev libevent-dev wget git ssh libicu-dev libxml2 libxml2-dev gnupg libtidy-dev libgmp-dev \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev libxslt1-dev libxslt1.1

RUN docker-php-ext-configure gd
RUN docker-php-ext-install -j$(nproc) opcache pdo pdo_mysql gettext iconv tidy gd bcmath iconv zip pcntl gmp intl xsl

RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN ln -s /app/artisan /usr/local/bin/artisan

RUN mkdir $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
RUN . $NVM_DIR/nvm.sh \
        && nvm install $NODE_VERSION \
        && nvm alias default $NODE_VERSION \
        && nvm use default \
        && npm i npm@latest -g \
        && npm install -g yarn
