#!/bin/sh

set -e

echo "========================================"
echo " ExpenseHub Backend"
echo "========================================"

cd /var/www/html

# --------------------------------------------------
# Install PHP dependencies automatically
# --------------------------------------------------

if [ ! -f vendor/autoload.php ]; then
    echo "==> vendor/ not found."
    echo "==> Installing Composer dependencies..."

    composer install \
        --no-interaction \
        --prefer-dist

    echo "==> Composer dependencies installed."
else
    echo "==> Composer dependencies already installed."
fi


# --------------------------------------------------
# Laravel application setup
# --------------------------------------------------

if [ -f artisan ]; then
    echo "==> Running Laravel migrations..."

    php artisan migrate --force

    echo "==> Laravel migrations completed."
fi


# --------------------------------------------------
# Start the container command
# --------------------------------------------------

echo "==> Starting: $*"

exec "$@"