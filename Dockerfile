# Stage 1 - Build Frontend (Vite)
FROM node:20 AS frontend

WORKDIR /app

# ------------------------------------------------------------
# 🔧 Receive VITE_ variables from Render's build arguments
# ------------------------------------------------------------
ARG VITE_APP_NAME
# 👇 Add one ARG for every other VITE_ variable your code uses, e.g.:
# ARG VITE_APP_URL
# ARG VITE_PUSHER_APP_KEY

# Convert ARGs to ENVs so Vite can see them during build
ENV VITE_APP_NAME=$VITE_APP_NAME
# ENV VITE_APP_URL=$VITE_APP_URL
# ENV VITE_PUSHER_APP_KEY=$VITE_PUSHER_APP_KEY

# ------------------------------------------------------------
COPY package*.json ./
RUN npm ci               # safer for CI (respects lock file)

COPY . .

# Debug: show all VITE_ variables right before build
RUN printenv | grep VITE_

# Build with verbose output and increased memory
RUN NODE_OPTIONS="--max-old-space-size=4096" VITE_LOG_LEVEL=info npm run build -- --debug


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

# Copy built frontend assets from stage 1
COPY --from=frontend /app/public/dist ./public/dist

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Laravel cleanup (safe for production builds)
RUN php artisan config:clear && \
    php artisan route:clear && \
    php artisan view:clear

CMD ["php-fpm"]