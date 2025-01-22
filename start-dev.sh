#!/bin/bash

echo "Starting development environment..."

# Wait for MySQL
echo "Waiting for MySQL to be ready..."
sleep 30

# Setup Laravel
cd /var/www/html

# Ensure .env file exists
if [ ! -f ".env" ]; then
    if [ -f ".env.docker" ]; then
        cp .env.docker .env
    elif [ -f ".env.example" ]; then
        cp .env.example .env
    fi
fi

# Generate key if not exists
php artisan key:generate --no-interaction --force
php artisan migrate --force

# Ensure storage directory is set up
mkdir -p storage/logs
touch storage/logs/laravel.log
chown -R www-data:www-data storage
chmod -R 775 storage

# Start Apache
apache2-foreground &

# Start Laravel
php artisan serve --host=0.0.0.0 --port=8000 &

# Start React
cd /var/www/frontend
npm run dev -- --host 0.0.0.0 --port 5173 &

# Keep container running and show logs
tail -f /var/www/html/storage/logs/laravel.log
