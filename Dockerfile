# Stage 1 - Build Frontend (Vite)
FROM node:20 AS frontend

WORKDIR /app

# Receive VITE_ variables from Render (must match the dashboard variable names)
ARG VITE_APP_NAME
# Add more ARGs here if you use other VITE_* variables

# Make them available during the build
ENV VITE_APP_NAME=$VITE_APP_NAME

COPY package*.json ./
RUN npm ci

COPY . .

# Debug: print the VITE_ variables so we can see them in the Render log
RUN printenv | grep VITE_

# Build with verbose logging and increased memory
RUN NODE_OPTIONS="--max-old-space-size=4096" VITE_LOG_LEVEL=info npm run build -- --debug


# Stage 2 - Backend
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

# Copy built frontend assets from stage 1
COPY --from=frontend /app/public/dist ./public/dist

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Laravel cleanup (safe for production builds)
RUN php artisan config:clear && \
    php artisan route:clear && \
    php artisan view:clear

CMD ["php-fpm"]