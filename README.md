<h1 align="center">
    <br>
    <a href="https://laravel.com/"><img src="https://konpa.github.io/devicon/devicon.git//icons/laravel/laravel-plain-wordmark.svg" alt="Laravel" width="100"></a>
    <a href="https://www.docker.com/"><img src="https://konpa.github.io/devicon/devicon.git/icons/docker/docker-original-wordmark.svg" alt="Docker" width="100"></a>
    <br>
        Laravel Dockerized
    <br>
</h1>

<h4 align="center">This is a personal collection of Docker tools and images(Nginx, PHP-FPM, MySQL, Redis, MongoDB, Queue, Scheduler, ELK and Traefik) for applications in <a href="https://laravel.com/" target="_blank">Laravel</a>.</h4>

<p align="center">
    <a href="#key-features">Key Features</a> •
    <a href="#how-to-use">How To Use</a> •
    <a href="#related">Related</a> •
    <a href="#license">License</a>
</p>

---

## Key Features

- Um único serviço, uma única aplicação por container
    * Containers responsáveis por executar um único serviço
- Configurações e _variáveis de ambiente_ separados por serviço/container
- `Makefile` possui os principais comandos para build das imagens e execução dos containers
- **MySQL** configurado para aceitar apenas conexões em _SSL/TLS_
- **MongoDB** configuradado para aceitar apenas conexões _SSL/TLS_
- Container/serviço do _Reverse Proxy_ **Nginx** com os melhores padrão de segurança:
    * _Force HTTPS_
    * _TLS best practices_
    * _Security HTTP headers_
    * _Controlling buffer overflow attacks_
    * _Control simultaneous connections_
    * _Allow access to our domain only_
    * _Limit available methods_
    * _Block referral spam_
    * _Stop image Hotlinking_
    * _Block ips attack by brute force_
- Fácil uso e configuração do **Traefik**, atuando como _Api Gateway_, encaminhando as solicitações/pedidos para o destino específico de acordo com a regra aplicada
- Container/serviço separado do container da aplicação para manipulação de **Queue**
- Container/serviço separado do container da aplicação para manipulação de **Scheduler**

## Project Structure/Tree

```
.
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

## Install/Requirements Docker

- [Ubuntu](https://docs.docker.com/engine/installation/linux/ubuntu/)
- [Windows](https://docs.docker.com/docker-for-windows/install/)
- [MacOS](https://docs.docker.com/docker-for-mac/install/)

> Download and install [Docker Engine](https://docs.docker.com/engine/installation/) (**>= 18.09**) for your platform and you also have to install [Docker compose](https://docs.docker.com/compose/install/) (**>= 1.24.0**).

## What's Inside/Softwares Included:

- _`PHP`_ 7.3.x
- [_`Nginx`_ 1.15.x](http://nginx.org/)
- [_`MySQL`_ 5.7](http://www.mysql.com/)
- [_`MongoDB`_ 4.1](http://www.mongodb.org/)
- [PHP-FPM](http://php-fpm.org/)
- [ _`Redis`_ 5.x](http://redis.io/)
- [_`Elasticsearch`_ | _`Logstash`_ | _`Kibana`_ 6.6.x](http://www.elasticsearch.org/)
- [_`Traefik`_ 1.7.x](https://traefik.io/)

### `[PHP Modules]`

[**Installed PHP extensions**] (The following modules and extensions have been enabled, in addition to those you can already find in the [official PHP image](https://hub.docker.com/r/_/php/))

You are able to find all installed PHP extensions by running `php -m` inside your workspace.

`bcmath` `Core` `ctype` `curl` `date` `dom` `fileinfo` `filter` `ftp` `gd` `hash` `iconv` `intl` `json` `libxml` `mbstring` `mysqli` `mysqlnd` `openssl` `pcntl` `pcre` `PDO` `pdo_mysql` `pdo_sqlite` `Phar` `posix` `readline` `Reflection` `session` `SimpleXML` `soap` `sockets` `sodium` `SPL` `sqlite3` `standard` `tokenizer` `xml` `xmlreader` `xmlwriter` `zip` `zlib`

**Optional modules that can be installed according to the compilation/_build_ of the _PHP base image_(`make build-php`)**

_`ds`_ _`igbinary`_ _`lzf`_ _`msgpack`_ _`redis`_ _`xdebug`_

#### `[Zend Modules]`

**`Xdebug`** **`Zend OPcache`**

## Getting Started

- **The folder name of the repository must be `docker` and not `laravel-docker` (original repository name).**
- _Pasta `docker` deve estar na pasta root do projeto Laravel._

### Clone the project

To install [Git](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git), _download_ to the root folder of the laravel project it and install following the instructions:

```bash
git clone https://github.com/AllysonSilva/laravel-docker docker && cd docker
```

### Download docker images

Run the `make pull` command to download the images that will be used in `docker-compose.yml`.

## Build Images

### BASE PHP

> Imagem(`app:base`) utilizada para ser usada como BASE na primeira instrução `FROM` do `Dockerfile`, ser utilizada como uma imagem mais genérica para qualquer aplicativo em _PHP_. Possui responsabilidade de atuar apenas como uma imagem BASE para images mais específicas de acordo com o tipo do framework/aplicação _PHP_(Laravel, Symfony, CakePHP ...)

Use the following command to build the image:

```bash
$ make build-php php_base_image_name=app:base
```

Caso queira personalizar a construção da imagem de acordo com seus argumentos, utilize diretamente o comando `docker build`:

```bash
$ docker build -t app:base \
    --build-arg DEFAULT_USER_UID=$UID \
    --build-arg DEFAULT_USER_GID=$(id -g) \
- < ./php/Dockerfile
```

Utilize a opção `--build-arg` para personalizar/instalar uma extensão específica para a imagem.

_Os valores dos argumentos abaixo representam valores padrão que serão usados quando o comando `docker build` for executado._

```bash
docker build -t app:base \
    --build-arg DEFAULT_USER_UID=$UID \
    --build-arg DEFAULT_USER_GID=$(id -g) \
    --build-arg INSTALL_PHP_AMQP=false \
    --build-arg INSTALL_PHP_SWOOLE=false \
    --build-arg INSTALL_PHP_MONGO=false \
    --build-arg INSTALL_PHP_SQLSRV=false \
    --build-arg INSTALL_PHP_IGBINARY=true \
    --build-arg INSTALL_PHP_LZF=true \
    --build-arg INSTALL_PHP_MESSAGEPACK=true \
    --build-arg INSTALL_PHP_REDIS=true \
    --build-arg INSTALL_PHP_DS=true \
    --build-arg INSTALL_PHP_XDEBUG=true \
- < ./php/Dockerfile
```

Veja a [documentação]([https://docs.docker.com/engine/reference/builder/#arg](https://docs.docker.com/engine/reference/builder/#arg)) do Docker sobre a instrução `ARG`  do `Dockerfile`.

### Laravel APP/PHP-FPM

> - A construção dessa imagem é utilizada para aplicações em _Laravel_
> - Extende a imagem `app:base`
> - Utiliza-se [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/) em seu `Dockerfile`
>     * In the first stage use the image of [Composer](https://hub.docker.com/_/composer) to manage the system dependencies (To speed up the download process [hirak/prestissimo](https://github.com/hirak/prestissimo) is used)
>     * In the second stage use the [Node.js](https://hub.docker.com/_/node) image to build the dependencies of the Front-end using the yarn manager
>     * In the third and final stage, the results of the previous stages are used to copy the necessary files to the project image

#### How To Use

- `$PROJECT_ENVIRONMENT` Pode ser definido para dois valores: ([`production`](/app/docker-entrypoint.sh#L111) e [`development`](/app/docker-entrypoint.sh#L123)). Tem como objetivo definir o fluxo no arquivo de ENTRYPOINT(`/entrypoint.sh`)
    * Pode ser definido no momento de criação da imagem por meio de argumento: `--build-arg PROJECT_ENVIRONMENT=production||development`)
    * Pode ser atualizado no momento de executar o container por meio de variáveis de ambiente: `--env "PROJECT_ENVIRONMENT=production||development"`

- `$APP_ENV`: Defini o ambiente em que a aplicação em _LARAVEL_ estará configurada. Essa variável pode ser definido no momento de build da imagem por meio de argumentos(`--build-arg APP_ENV=production||development`), ou caso a imagem já esteja criada, então, poderá ser substituída por meio do parâmetro `--env "APP_ENV=production||development"` ao executar o container.

- `php.ini`: Configurado no momento de build da imagem e é definido de acordo com o valor passado para `$PROJECT_ENVIRONMENT`. Caso o valor de `$PROJECT_ENVIRONMENT` seja `development` então `php.ini` vai corresponder ao arquivos `php.ini-development.ini`, caso o valor de `$PROJECT_ENVIRONMENT` seja `production` então o conteúdo de `php.ini` vai corresponde ao arquivo `php.ini-production.ini`.
    * Pode ser substituído por meio de volume apontando para o caminho do arquivo `php.ini` na imagem: `/usr/local/etc/php/php.ini`

- `php-fpm.conf`: Configuração GLOBAL do PHP-FPM que se encontra `/usr/local/etc/php-fpm.conf`.

- `www.conf`: Configuração específica para o pool `[www]` que se encontra `/usr/local/etc/php-fpm.d/www.conf`.

#### Configure/Build

```bash
$ make build-app app_env__project_environment=production||development app_image_name=app:3.0
```

#### Run the application(`docker run`)

> Para executar o serviço/container por meio do comando `run` do _Docker_ utilize/personalize o seguinte script:

**Note:** You must specify a unique `APP_KEY` including `base64:` prefix generated by `php artisan key:generate` within the container.

```bash
docker run \
        --rm \
        -p 9001:9001 \
        -p 8081:8080 \
            -v $(pwd)/../:/var/www/example.com/ \
            -v $(pwd)/app/docker-entrypoint.sh:/entrypoint.sh:ro \
    --env "APP_KEY=SomeRandomString" \
    --env "PROJECT_ENVIRONMENT=development" \
    --env "APP_ENV=development" \
    --env "REMOTE_SRC=/var/www/example.com/" \
        --workdir /var/www/example.com/ \
        --user 1000:1000 \
        --network=app_default \
        --name=php-fpm \
        --hostname=php-fpm \
        -t app:3.0
```

### Nginx Webserver

> Imagem será utilizada como _PROXY REVERSO_.

```bash
make build-nginx nginx_image_name=webserver:3.0
```

Para executar o serviço por meio do comando `run` do _Docker_ utilize/personalize o seguinte script:

```bash
docker run \
        --rm \
        -p 80:80 \
        -p 443:443 \
            -v $(pwd)/../:/var/www/example.com/ \
            -v $(pwd)/nginx/docker-entrypoint.sh:/entrypoint.sh \
            -v $(pwd)/nginx/config/nginx.conf:/etc/nginx/nginx.conf \
            -v $(pwd)/nginx/config/servers/:/etc/nginx/servers \
    --env "DOMAIN_APP=example.com" \
        --network=app_default \
        --name=webserver \
        --hostname=webserver \
        -t webserver:3.0
```

### MySQL

> Container/serviço será utilizado para gerenciar o banco de dados MySQL.

- As configurações do _MySQL_(my.cnf) estão definidas para usar [SSL](https://dev.mysql.com/doc/refman/5.7/en/mysql-ssl-rsa-setup.html), então, as seguintes instruções são para criar os arquivos de configuração SSL:

```bash
mysql_ssl_rsa_setup --datadir=$(PWD)/mysql/ssl
# Verify a certificate chain
openssl verify -CAfile $(PWD)/mysql/ssl/ca.pem $(PWD)/mysql/ssl/server-cert.pem $(PWD)/mysql/ssl/client-cert.pem
```

- To see the contents of an SSL certificate (for example, to check the range of dates over which it is valid), invoke openssl directly:

```bash
openssl x509 -text -in ca.pem
openssl x509 -text -in server-cert.pem
openssl x509 -text -in client-cert.pem
```

- It is also possible to check SSL certificate expiration information using this SQL statement:

```bash
mysql> SHOW STATUS LIKE 'Ssl_server_not%';
```

- Para saber se o SSL está ativado no MySQL, utilize um dos comandos abaixo após se logar no Client-MySQL.

```bash
mysql> SHOW SESSION STATUS LIKE 'Ssl_version';
mysql> show variables like '%ssl%';
mysql> SHOW GLOBAL VARIABLES LIKE '%ssl%';
```

- Para executar o serviço/container utilizando o comando `run` do _Docker_, utilize/personalize o seguinte script:

```bash
docker run \
        --rm \
        -p 29011:3306 \
            -v $(pwd)/./mysql/ssl/ca-key.pem:/etc/mysql-ssl/ca-key.pem:ro \
            -v $(pwd)/./mysql/ssl/ca.pem:/etc/mysql-ssl/ca.pem:ro \
            -v $(pwd)/./mysql/ssl/client-cert.pem:/etc/mysql-ssl/client-cert.pem:ro \
            -v $(pwd)/./mysql/ssl/client-key.pem:/etc/mysql-ssl/client-key.pem:ro \
            -v $(pwd)/./mysql/ssl/private_key.pem:/etc/mysql-ssl/private_key.pem:ro \
            -v $(pwd)/./mysql/ssl/public_key.pem:/etc/mysql-ssl/public_key.pem:ro \
            -v $(pwd)/./mysql/ssl/server-cert.pem:/etc/mysql-ssl/server-cert.pem:ro \
            -v $(pwd)/./mysql/ssl/server-key.pem:/etc/mysql-ssl/server-key.pem:ro \
            -v $(pwd)/./mysql/my.cnf:/etc/mysql/conf.d/my.cnf:ro \
    --env "MYSQL_DATABASE=app" \
    --env "MYSQL_USER=app" \
    --env "MYSQL_ROOT_PASSWORD=root" \
    --env "MYSQL_PASSWORD=secret" \
        --network=app_default \
        --name=database \
        --hostname=database \
        -t mysql:5.7
```

- Para acessar o banco de dados via Terminal/Console utilize:

```bash
mysql -h 127.0.0.1 -P 29011 -uapp -psecret \
        --ssl-ca=mysql/ssl/ca.pem \
        --ssl-cert=mysql/ssl/client-cert.pem \
        --ssl-key=mysql/ssl/client-key.pem
```

### Redis

> Container/serviço será utilizado para gerenciar o banco de dados Redis. Utilizado para Gerenciamento de _Queue_, _Sessions_, _Cache_ e muitas outras coisas da aplicação que necessitam de velocidade em obter/gravar informações.

- Utilize o seguinte comando para executar o container/serviço do Redis via opção `run` do _Docker_.

```bash
docker run \
        --rm \
        -p 63781:6379 \
            -v $(pwd)/./redis/redis.conf:/usr/local/etc/redis/redis.conf:ro \
        --network=app_default \
        --name=redis \
        --hostname=redis \
        -t redis:5-alpine redis-server /usr/local/etc/redis/redis.conf --appendonly yes
```

- Para acessar o banco de dados _Redis_:

```bash
redis-cli -h 127.0.0.1 -p 63781 -a 'HQD3{9S-u(qnxK@'
```

### MongoDB

> Container/serviço responsável por gerenciar banco de dados MongoDB.

- Para executar o container por meio da opção `run` do Docker, utilize o seguinte script:

```bash
docker run \
        --rm \
        -p 29019:27017 \
            -v $(pwd)/./mongodb/mongod.conf:/etc/mongo/mongod.conf:ro \
            -v $(pwd)/./mongodb/mongo-init.js:/docker-entrypoint-initdb.d/mongo-init.js:ro \
            -v $(pwd)/./mongodb/ssl/rootCA.pem:/etc/ssl/ca.pem:ro \
            -v $(pwd)/./mongodb/ssl/mongodb.pem:/etc/ssl/mongodb.pem:ro \
    --env "MONGO_INITDB_ROOT_USERNAME=root" \
    --env "MONGO_INITDB_ROOT_PASSWORD=secret" \
        --network=app_default \
        --name=mongodb \
        --hostname=mongodb \
        -t mongo:4.1 mongod --bind_ip_all --config /etc/mongo/mongod.conf
```

[Secure your MongoDB connections - SSL/TLS](https://medium.com/@rajanmaharjan/secure-your-mongodb-connections-ssl-tls-92e2addb3c89)

- Para acessar o banco de dados do container do MongoDB:

```bash
mongo --ssl \
      --sslCAFile /etc/ssl/ca.pem --sslPEMKeyFile /etc/ssl/mongodb.pem \
      --host 127.0.0.1 --port 29019 -u "root" -p "secret" --authenticationDatabase admin
```

### Queue

> Container/serviço responsável pelo gerenciamento de _Queue_ na aplicação.

Container com **PID 1** executado pelo **supervisor** para gerenciar processos. Pode ter duas configurações:

-   Muitos processos executando `artisan queue:work` do Laravel para gerenciamento de queue.
-   Utilizado para debug e desenvolvimento o _Horizon_ é um painel de gerenciamento de queue robusto e simplista. Um único processo em uma configuração do _supervisor_ executando o comando `artisan horizon`.

**Variáveis de ambiente obrigatórias**

- `LARAVEL_QUEUE_MANAGER`: Essa variável de ambiente defini o contexto do container, podendo ter os seguintes valores:
    *  **worker**:  Configura o _supervisor_ para executar muitos processos no comando do Laravel `artisan queue:work`
    * **horizon**: Configura o _supervisor_ para executar um único processo do Horizon `artisan horizon`

- `APP_KEY`: If the application key is not set, your user sessions and other encrypted data will not be secure!
- `APP_ENV`: Configura o ambiente em que a aplicação vai executar.
- `PROJECT_ENVIRONMENT`: Pode ser definido para dois valores: `production` e `development`]. Tem como objetivo definir o fluxo no arquivo de ENTRYPOINT(`/start.sh`)

**Build**

Use o seguinte script para build a imagem:

```bash
make build-queue app_queue_image_name=app:queue app_image_name=app:3.0
```

**Run**

Para executar o container queue use o comando `run` do docker:

```bash
docker run \
        --rm \
        -p 8081:8080 \
        --workdir "/var/www/app/" \
            -v $(pwd)/../:/var/www/app/ \
            -v $(pwd)/queue/docker-entrypoint.sh:/start.sh \
            -v $(pwd)/app/config/php.ini-production.ini:/usr/local/etc/php/php.ini:ro \
    --env "APP_ENV=production" \
    --env "APP_KEY=SomeRandomString" \
    --env "CACHE_DRIVER=redis" \
    --env "QUEUE_CONNECTION=redis" \
    --env "REDIS_PASSWORD=HQD3{9S-u(qnxK@" \
    --env "REDIS_HOST=redis" \
    --env "REDIS_PORT=6379" \
    --env "REDIS_QUEUE=app_default" \
    --env "DB_HOST=database" \
    --env "DB_DATABASE=app" \
    --env "DB_USERNAME=app" \
    --env "DB_PASSWORD=secret" \
    --env "DB_PORT=3306" \
    --env "PROJECT_ENVIRONMENT=horizon" \
        --name=app-queue \
        --network=app_default \
        -t app:queue
```

### Scheduler

> Container/serviço responsável pelo gerenciamento de _Scheduler_ na aplicação.

- Container com **PID 1** executado pelo **cron**
- Variáveis de ambiente `APP_KEY` e `APP_ENV` são obrigatórias quando executar o container
- Variáveis de ambiente disponíveis para processos do PHP graças ao script `printenv > /etc/environment` no entrypoint do container
- Container executado como `root` como requerimento do serviço do _cron_

_Executado um único comando de agendamento:_

```bash
* * * * * {{USER}} /usr/local/bin/php {{REMOTE_SRC}}artisan schedule:run --no-ansi >> /usr/local/var/log/php/cron-laravel-scheduler.log 2>&1
```

**Build**

```bash
make build-scheduler app_scheduler_image_name=app:scheduler app_image_name=app:3.0
```
