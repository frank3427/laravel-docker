#!/bin/bash

set -ex # Exit immediately if a command exits with a non-zero status.

LARAVEL_HORIZON_ENABLED=${LARAVEL_HORIZON_ENABLED:-true}
XDEBUG_ENABLED=${XDEBUG_ENABLED:-false}

QUEUE_TIMEOUT=${QUEUE_TIMEOUT:-90}
QUEUE_MEMORY=${QUEUE_MEMORY:-128}
QUEUE_TRIES=${QUEUE_TRIES:-3}
QUEUE_SLEEP=${QUEUE_SLEEP:-5}

# Toggle Xdebug
if [[ $XDEBUG_ENABLED == false ]]; then

    if [ -f ${PHP_INI_SCAN_DIR}/xdebug.ini ]; then
        # Comment all lines
        sed -i "s/^/;/" ${PHP_INI_SCAN_DIR}/xdebug.ini
    fi

    if [ -f ${PHP_INI_SCAN_DIR}/docker-php-ext-xdebug.ini ]; then
        # Comment all lines
        sed -i "s/^/;/" ${PHP_INI_SCAN_DIR}/docker-php-ext-xdebug.ini
    fi

fi

# Increase the memory_limit
if [ ! -z "$PHP_MEM_LIMIT" ]; then
    sed -i "/memory_limit = .*/c\memory_limit = ${PHP_MEM_LIMIT}" $PHP_INI_DIR/php.ini
fi

# Increase the post_max_size
if [ ! -z "$PHP_POST_MAX_SIZE" ]; then
    sed -i "/post_max_size = .*/c\post_max_size = ${PHP_POST_MAX_SIZE}" $PHP_INI_DIR/php.ini
fi

# Increase the upload_max_filesize
if [ ! -z "$PHP_UPLOAD_MAX_FILESIZE" ]; then
    sed -i "/upload_max_filesize = .*/c\upload_max_filesize= ${PHP_UPLOAD_MAX_FILESIZE}" $PHP_INI_DIR/php.ini
fi

# Set Timezone
if [ ! -z "$TIMEZONE" ]; then
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
fi

########
## PHP-FPM CONFIG
########

# ## Not required because it is not a web server

# echo "Starting PHP-FPM configurations"
# echo

# sed -i "/listen = .*/c\listen = [::]:9000" ${PHP_FPM_POOL_DIR}/www.conf
# sed -i "/access.log = .*/c\;access.log =" ${PHP_FPM_POOL_DIR}/www.conf
# sed -i "/daemonize = .*/c\daemonize = yes" ${PHP_INI_DIR}-fpm.conf

# sed -i \
#         -e "/pm = .*/c\pm = dynamic" \
#         -e "/pm.max_children = .*/c\pm.max_children = 25" \
#         -e "/pm.start_servers = .*/c\pm.start_servers = 10" \
#         -e "/pm.min_spare_servers = .*/c\pm.min_spare_servers = 5" \
#         -e "/pm.max_spare_servers = .*/c\pm.max_spare_servers = 10" \
#         -e "/pm.max_requests = .*/c\pm.max_requests = 1000" \
#         -e "/rlimit_files = .*/c\rlimit_files = 131072" \
#         -e "/rlimit_core = .*/c\rlimit_core = unlimited" \
# ${PHP_FPM_POOL_DIR}/www.conf

# ## Starts FPM
# nohup /usr/local/sbin/php-fpm -y /usr/local/etc/php-fpm.conf -F -O 2>&1 &

echo "Laravel - Clear all"
echo

php artisan clear-compiled
php artisan view:clear
php artisan config:clear
php artisan route:clear

# if [ "$APP_ENV" == "production" ]; then
#     # Remove Xdebug in production
#     rm ${PHP_INI_SCAN_DIR}/docker-php-ext-xdebug.ini

#     php artisan route:cache
#     php artisan config:cache
# fi

echo "Laravel - Cache Optimization"
echo

php artisan route:cache
# @see https://github.com/laravel/framework/issues/21727
php artisan config:cache

########
## SUPERVISOR
########

# @see http://supervisord.org/subprocess.html#subprocess-environment

echo
echo "Starting [SUPERVISOR]"
echo

if [ $LARAVEL_HORIZON_ENABLED == true ];
then

    # echo "Laravel/Composer - Install Horizon"
    # echo

    # composer require laravel/horizon
    # php artisan queue:failed-table
    # php artisan migrate
    # php artisan horizon:install
    # # php artisan vendor:publish --provider="Laravel\Horizon\HorizonServiceProvider"

    echo "Running the [HORIZON] Service..."
    echo

    # ... artisan down, composer install, migrate etc
    # php artisan config:cache
    # php artisan route:cache
    # php artisan horizon:purge
    # php artisan horizon:terminate
    # php artisan queue:restart
    # php artisan up

    sudo sed -i \
                -e "s|%%DEFAULT_USER%%|$DEFAULT_USER|g" \
                -e "s|%%REDIS_HOST%%|$REDIS_HOST|g" \
                -e "s|%%REDIS_PORT%%|$REDIS_PORT|g" \
                -e "s|%%REMOTE_SRC%%|${REMOTE_SRC}|g" /etc/supervisor/conf.d/laravel-horizon.conf.tpl \
    \
    && sudo mv /etc/supervisor/conf.d/laravel-horizon.conf.tpl /etc/supervisor/conf.d/laravel-horizon.conf
    # \
    # && sudo supervisorctl start laravel-horizon:*

else

    echo "Running the [QUEUE] Service..."
    echo

    sudo sed -i \
                -e "s|%%REDIS_HOST%%|$REDIS_HOST|g" \
                -e "s|%%REDIS_PORT%%|$REDIS_PORT|g" \
                -e "s|%%QUEUE_CONNECTION%%|$QUEUE_CONNECTION|g" \
                -e "s|%%QUEUE_TIMEOUT%%|$QUEUE_TIMEOUT|g" \
                -e "s|%%QUEUE_MEMORY%%|$QUEUE_MEMORY|g" \
                -e "s|%%QUEUE_TRIES%%|$QUEUE_TRIES|g" \
                -e "s|%%QUEUE_SLEEP%%|$QUEUE_SLEEP|g" \
                -e "s|%%REMOTE_SRC%%|${REMOTE_SRC}|g" \
                -e "s|%%APP_ENV%%|$APP_ENV|g" \
                -e "s|%%DEFAULT_USER%%|$DEFAULT_USER|g" \
                -e "s|%%QUEUE_NAME%%|$QUEUE_NAME|g" /etc/supervisor/conf.d/laravel-worker.conf.tpl \
    \
    && sudo mv /etc/supervisor/conf.d/laravel-worker.conf.tpl /etc/supervisor/conf.d/laravel-worker.conf \
    # \
    # && sudo supervisorctl start laravel-worker:*

fi

php -v

## Start supervisord and services
# sudo /usr/bin/supervisord --nodaemon --configuration /etc/supervisor/supervisord.conf

# sudo supervisorctl stop all
# php artisan horizon:purge
# php artisan horizon:terminate
# sudo supervisorctl reread
# sudo supervisorctl update
# sudo supervisorctl start all

## Start cron service
# service cron start
# echo "Running the schedule service..."

## Docker Command
exec "$@"
