FROM php:7.3

MAINTAINER Istvan Drahos <drahos.istvan@gmail.com>

# Install linux dependencies
RUN apt-get update &&  apt-get install -qq curl apt-transport-https git build-essential \
    libssl-dev libzip-dev wget unzip bzip2 libbz2-dev zlib1g-dev libfontconfig \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev  libicu-dev libxml2-dev \
    libldap2-dev libmcrypt-dev jq gnupg  zip unzip openssh-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install and enable mcrypt
RUN pecl install mcrypt-1.0.2
RUN docker-php-ext-enable mcrypt

# Install additional php extensions
RUN docker-php-ext-install zip gd

# Install Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel Envoy
RUN composer global require "laravel/envoy=~1.0"

# Install Laravel Vapor CLI
RUN composer global require "laravel/vapor-cli"


# Install Node (with NPM), and Yarn (via package manager for Debian)
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update \
    && apt-get install -y \
    nodejs
RUN npm install -g yarn

