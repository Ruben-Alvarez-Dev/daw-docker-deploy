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
    default-mysql-client \
    inetutils-ping \
    dnsutils \
    net-tools

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

# Clone repositories and setup application
RUN git clone https://github.com/Ruben-Alvarez-Dev/daw_backend.git /var/www/html/ && \
    git clone https://github.com/Ruben-Alvarez-Dev/daw_frontend.git /var/www/frontend/

# Install backend dependencies
WORKDIR /var/www/html
RUN composer install --no-interaction && \
    cp .env.example .env.docker && \
    chown -R www-data:www-data storage && \
    chmod -R 775 storage

# Install frontend dependencies
WORKDIR /var/www/frontend
RUN npm install

# Setup startup script
COPY start-dev.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-dev.sh

EXPOSE 80 5173 8000

CMD ["/usr/local/bin/start-dev.sh"]
