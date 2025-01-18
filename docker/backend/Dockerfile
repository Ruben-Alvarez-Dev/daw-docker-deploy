FROM php:8.2-apache

# Instalar extensiones PHP necesarias
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_mysql zip

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar Apache
RUN a2enmod rewrite
COPY apache.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

# Copiar archivos de composer
COPY backend/composer.json backend/composer.lock ./

# Instalar dependencias
RUN composer install --no-scripts --no-autoloader

# Copiar el resto del código
COPY backend/ .

# Generar autoloader optimizado
RUN composer dump-autoload --optimize

# Configurar permisos
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache \
    && chmod -R 775 public

EXPOSE 80

CMD ["apache2-foreground"]
