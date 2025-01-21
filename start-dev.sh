#!/bin/bash

echo "Starting development environment..."

# Wait for MySQL
echo "Waiting for MySQL to be ready..."

# Try to resolve MySQL IP
echo "Resolving MySQL IP..."
MYSQL_IP=$(getent hosts daw_db | awk '{ print $1 }')

if [ -z "$MYSQL_IP" ]; then
    echo "Could not resolve MySQL IP. Using container name..."
    MYSQL_HOST="daw_db"
else
    echo "MySQL IP resolved: $MYSQL_IP"
    MYSQL_HOST="$MYSQL_IP"
fi

until mysql -h"$MYSQL_HOST" -u"root" -p"root" -e "SELECT 1" > /dev/null 2>&1; do
    echo "MySQL is unavailable - sleeping"
    sleep 1
done

echo "MySQL is up and running!"

# Setup Laravel
cd /var/www/html
echo "DB_HOST=$MYSQL_HOST" >> .env.docker
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
