# Stage 1 - Build Frontend (Vite)
FROM node:20 AS frontend

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

# 🔥 Copy production Vite variables into .env – Vite reads them automatically
COPY .env.production .env

# Build (no debug, safe memory limit)
RUN NODE_OPTIONS="--max-old-space-size=2048" npm run build


# Stage 2 - Backend
FROM php:8.2-fpm AS backend

RUN apt-get update && apt-get install -y \
    git curl unzip libpq-dev libonig-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql mbstring zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
COPY . .
COPY --from=frontend /app/public/dist ./public/dist

RUN composer install --no-dev --optimize-autoloader

RUN php artisan config:clear && \
    php artisan route:clear && \
    php artisan view:clear

CMD ["php-fpm"]