#!/bin/bash

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
max_tries=30
count=0

# Debug: Show network info
echo "Debug: Network Information"
ip addr show
echo "Debug: DNS Resolution"
nslookup db || echo "DNS lookup failed"
echo "Debug: Route Information"
ip route
echo "Debug: Testing connection to db:3306"
nc -zv db 3306 || echo "Port not accessible yet"

while [ $count -lt $max_tries ]; do
    echo "Debug: Attempt $((count + 1)) - trying to connect to MySQL..."
    if mysql -h"db" -u"root" -p"root" -e "SELECT 1" 2>&1; then
        echo "MySQL is ready!"
        break
    fi
    echo "Waiting for MySQL to be ready... ($((count + 1))/$max_tries)"
    
    # Debug: Check MySQL status every 5 attempts
    if [ $((count % 5)) -eq 0 ]; then
        echo "Debug: Network status for attempt $((count + 1))"
        echo "Debug: Testing connection to db:3306"
        nc -zv db 3306 || echo "Port not accessible"
        echo "Debug: Current routes:"
        ip route
        echo "Debug: DNS Resolution:"
        nslookup db || echo "DNS lookup failed"
    fi
    
    count=$((count + 1))
    sleep 3
done

if [ $count -eq $max_tries ]; then
    echo "Error: MySQL did not become ready in time"
    echo "Debug: Final diagnostics..."
    echo "Debug: Network interfaces:"
    ip addr show
    echo "Debug: Routes:"
    ip route
    echo "Debug: DNS Resolution:"
    nslookup db
    echo "Debug: Port check:"
    nc -zv db 3306
    echo "Debug: Final MySQL connection attempt with verbose output..."
    mysql -v -h"db" -u"root" -p"root" -e "SELECT 1"
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
