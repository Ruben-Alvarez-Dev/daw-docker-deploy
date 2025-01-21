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
    default-mysql-client

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure Apache
WORKDIR /var/www/html
RUN a2enmod rewrite
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Copy application code
COPY daw_backend/ /var/www/html/
COPY daw_frontend/ /var/www/frontend/

# Install dependencies
RUN composer install --no-interaction
WORKDIR /var/www/frontend
RUN npm install

# Set permissions
WORKDIR /var/www/html
RUN chown -R www-data:www-data storage
RUN chmod -R 775 storage

# Setup startup script
COPY start-dev.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-dev.sh

EXPOSE 80 5173 8000

CMD ["/usr/local/bin/start-dev.sh"]
