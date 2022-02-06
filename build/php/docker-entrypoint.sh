#!/bin/sh
set -e

if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

if [ "$1" = 'php-fpm' ] || [ "$1" = 'php' ] || [ "$1" = 'artisan' ]; then
  if [ "$APP_ENV" != 'local' ] && [ -f "/var/www/composer.json" ]; then
    composer install --prefer-dist --no-progress --no-interaction
  fi

  if [ -z "${APP_KEY}" ]; then
    php artisan key:generate
  fi

  if ls -A database/migrations/*.php >/dev/null 2>&1; then
    php artisan migrate
  fi
fi

exec docker-php-entrypoint "$@"
