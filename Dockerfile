FROM php:8.2-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    zip unzip git curl netcat-openbsd \
    libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libicu-dev libpq-dev libxslt1-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo_mysql zip intl exif xsl bcmath

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest


COPY docker/wait-for-app.sh /usr/local/bin/wait-for-app.sh
RUN chmod +x /usr/local/bin/wait-for-app.sh

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . /var/www

RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/vendor

USER www-data

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure intl 
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg
RUN docker-php-ext-install pdo_mysql zip intl gd

CMD ["/usr/local/bin/wait-for-app.sh"]