#!/bin/bash

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
while ! mysqladmin ping -h"db" -u"root" -p"root" --silent; do
    sleep 1
done
echo "MySQL is ready!"

# Copy environment file
cd /var/www/html
cp .env.docker .env

# Run database migrations
echo "Running database migrations..."
php artisan migrate --force

# Start Apache in background
apache2-foreground &

# Start Laravel development server
php artisan serve --host=0.0.0.0 --port=8000 &

# Start React development server
cd /var/www/frontend
export VITE_API_URL=http://localhost:8000
# Use --host 0.0.0.0 to make it accessible from outside the container
NODE_ENV=development npm run dev -- --host 0.0.0.0 --port 5173 --strictPort &

# Keep container running and show logs
tail -f /var/www/html/storage/logs/laravel.log
