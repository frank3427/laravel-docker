#!/usr/bin/env bash

set -e # Exit immediately if a command exits with a non-zero status.

## Keep PHP-FPM running
## First arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php-fpm "$@"
fi

###
## Log to stdout/stderr
###
log() {
    log_lvl="${1}"
    log_msg="${2}"

    log_clr_ok="\033[0;32m"
    log_clr_info="\033[0;34m"
    log_clr_warn="\033[0;33m"
    log_clr_err="\033[0;31m"
    log_clr_rst="\033[0m"

    if [ "${log_lvl}" = "ok" ]; then
        printf "${log_clr_ok}[OK]   %s${log_clr_rst}\n" "${log_msg}"
    elif [ "${log_lvl}" = "info" ]; then
        printf "${log_clr_info}[INFO] %s${log_clr_rst}\n" "${log_msg}"
    elif [ "${log_lvl}" = "warn" ]; then
        printf "${log_clr_warn}[WARN] %s${log_clr_rst}\n" "${log_msg}" 1>&2 # stdout -> stderr
    elif [ "${log_lvl}" = "err" ]; then
        printf "${log_clr_err}[ERR]  %s${log_clr_rst}\n" "${log_msg}" 1>&2 # stdout -> stderr
    else
        printf "${log_clr_err}[???]  %s${log_clr_rst}\n" "${log_msg}" 1>&2 # stdout -> stderr
    fi

    unset -v log_lvl
    unset -v log_msg
    unset -v log_clr_ok
    unset -v log_clr_info
    unset -v log_clr_warn
    unset -v log_clr_err
    unset -v log_clr_rst
}

###
## Wrapper for run_run command
###
run() {
    run_cmd="${1}"

    run_clr_red="\033[0;31m"
    run_clr_green="\033[0;32m"
    run_clr_reset="\033[0m"

    printf "${run_clr_red}%s \$ ${run_clr_green}${run_cmd}${run_clr_reset}\n" "$( whoami )"

    /bin/sh -c "LANG=C LC_ALL=C ${run_cmd}"

    unset -v run_cmd
    unset -v run_clr_red
    unset -v run_clr_green
    unset -v run_clr_reset
}

if [ "$(stat -c "%U:%G" $REMOTE_SRC)" != "$DEFAULT_USER:$DEFAULT_USER" ]; then
    log "info" "Creating $REMOTE_SRC and changing container user permission"

    mkdir -p $REMOTE_SRC
    sudo chown -R $DEFAULT_USER:$DEFAULT_USER $REMOTE_SRC
fi

log "info" "Starting PHP-FPM configurations"

sed -i "/user = .*/c\user = ${DEFAULT_USER}" ${PHP_FPM_POOL_DIR}/www.conf
sed -i "/^group = .*/c\group = ${DEFAULT_USER}" ${PHP_FPM_POOL_DIR}/www.conf
sed -i "/listen.owner = .*/c\listen.owner = ${DEFAULT_USER}" ${PHP_FPM_POOL_DIR}/www.conf
sed -i "/listen.group = .*/c\listen.group = ${DEFAULT_USER}" ${PHP_FPM_POOL_DIR}/www.conf
sed -i "/listen = .*/c\listen = [::]:9000" ${PHP_FPM_POOL_DIR}/www.conf
sed -i "/pid = .*/c\;pid = run/php-fpm.pid" ${PHP_INI_DIR}-fpm.conf
sed -i "/daemonize = .*/c\daemonize = no" ${PHP_INI_DIR}-fpm.conf

# sed -i "/access.log = .*/c\access.log = /proc/self/fd/2" ${PHP_FPM_POOL_DIR}/www.conf
# sed -i "/slowlog = .*/c\slowlog = /proc/self/fd/2" ${PHP_FPM_POOL_DIR}/www.conf
# sed -i "/error_log = .*/c\error_log = /proc/self/fd/2" ${PHP_INI_DIR}-fpm.conf
# sed -i "/;php_admin_value[error_log] = .*/c\php_admin_value[error_log] = /proc/self/fd/2" ${PHP_FPM_POOL_DIR}/www.conf

sed -i "/;clear_env = .*/c\clear_env = no" ${PHP_FPM_POOL_DIR}/www.conf
sed -i "/;catch_workers_output = .*/c\catch_workers_output = yes" ${PHP_FPM_POOL_DIR}/www.conf

####
## Laravel APP
####

if [ -z "$APP_ENV" ]; then
    log "err" "A APP_ENV environment is required to run this container"
    exit 1
fi

if [ ! -d "vendor" ]; then
    log "warn" "Composer vendor folder was not installed. Running $> composer install --prefer-dist --no-interaction --optimize-autoloader --no-dev"

    run "composer install --prefer-dist --no-interaction --optimize-autoloader --no-dev"
    run "composer dump-autoload --optimize"
    run "composer run-script post-root-package-install"
    run "composer run-script post-create-project-cmd"
    run "composer run-script post-autoload-dump"
fi

run "php artisan storage:link"

if [[ $PROJECT_ENVIRONMENT == "production" ]]; then
    # Remove Xdebug in production
    run "rm ${PHP_INI_SCAN_DIR}/docker-php-ext-xdebug.ini"

    # PRODUCTION
    log "info" "Laravel - Cache - Production"

    run "php artisan route:cache"
    # @see https://github.com/laravel/framework/issues/21727
    run "php artisan config:cache"
fi

if [ "$PROJECT_ENVIRONMENT" == "development" ]; then
    # Remove Opcache in development
    run "rm ${PHP_INI_SCAN_DIR}/docker-php-ext-opcache.ini"

    # DEVELOPMENT
    log "info" "Laravel - Clear all and permissions"

    run "php artisan clear-compiled"
    run "php artisan view:clear"
    run "php artisan config:clear"
    run "php artisan route:clear"
    # run "php artisan cache:clear"

    log "info" "php-fpm.conf/www.conf Configurations"

    # sed -i \
    #     -e "/rlimit_files = .*/c\;rlimit_files = " \
    #     -e "/rlimit_core = .*/c\;rlimit_core = " \
    # ${PHP_INI_DIR}-fpm.conf

    # @see https://www.kinamo.be/en/support/faq/determining-the-correct-number-of-child-processes-for-php-fpm-on-nginx
    # @see https://gist.github.com/holmberd/44fa5c2555139a1a46e01434d3aaa512
    # @see https://serverpilot.io/docs/how-to-change-the-php-fpm-max_children-setting
    # @see https://www.edufukunari.com.br/how-to-solve-php-fpm-server-reached-max-children/
    # Determine system RAM and average pool size memory.
        # free -h
        # All fpm processes: ps -ylC php-fpm --sort:rss (The column RSS contains the average memory usage in kilobytes per process)
        # Average memory: ps --no-headers -o "rss,cmd" -C php-fpm | awk '{ sum+=$1 } END { printf ("%d%s\n", sum/NR/1024,"M") }'
        # All fpm processes memory: ps -eo size,pid,user,command --sort -size | awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' | grep php-fpm

    sed -i \
        -e "/pm = .*/c\pm = static" \
        -e "/pm.max_children = .*/c\pm.max_children = 10" \
        -e "/pm.start_servers = .*/c\pm.start_servers = 4" \
        -e "/pm.min_spare_servers = .*/c\pm.min_spare_servers = 2" \
        -e "/pm.max_spare_servers = .*/c\pm.max_spare_servers = 6" \
        -e "/pm.max_requests = .*/c\pm.max_requests = 100" \
        -e "/rlimit_files = .*/c\;rlimit_files = " \
        -e "/rlimit_core = .*/c\;rlimit_core = " \
    ${PHP_FPM_POOL_DIR}/www.conf

    # { \
    #     echo '[global]'; \
    #     echo; \
    #     echo 'error_log = /proc/self/fd/2'; \
    #     echo; \
    #     echo 'daemonize = no'; \
    #     echo; \
    #     echo 'include=etc/php-fpm.d/*.conf'; \
    # } | tee ${PHP_INI_DIR}-fpm.conf # == /usr/local/etc/php-fpm.conf

    # { \
    #     echo '[www]'; \
    #     echo 'user = www-data'; \
    #     echo 'group = www-data'; \
    #     echo; \
    #     echo 'listen = 9000'; \
    #     echo; \
    #     echo 'pm = dynamic'; \
    #     echo 'pm.max_children = 5'; \
    #     echo 'pm.start_servers = 2'; \
    #     echo 'pm.min_spare_servers = 1'; \
    #     echo 'pm.max_spare_servers = 3'; \
    #     echo; \
    #     echo '; if we send this to /proc/self/fd/1, it never appears'; \
    #     echo 'access.log = /proc/self/fd/2'; \
    #     echo; \
    #     echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
    #     echo 'catch_workers_output = yes'; \
    #     echo; \
    #     echo '; Clear environment in FPM workers'; \
    #     echo 'clear_env = no'; \
    # } > ${PHP_FPM_POOL_DIR}/www.conf # == /usr/local/etc/php-fpm.d/www.conf

    ## Change PHP.INI
    sed -i \
            -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" \
            -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 8M/g" \
            -e "s/post_max_size\s*=\s*2M/post_max_size = 8M/g" \
            -e "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" \
        $PHP_INI_DIR/php.ini
fi

run "php --ini"
run "php -v"

log "ok" "[PHP-FPM] Init process complete; Ready for start up."

unset DB_USER
unset DB_PASSWORD

## Run the original command
exec "$@"
