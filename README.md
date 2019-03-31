# My Docker Environment 🐳

> This is a personal collection of Docker tools and images.

## Install Docker

-   [Ubuntu](https://docs.docker.com/engine/installation/linux/ubuntu/)
-   [Windows](https://docs.docker.com/docker-for-windows/install/)
-   [MacOS](https://docs.docker.com/docker-for-mac/install/)

> Download and install [Docker](https://docs.docker.com/engine/installation/) (**>= 18.09**) for your platform and you also have to install [Docker compose](https://docs.docker.com/compose/install/) (**>= 1.24.0**).

## Project structure

```
├── Makefile
├── docker-compose.yml
├── php
│   └── Dockerfile
├── app
│   ├── Dockerfile
│   ├── docker-entrypoint.sh
│   ├── app.env
│   ├── app-queue.env
│   ├── app-scheduler.env
│   └── config
│       ├── php.ini-development.ini
│       ├── php.ini-production.ini
│       ├── extensions
│       │   ├── opcache.ini
│       │   └── xdebug.ini
│       ├── fpm
│       │   ├── php-fpm.conf
│       │   └── www.conf
│       └── vscode
│           └── launch.json
├── queue
│   ├── Dockerfile
│   ├── docker-entrypoint.sh
│   └── config
│       ├── supervisord.conf
│       └── templates
│           ├── laravel-horizon.conf.tpl
│           └── laravel-worker.conf.tpl
├── scheduler
│   ├── Dockerfile
│   ├── docker-entrypoint.sh
│   └── cron-jobs
│       └── laravel-scheduler
├── nginx
│   ├── Dockerfile
│   ├── docker-entrypoint.sh
│   ├── certs
│   │   ├── cert.pem
│   │   ├── chain.pem
│   │   ├── dhparam4096.pem
│   │   ├── fullchain.pem
│   │   └── privkey.pem
│   ├── config
│   │   ├── fastcgi.conf
│   │   ├── mime.types
│   │   ├── nginx.conf
│   │   ├── servers
│   │   │   ├── admin.conf
│   │   │   ├── api.conf
│   │   │   ├── app.conf
│   │   │   ├── site.conf
│   │   │   └── webmail.conf
│   │   └── snippets
│   │       ├── PHP_FPM.conf
│   │       ├── cache_expiration.conf
│   │       ├── deny_ips.conf
│   │       ├── real_ip.conf
│   │       ├── security_http_headers.conf
│   │       ├── ssl_best_practices.conf
│   │       └── ssl_common_certificates.conf
│   └── helpers
│       └── cert_status.sh
├── redis
│   └── redis.conf
├── mysql
│   ├── my.cnf
│   ├── mysql.env
│   └── ssl
│       ├── ca-key.pem
│       ├── ca.pem
│       ├── client-cert.pem
│       ├── client-key.pem
│       ├── private_key.pem
│       ├── public_key.pem
│       ├── server-cert.pem
│       └── server-key.pem
├── mongodb
│   ├── mongo-init.js
│   ├── mongod.conf
│   └── ssl
│       ├── mongodb.crt
│       ├── mongodb.csr
│       ├── mongodb.key
│       ├── mongodb.pem
│       ├── rootCA.key
│       ├── rootCA.pem
│       └── rootCA.srl
├── elastic
│   ├── docker-compose-setup.yml
│   ├── docker-compose.yml
│   ├── config
│   │   ├── elasticsearch
│   │   │   └── elasticsearch.yml
│   │   ├── filebeat
│   │   │   └── filebeat.yml
│   │   ├── kibana
│   │   │   └── kibana.yml
│   │   ├── logstash
│   │   │   ├── logstash.yml
│   │   │   └── pipeline
│   │   │       └── logstash.conf
│   │   ├── metricbeat
│   │   │   └── metricbeat.yml
│   │   ├── packetbeat
│   │   │   └── packetbeat.yml
│   │   └── ssl
│   │       ├── ca
│   │       └── instances.yml
│   ├── scripts
│   │   ├── setup-beat.sh
│   │   ├── setup-elasticsearch.sh
│   │   ├── setup-kibana.sh
│   │   ├── setup-logstash.sh
│   │   ├── setup-users.sh
│   │   └── setup.sh
│   └── setups
│       ├── docker-compose.setup.beats.yml
│       ├── docker-compose.setup.elasticsearch.yml
│       ├── docker-compose.setup.kibana.yml
│       └── docker-compose.setup.logstash.yml
└── traefik
    └── traefik.toml
```

## Softwares included:

-   _`Nginx`_ 1.15.x
-   _`MySQL`_ 5.7
-   _`Redis`_ 4.x
-   [_`Logstash`_ | _`Kibana`_ | _`ElasticSearch`_] 6.3.x
-   _`PHP`_ 7.2.x [**Installed PHP extensions**] (The following modules and extensions have been enabled, in addition to those you can already find in the [official PHP image](https://hub.docker.com/r/_/php/))
    -   **`amqp`**
    -   `bcmath`
    -   `calendar`
    -   `Core`
    -   `ctype`
    -   `curl`
    -   `date`
    -   `dom`
    -   **`ds`**
    -   `exif`
    -   `fileinfo`
    -   `filter`
    -   `ftp`
    -   `gd`
    -   `gettext`
    -   `gmp`
    -   `hash`
    -   `iconv`
    -   **`igbinary`**
    -   `intl`
    -   `json`
    -   `libxml`
    -   **`lzf`**
    -   `mbstring`
    -   **`meminfo`**
    -   **`mongodb`**
    -   `mysqli`
    -   `mysqlnd`
    -   `openssl`
    -   `pcntl`
    -   `pcre`
    -   `PDO`
    -   `pdo_mysql`
    -   `pdo_sqlite`
    -   **`pdo_sqlsrv`**
    -   `Phar`
    -   `posix`
    -   `readline`
    -   **`redis`**
    -   `Reflection`
    -   `session`
    -   `shmop`
    -   `SimpleXML`
    -   `soap`
    -   `sockets`
    -   `sodium`
    -   `SPL`
    -   `sqlite3`
    -   **`sqlsrv`**
    -   `standard`
    -   **`swoole`**
    -   `tidy`
    -   `tokenizer`
    -   **`xdebug`**
    -   `xml`
    -   `xmlreader`
    -   `xmlwriter`
    -   `xsl`
    -   `zip`
    -   `zlib`
    -   **`Xdebug`**
    -   **`Zend OPcache`**

You are able to find all installed PHP extensions by running `php -m` inside your workspace.

### Available tools

_Composer_ - https://getcomposer.org/

> Composer helps you declare, manage and install dependencies of PHP projects.

_PHPUnit – The PHP Testing Framework_ - https://phpunit.de/

> PHPUnit is a programmer-oriented testing framework for PHP. It is an instance of the xUnit architecture for unit testing frameworks.

_prestissimo_ - https://github.com/hirak/prestissimo

> composer parallel install plugin.

_PHP Coding Standards Fixer_ - http://cs.sensiolabs.org/

> The PHP Coding Standards Fixer tool fixes most issues in your code when you want to follow the PHP coding standards
> as defined in the PSR-1 and PSR-2 documents and many more.

_PHP CodeSniffer_ - https://github.com/squizlabs/PHP_CodeSniffer

> PHP_CodeSniffer is a set of two PHP scripts; the main `phpcs` script that tokenizes PHP, JavaScript and CSS files to detect violations of a defined coding standard, and a second `phpcbf` script to automatically correct coding standard violations. PHP_CodeSniffer is an essential development tool that ensures your code remains clean and consistent.

## Getting Started

If this was your app, to start local development you would:

-   Download the repository and put it in the root of the project
-   Create the base image 1.0 from DockerFile.1.0 - PHP
    ```bash
    cd docker/php && \
        docker build -t app:1.0 -f Dockerfile.1.0 \
            --build-arg INSTALL_PHP_AMQP=true \
            --build-arg INSTALL_PHP_MONGO=true \
            --build-arg INSTALL_PHP_SWOOLE=true \
            --build-arg INSTALL_PHP_DS=true \
            --build-arg INSTALL_PHP_MEMINFO=true \
            --build-arg INSTALL_PHP_SQLSRV=true \
        .
    ```
-   Running `docker-compose up` is all you need. It will:
-   Build custom local image enabled for development.
-   Start container from that image with ports `8080:80` and `8083:443` open (on localhost or docker-machine).
-   Mounts the pwd to the app dir in container.
-   If you need other services like databases, just add to compose file and they'll be added to the custom Docker network for this app on `up`.
-   If you need to add packages to Composer, npm, node, etc. then stop docker-compose and run `docker-compose up --build` to ensure image is updated.
-   Be sure to use `docker-compose down` to cleanup after your done dev'ing.

## Assumptions

-   You have Docker and Docker-Compose installed (Docker for Mac, Docker for Windows, get.docker.com and manual Compose installed for Linux).
-   You want to use Docker for local development (i.e. never need to install php or npm on host) and have dev and prod Docker images be as close as possible.
-   You don't want to lose fidelity in your dev workflow. You want a easy environment setup, using local editors, debug/inspect, local code repo, while web server runs in a container.
-   You use `docker-compose` for local development only (docker-compose was never intended to be a production deployment tool anyway).
-   The `docker-compose.yml` is not meant for `docker stack deploy` in Docker Swarm, it's meant for happy local development.

## Building only

**PHP**

```bash
cd docker/php &&
    docker build -t app:1.0 -f Dockerfile.1.0 \
        --build-arg INSTALL_PHP_AMQP=true \
        --build-arg INSTALL_PHP_MONGO=true \
        --build-arg INSTALL_PHP_SWOOLE=true \
        --build-arg INSTALL_PHP_DS=true \
        --build-arg INSTALL_PHP_MEMINFO=true \
        --build-arg INSTALL_PHP_SQLSRV=true \
    .
```

**Nginx**

```bash
cd docker/nginx && docker build -t webserver:1.0 -f Dockerfile .
```

## Helpers commands

_Access NGINX container_

```bash
docker exec -t -i nginx /bin/bash
```

_Access PHP/APP container_

```bash
docker exec -t -i app /bin/bash
```

_Install PHP Modules_

```bash
docker exec -t -i app /bin/bash
# After
$ /usr/local/bin/docker-php-ext-configure sockets
$ /usr/local/bin/docker-php-ext-install sockets
```

_Accessing Redis Container from Local Computer_

```bash
redis-cli -h 127.0.0.1 -p 63791 -a 'P5+Rbhq,%--8[]CA'
```

_Accessing MySQL Container from Local Computer_

```bash
mysql -h 127.0.0.1 -P 33061 -uhomestead -psecret
```

_Running Assorted Commands_

```bash
docker-compose exec app php artisan key:generate
docker-compose exec app php artisan migrate --seed

docker-compose exec app composer install
docker-compose exec app npm install
```

## Contributing

If you find an issue, or have a special wish not yet fulfilled, please [open an issue on GitHub](https://github.com/AllysonSilva/docker/issues) providing as many details as you can (the more you are specific about your problem, the easier it is for us to fix it).

Pull requests are welcome, too 😁! Also, it would be nice if you could stick to the [best practices for writing Dockerfiles](https://docs.docker.com/articles/dockerfile_best-practices/).

## License

[MIT License](https://github.com/AllysonSilva/docker/blob/master/LICENSE)
