#!/bin/bash
set -euo pipefail

echo "[entrypoint] waiting for database at ${DB_HOST}:${DB_PORT}..."
until php -r "new PDO('mysql:host=${DB_HOST};port=${DB_PORT}', '${DB_USERNAME}', '${DB_PASSWORD}');" 2>/dev/null; do
    sleep 2
done
echo "[entrypoint] database is reachable"

mkdir -p storage/framework/cache storage/framework/sessions \
    storage/framework/testing storage/framework/views \
    storage/logs storage/app/public

if [ "${RUN_MIGRATIONS:-false}" = "true" ]; then
    echo "[entrypoint] running migrations"
    php artisan migrate --force

    echo "[entrypoint] caching config/routes/views"
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache

    echo "[entrypoint] linking storage"
    php artisan storage:link || true
fi

exec "$@"