#!/bin/bash
set -eux

function fixperms() {
    for folder in $@; do
        if $(find ${folder} ! -user nginx -o ! -group nginx | egrep '.' -q); then
            echo "Fixing permissions in $folder..."
            chown -R nginx. "${folder}"
        else
            echo "Permissions already fixed in ${folder}."
        fi
    done
}

function runas_nginx() {
    su - nginx -s /bin/sh -c "$1"
}

TZ=${TZ:-UTC}

HSTS_HEADER=${HSTS_HEADER:-max-age=31536000; includeSubdomains; preload}
RP_HEADER=${RP_HEADER:-strict-origin-when-cross-origin}

# Timezone
echo "Setting Timezone to ${TZ} ..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# Nginx
echo "Setting Nginx configuration ..."

find /etc/nginx -type f -exec sed -i \
                                        -e "s/\\\.example\\\.com/\\\.$(echo $DOMAIN_APP | sed 's/\./\\\\./g')/g" \
                                        -e "s/example\\\.com/$(echo $DOMAIN_APP | sed 's/\./\\\\./g')/g" \
                                    {} \;

find /etc/nginx -type f -exec sed -i \
                                        -e "s|{{DOMAIN_APP}}|$DOMAIN_APP|g" \
                                        -e "s,{{APP_PATH_PREFIX}},$APP_PATH_PREFIX,g" \
                                    {} \;

sed -i \
        -e "s/@HSTS_HEADER@/$HSTS_HEADER/g" \
        -e "s/@RP_HEADER@/$RP_HEADER/g" /etc/nginx/snippets/security_http_headers.conf

# Remove DUPLICATED-conflicting server name [APP]
rm /etc/nginx/servers/app.conf

# echo "Fixing permissions..."
# fixperms "$APP_PATH_PREFIX/app" /var/cache/nginx
# echo "Installing APP"
# runas_nginx "php artisan serve --port=8080 &>/dev/null"

## Docker Command
exec "$@"
