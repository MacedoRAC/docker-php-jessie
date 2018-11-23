FROM php:7.1-jessie

ENV PROJECT_PATH=.

RUN apt-get update

RUN apt-get install -y software-properties-common \
    && add-apt-repository ppa:glasen/freetype2

RUN apt-get install -y \
        $PHPIZE_DEPS \
        imagemagick \
        libmagickwand-dev \
        libmagickcore-dev \
        libmcrypt-dev \
        libtool \
        libxml2-dev \
        freetype2-demos \
        libpng-dev \
        libjpeg-turbo-progs \
        curl \
        libcurl4-gnutls-dev \
        git \
        libmcrypt-dev \
        autoconf \
        g++ \
        libtool \
        libicu-dev \
        make


RUN pecl install imagick

RUN docker-php-ext-enable imagick
RUN docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ 
RUN NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} gd 
RUN docker-php-ext-install \
        curl \
        iconv \
        mbstring \
        mcrypt \
        pdo \
        pdo_mysql \
        pcntl \
        tokenizer \
        xml \
        zip \
        soap \
        intl \
        bcmath

RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer


WORKDIR /var/www/


ENTRYPOINT ["./entrypoint.sh"]