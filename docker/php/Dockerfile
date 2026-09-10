FROM php:8.3-fpm-alpine

RUN apk add --no-cache \
        bash \
        curl \
        git \
        icu-dev \
        libzip-dev \
        oniguruma-dev \
        zip \
        unzip \
        mysql-client

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && docker-php-ext-install pdo pdo_mysql mbstring bcmath intl opcache \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer 
#тяну composer из официального образа composer:2, чтобы не устанавливать его вручную

WORKDIR /var/www/html

COPY app/composer.json app/composer.lock* ./
RUN composer install \
        --no-dev \
        --no-scripts \
        --no-autoloader \
        --prefer-dist \
        --no-interaction
#поставил composer install без dev зависимостей что бы он не скачивал лишнее а только нужное

COPY app/. .

RUN composer dump-autoload --optimize --no-dev \
    && mkdir -p storage/framework/cache storage/framework/sessions \
        storage/framework/testing storage/framework/views \
        storage/logs storage/app/public bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache public
    #&& chown -R www-data:www-data storage bootstrap/cache
    
COPY docker/php/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER www-data

EXPOSE 9000

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]