#!/bin/bash

echo "Starting development environment..."

# Wait for MySQL
echo "Waiting for MySQL to be ready..."
sleep 30

# Setup Laravel
cd /var/www/html
cp .env.docker .env
php artisan migrate --force

# Start Apache
apache2-foreground &

# Start Laravel
php artisan serve --host=0.0.0.0 --port=8000 &

# Start React
cd /var/www/frontend
npm run dev -- --host 0.0.0.0 --port 5173 &

# Keep container running
tail -f /var/www/html/storage/logs/laravel.log
