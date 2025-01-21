# Development environment for DAW application
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    iputils-ping \
    netcat-traditional \
    dnsutils \
    default-mysql-client \
    tcpdump \
    telnet \
    wget

# Install Node.js and npm using n
RUN curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n -o n \
    && bash n lts \
    && rm n \
    && npm install -g npm@latest

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy Apache configuration
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Copy application code
COPY daw_backend/ /var/www/html/
COPY daw_frontend/ /var/www/frontend/

# Install PHP dependencies
RUN composer install --no-interaction

# Install frontend dependencies
WORKDIR /var/www/frontend
RUN npm install

# Set permissions
WORKDIR /var/www/html
RUN chown -R www-data:www-data storage
RUN chmod -R 775 storage

# Copy and set startup script
COPY start-dev.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-dev.sh

EXPOSE 80 5173

CMD ["/usr/local/bin/start-dev.sh"]
