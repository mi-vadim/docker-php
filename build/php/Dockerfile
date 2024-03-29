ARG PHP_VERSION=8.2.6
ARG environment

FROM php:${PHP_VERSION}-fpm-bullseye as base
ARG APCU_VERSION=5.1.22

RUN apt-get update && apt-get install -y  \
    acl \
    file \
    gettext \
    git \
    gnupg2 \
    libgmp10 \
  	zlib1g-dev \
    libzip-dev \
    libicu-dev \
    libpq-dev \
    zip unzip \
  && pecl install apcu-${APCU_VERSION} redis \
  && docker-php-ext-install -j$(nproc) pdo intl pdo_pgsql\
  && docker-php-ext-configure intl \
  && docker-php-ext-enable redis apcu opcache

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN ln -s $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"

# Set working directory
WORKDIR /var/www

# Add default user
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

COPY build/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

FROM base as image-local
ARG APP_ENV=local

RUN pecl install xdebug-3.2.2 && docker-php-ext-enable xdebug

COPY build/php/conf.d/application.dev.ini $PHP_INI_DIR/conf.d/application.ini
COPY build/php/conf.d/xdebug.ini $PHP_INI_DIR/conf.d/xdebug.ini


FROM base as image-production
ARG APP_ENV=prod

COPY build/php/conf.d/application.prod.ini $PHP_INI_DIR/conf.d/application.ini

COPY composer.json composer.lock ./
RUN set -eux; \
	composer install --prefer-dist --no-dev --no-scripts --no-progress; \
	composer clear-cache

COPY --chown=www:www .env artisan.php /
COPY --chown=www:www app bootstrap config database public resources routes storage /

RUN set -eux; \
	composer dump-autoload --classmap-authoritative --no-dev; \
	composer dump-env prod; \
	composer run-script --no-dev post-install-cmd; \
	sync

FROM image-$environment as build

USER www
EXPOSE 9000

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]
