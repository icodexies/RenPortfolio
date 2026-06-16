# Stage 1 - Build Frontend (Vite)
FROM node:20 AS frontend

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Fix: increase Node memory for Vite/Rolldown build (important for Render)
RUN NODE_OPTIONS="--max-old-space-size=4096" npm run build


# Stage 2 - Backend (Laravel + PHP + Composer)
FROM php:8.2-fpm AS backend

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl unzip libpq-dev libonig-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql mbstring zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy backend files
COPY . .

# Copy built frontend assets
COPY --from=frontend /app/public/dist ./public/dist

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Laravel cleanup (safe for production builds)
RUN php artisan config:clear && \
    php artisan route:clear && \
    php artisan view:clear

CMD ["php-fpm"]