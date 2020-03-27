FROM php:7.2-fpm

WORKDIR /

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -qy apt-transport-https libmcrypt-dev zlib1g-dev sudo zlib1g-dev libidn11-dev curl libcurl4 \
    libpcre3-dev libcurl4-openssl-dev libevent-dev wget git ssh libicu-dev libxml2 libxml2-dev gnupg libtidy-dev libgmp-dev \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev libxslt1-dev libxslt1.1

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) mbstring opcache pdo pdo_mysql gettext iconv tidy gd bcmath iconv zip pcntl gmp intl xsl

RUN curl --silent --show-error https://getcomposer.org/installer | php --install-dir=/usr/local/bin --filename=composer
#RUN mv composer.phar /usr/local/bin/composer && composer self-update

RUN ln -s /app/artisan /usr/local/bin/artisan

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN sudo apt-get update -qq && apt-get install -v yarn
