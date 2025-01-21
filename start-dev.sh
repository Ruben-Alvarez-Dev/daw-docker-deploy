#!/bin/bash

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
max_tries=30
count=0

while [ $count -lt $max_tries ]; do
    if mysqladmin ping -h"db" -u"root" -p"root" --silent; then
        echo "MySQL is ready!"
        break
    fi
    echo "Waiting for MySQL to be ready... ($((count + 1))/$max_tries)"
    count=$((count + 1))
    sleep 3
done

if [ $count -eq $max_tries ]; then
    echo "Error: MySQL did not become ready in time"
    exit 1
fi

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
