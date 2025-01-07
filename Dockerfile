FROM php:8.2-fpm

WORKDIR /var/www

# System updates and cleanup should be grouped together
RUN apt-get update && apt-get install -y \
    zip unzip git curl netcat-openbsd \
    libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libicu-dev libpq-dev libxslt1-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo_mysql zip intl exif xsl bcmath \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP extensions
RUN docker-php-ext-configure intl \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql zip intl gd

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Setup wait script
COPY docker/wait-for-app.sh /usr/local/bin/wait-for-app.sh
RUN chmod +x /usr/local/bin/wait-for-app.sh

# Copy application files
COPY . /var/www

# Set permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/vendor

# Switch to www-data user (all system-level commands should be above this line)
USER www-data

CMD ["/usr/local/bin/wait-for-app.sh"]