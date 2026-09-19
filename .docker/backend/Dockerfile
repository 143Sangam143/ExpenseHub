# syntax=docker/dockerfile:1
ARG PHP_VERSION=8.3

FROM php:${PHP_VERSION}-fpm-alpine AS base

RUN apk add --no-cache \
        bash curl freetype-dev icu-dev libjpeg-turbo-dev libpng-dev \
        libwebp-dev libzip-dev oniguruma-dev postgresql-dev zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j"$(nproc)" bcmath exif gd intl pcntl pdo_pgsql pgsql zip \
    && docker-php-ext-enable opcache

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN addgroup -g 1000 www && adduser -G www -u 1000 -D -h /var/www/html www

WORKDIR /var/www/html

# ---------- development ----------
FROM base AS development

RUN apk add --no-cache $PHPIZE_DEPS linux-headers \
    && pecl install xdebug \
    && rm -f /usr/local/etc/php/conf.d/*xdebug*

USER www
EXPOSE 9000
ENTRYPOINT ["sh", "/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]

# ---------- builder (prod dependencies) ----------
FROM base AS builder

COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

COPY . .
RUN composer dump-autoload --optimize --no-dev \
    && chown -R www:www /var/www/html

# ---------- production ----------
FROM base AS production

COPY --from=builder --chown=www:www /var/www/html /var/www/html

USER www
EXPOSE 9000
ENTRYPOINT ["sh", "/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]