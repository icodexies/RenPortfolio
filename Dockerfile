# ─── Stage 1: Build frontend ───────────────────────────────────────────────
FROM node:20-alpine AS frontend

WORKDIR /app

# Need composer + php to install ziggy vendor files
RUN apk add --no-cache php84 php84-phar php84-mbstring php84-openssl php84-tokenizer \
    && ln -sf /usr/bin/php84 /usr/bin/phps

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install PHP deps first (ziggy lives in vendor/)
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --ignore-platform-reqs

# Install JS deps
COPY package*.json ./
RUN npm ci --prefer-offline

# Copy source and build
COPY . .

RUN npm run build

# ─── Stage 2: PHP + Nginx (production) ─────────────────────────────────────
FROM php:8.4-fpm-alpine AS production

# System deps
RUN apk add --no-cache \
    nginx \
    supervisor \
    curl \
    git \
    unzip \
    libpq-dev \
    oniguruma-dev \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip opcache

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy app source
COPY . .

# Copy compiled assets from Stage 1
COPY --from=frontend /app/public/build ./public/build

# Install PHP deps
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Copy config files
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/supervisord.conf /etc/supervisord.conf
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]