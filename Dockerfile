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
    nodejs \
    npm \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Configure Apache
RUN a2enmod rewrite
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Copy application files
COPY daw_backend/ /var/www/html/
COPY daw_frontend/ /var/www/frontend/

# Install Laravel dependencies
RUN composer install --no-interaction

# Install React dependencies
WORKDIR /var/www/frontend
RUN npm install

# Set correct permissions
WORKDIR /var/www/html
RUN chown -R www-data:www-data storage
RUN chmod -R 775 storage

# Copy start script
COPY start-dev.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-dev.sh

# Add hosts entry for db
RUN echo "127.0.0.1 db" >> /etc/hosts

EXPOSE 80 5173

CMD ["/usr/local/bin/start-dev.sh"]
