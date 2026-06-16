#!/bin/sh
set -e

cd /var/www/html

echo "→ Ensuring storage directories exist..."
mkdir -p storage/framework/sessions storage/framework/views storage/framework/cache storage/framework/testing storage/logs bootstrap/cache database
touch database/database.sqlite
chown -R www-data:www-data storage bootstrap/cache database
chmod -R 775 database

echo "→ Caching config..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "→ Running migrations..."
php artisan migrate --force

echo "→ Testing nginx config..."
nginx -t

echo "→ Starting services..."
exec /usr/bin/supervisord -c /etc/supervisord.conf