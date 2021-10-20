FROM php:5.4-apache

RUN DEBIAN_FRONTEND="noninteractive" 
RUN apt-get update && apt install -y tzdata

# Set working directory
WORKDIR /var/www
# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    wget \
    libaio1 \
    git \
    curl

# Paqueetes php
RUN apt-get install -y php5-common php5-ldap php5-dev pkg-php-tools php-pear php5-cli

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
#RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-install mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

RUN wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip -P /tmp
RUN unzip /tmp/instantclient-basic-linux.x64-21.1.0.0.0.zip -d /opt/oracle/ && rm -rf /tmp/instantclient-basic-linux.x64-21.1.0.0.0.zip

RUN wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sdk-linux.x64-21.1.0.0.0.zip -P /tmp
RUN unzip /tmp/instantclient-sdk-linux.x64-21.1.0.0.0.zip -d /opt/oracle/ && rm -rf /tmp/nstantclient-sdk-linux.x64-21.1.0.0.0.zip

#RUN sh -c "echo /opt/oracle/instantclient_21_1 > /etc/ld.so.conf.d/oracle-instantclient.conf" && ldconfig
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_21_1:$LD_LIBRARY_PATH
ENV ORACLE_HOME=/opt/oracle/instantclient_21_1
RUN ls -lrt /opt/oracle/
#RUN pecl install oci8-2.0.12
RUN echo 'instantclient,/opt/oracle/instantclient_21_1/' | pecl install oci8-2.0.12
RUN echo 'extension=oci8.so' > /usr/local/etc/php/conf.d/oci8.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

ENV DISPLAY=:99
