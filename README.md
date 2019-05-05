<h1 align="center">
    <br>
    <a href="https://laravel.com/"><img src="https://konpa.github.io/devicon/devicon.git//icons/laravel/laravel-plain-wordmark.svg" alt="Laravel" width="100"></a>
    <a href="https://www.docker.com/"><img src="https://konpa.github.io/devicon/devicon.git/icons/docker/docker-original-wordmark.svg" alt="Docker" width="100"></a>
    <br>
        Laravel Dockerized
    <br>
</h1>

<h4 align="center">This is a personal collection of Docker tools and images(Nginx, PHP-FPM, MySQL, Redis, MongoDB, Queue, Scheduler, ELK and Traefik) for applications in <a href="https://laravel.com/" target="_blank">Laravel</a></h4>

<p align="center">
    <a href="#project-structuretree">Project Structure/Tree</a> •
    <a href="#whats-insidesoftwares-included">What's Inside/Softwares Included</a> •
    <a href="#getting-started">Getting Started</a> •
    <a href="#build-images">Build Images</a> •
    <a href="#use-makefile">Use Makefile</a>
</p>

---

## Key Features

- A single service, a single application per container. Containers responsible for running a single service
- Configurations and _variables of environment_ separated by service/container
- `Makefile` has the main commands for image build and container execution
- **MySQL** configured to only accept connections in _SSL/TLS_
- **MongoDB** configured to only accept _SSL/TLS_ connections
- Container of _Reverse Proxy_ **Nginx** with the best security standard:
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
- Easy use and configuration of **Traefik**, acting as _Api Gateway_, forwarding the requests to the specific destination according to the applied rule
- A single container responsible for handling **Queue**
- A single container responsible for handling **Scheduler**

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
│   ├── queue.env
│   └── config
│       ├── supervisord.conf
│       └── templates
│           ├── laravel-horizon.conf.tpl
│           └── laravel-worker.conf.tpl
├── scheduler
│   ├── Dockerfile
│   ├── docker-entrypoint.sh
│   ├── scheduler.env
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
│       └── cert-status.sh
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
- [PHP-FPM](https://php-fpm.org/)
- [_`Nginx`_ 1.15.x](https://nginx.org/)
- [_`MySQL`_ 5.7](https://www.mysql.com/)
- [_`MongoDB`_ 4.1](https://www.mongodb.org/)
- [ _`Redis`_ 5.x](https://redis.io/)
- [_`Elasticsearch`_ | _`Logstash`_ | _`Kibana`_ 6.6.x](https://www.elastic.co/)
- [_`Traefik`_ 1.7.x](https://traefik.io/)

### `[PHP Modules]`

[**Installed PHP extensions**](The following modules and extensions have been enabled, in addition to those you can already find in the [official PHP image](https://hub.docker.com/r/_/php/))

You are able to find all installed PHP extensions by running `php -m` inside your workspace.

`bcmath` `Core` `ctype` `curl` `date` `dom` `fileinfo` `filter` `ftp` `gd` `hash` `iconv` `intl` `json` `libxml` `mbstring` `mysqli` `mysqlnd` `openssl` `pcntl` `pcre` `PDO` `pdo_mysql` `pdo_sqlite` `Phar` `posix` `readline` `Reflection` `session` `SimpleXML` `soap` `sockets` `sodium` `SPL` `sqlite3` `standard` `tokenizer` `xml` `xmlreader` `xmlwriter` `zip` `zlib`

**Optional modules that can be installed according to the compilation/build of the _PHP base image_(`make build-php`)**

_`amqp`_ _`swoole`_ _`mongodb`_ _`sqlsrv`_ _`pdo_sqlsrv`_ _`ds`_ _`igbinary`_ _`lzf`_ _`msgpack`_ _`redis`_ _`xdebug`_

#### `[Zend Modules]`

**`Xdebug`** **`Zend OPcache`**

## Getting Started

- **The folder name of the repository must be `docker` and not `laravel-docker`(original repository name)**
- _`Docker` folder must be in the root folder of the Laravel project_
- _Copy `.dockerignore` to the project's root folder_

### Clone the project

To install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), _download_ to the root folder of the laravel project it and install following the instructions:

```bash
$ git clone https://github.com/AllysonSilva/laravel-docker docker && cd docker
```

### Download docker images

Run the `make pull` command to download the images that will be used in `docker-compose.yml` or `make` commands.

---

## Build Images

### BASE PHP

> Image (`app:base`) used to be as BASE in the first` FROM` instruction of `Dockerfile`. Used as a more generic image for any application in _PHP_. It has the responsibility to act only as a BASE image for more specific images according to the type of the framework/application _PHP_(Laravel, Symfony, CakePHP ...)

- By default [`php.ini`](/php/Dockerfile#L322) corresponds to the `php.ini-production` file of the source code in the default repository in GitHub [_PHP_](https://github.com/php/php-src/blob/php-7.3.4/php.ini-production)

    ```
    mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
    ```

- **Composer**: Installed globally in the path of the `$PATH` `/usr/local/bin/composer`

- **PHPUnit**: Installed globally in the path of the `$PATH` `/usr/local/bin/phpunit`

- `WORKDIR` in _Dockerfile_ corresponds to the value of the argument `--build-arg REMOTE_SRC=/path/to/app/`

Use the following command to build the image:

```bash
$ make build-php php_base_image_name=app:base
```

If you want to customize the image construction according to your arguments, use the `docker build` command directly:

```bash
docker build -t app:base \
    --build-arg REMOTE_SRC=/var/www/mydomain.com/ \
    --build-arg DEFAULT_USER=app \
    --build-arg DEFAULT_USER_UID=$UID \
    --build-arg DEFAULT_USER_GID=$(id -g) \
- < ./php/Dockerfile
```

Use the `--build-arg` option to customize/install specific _PHP_ extensions according to the arguments in the` Dockerfile` of the image.

_The values of the arguments below represent default arguments that are used when the `docker build` command is executed without any custom arguments._

```bash
docker build -t app:base \
    --build-arg REMOTE_SRC=/var/www/mydomain.com/ \
    --build-arg DEFAULT_USER=app \
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

See Docker's [documentation]([https://docs.docker.com/engine/reference/builder/#arg](https://docs.docker.com/engine/reference/builder/#arg)) the `ARG` statement in `Dockerfile`

### Laravel APP/PHP-FPM

> - The construction/configuration of this image is used for applications in _Laravel_
> - Extend the image [BASE PHP](#base-php) by means of instruction `FROM $PHP_BASE_IMAGE` in your `Dockerfile`
> - Used [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/) in your `Dockerfile`
>     * In the first stage use the image of [Composer](https://hub.docker.com/_/composer) to manage the system dependencies (To speed up the download process [hirak/prestissimo](https://github.com/hirak/prestissimo) is used)
>     * In the second stage use the [Node.js](https://hub.docker.com/_/node) image to build the dependencies of the Front-end using the yarn manager
>     * In the third and final stage, the results of the previous stages are used to copy the necessary files to the project image

#### How To Use

- `$PROJECT_ENVIRONMENT` Can be set to two values: ([`production`](/app/docker-entrypoint.sh#L170) e [`development`](/app/docker-entrypoint.sh#L182)). Its purpose is to define the flow in the ENTRYPOINT (`/entrypoint.sh`)
    * Can be defined at the moment of image creation through argument: `--build-arg PROJECT_ENVIRONMENT=production||development`)
    * Can be updated at the time of executing the container through environment variables: `--env "PROJECT_ENVIRONMENT=production||development"`

- `$APP_ENV`: Defini o ambiente em que a aplicação em _LARAVEL_ estará configurada. Essa variável pode ser definido no momento de build da imagem por meio de argumentos(`--build-arg APP_ENV=production||development`), ou caso a imagem já esteja criada, então, poderá ser substituída por meio do parâmetro `--env "APP_ENV=production||development"` ao executar o container

- `$REMOTE_SRC` corresponde ao valor da concatenção das variáveis `${APP_PATH_PREFIX}/${DOMAIN_APP}/`, caso queira alterar esse valor então, configurar no processo de build o argumento `APP_PATH_PREFIX`.

- `php.ini`: Configurado no momento de build da imagem e é definido de acordo com o valor passado para `$PROJECT_ENVIRONMENT`. Caso o valor de `$PROJECT_ENVIRONMENT` seja `development` então `php.ini` vai corresponder ao arquivos [`php.ini-development.ini`](/app/config/php.ini-development.ini), caso o valor de `$PROJECT_ENVIRONMENT` seja `production` então o conteúdo de `php.ini` vai corresponde ao arquivo [`php.ini-production.ini`](/app/config/php.ini-production.ini)
    * Pode ser substituído por meio de volume apontando para o caminho do arquivo `php.ini`: `/usr/local/etc/php/php.ini`

- `php-fpm.conf`: Configuração GLOBAL do PHP-FPM que se encontra `/usr/local/etc/php-fpm.conf`

- `www.conf`: Configuração específica para o pool `[www]` que se encontra `/usr/local/etc/php-fpm.d/www.conf`

- `WORKDIR` corresponde ao caminho `/var/www/${DOMAIN_APP}/`(pasta root da aplicação), onde o valor da variável `${DOMAIN_APP}` é igual ao valor do argumento `domain_app` no comando `make build-app ...`

- Por padrão o caminho root da aplicação corresponde a `/var/www/${DOMAIN_APP}` onde `${DOMAIN_APP}` corresponde ao valor passado na opção `domain_app` no comando `make build-app ...`

#### Configure/Build

```bash
$ make build-app app_env__project_environment=production||development app_image_name=app:3.0 domain_app=mydomain.com
```

#### Run the application(`docker run`)

> Edit the [ENV variables](/app/app.env) to match the project settings. You can edit/add the environment variables in the `docker-compose.yml` file itself, which has priority over the same variable defined else where (Shell environment variables, Environment file, `Dockerfile`).

> Para executar o serviço/container por meio do comando `run` do _Docker_ utilize/personalize o seguinte script:

**Note:** You must specify a unique `APP_KEY` including `base64:` prefix generated by `php artisan key:generate` within the container.

```bash
docker run \
        --rm \
        -p 9001:9001 \
        -p 8081:8080 \
            -v $(pwd)/../:/var/www/mydomain.com/ \
            -v $(pwd)/app/docker-entrypoint.sh:/entrypoint.sh:ro \
    --env "APP_KEY=SomeRandomString" \
    --env "PROJECT_ENVIRONMENT=development" \
    --env "APP_ENV=development" \
    --env "APP_DEBUG=true" \
    --env "REMOTE_SRC=/var/www/mydomain.com/" \
        --workdir /var/www/mydomain.com/ \
        --user 1000:1000 \
        --network=app_default \
        --name=php-fpm \
        --hostname=php-fpm \
        -t app:3.0
```

Para executar um servidor com `artisan serve` acesse primeiro o container:

```bash
docker exec -ti php-fpm bash
```

Dentro do container, execute o seguinte comando para rodar o servidor embutido do PHP com `artisan serve`:

```bash
php artisan serve --port=8080 --host=0.0.0.0
```

---

- A opção `--workdir` do comando `docker run` deve ter o mesmo valor que A variável `$REMOTE_SRC`

- O destino/target da configuração do volume `-v $(pwd)/../:/var/www/mydomain.com/` deve corresponder ao mesmo valor da variável `$REMOTE_SRC`, que deve corresponder ao mesmo valor da opção `--workdir` no `docker run` ou instrução `WORKDIR` no _Dockerfile_

### Nginx Webserver

> Imagem será utilizada como _PROXY REVERSO_.

- Configuração `ssl_best_practices.conf` e `ssl_common_certificates.conf` para permitir apenas conexões sobre o protocolo **HTTPS**
- _Snippet_ `security_http_headers.conf` para melhores práticas de segurança para configurações **HTTP HEADERS**
- _Snippet_ `deny_ips.conf` para bloquear ataques pela força bruta ou _IPs_ na lista negra globalmente na internet
- _Snippet_ `real_ip.conf` para configuração de _PROXY_. Configurando o _IP_ real do cliente
- Controle, limitação de conexões simultâneas, para bloquear ataques ao _HOST_ por meio de instruções `limit_conn` e `limit_req` do _NGINX_
- Utilize o [Let's Encrypt](https://letsencrypt.org/) para gerar certificados SSL e realizar a configuração SSL do NGINX para utilizar o protocolo **HTTPS**
    * Pasta `nginx/certs/` deve conter os arquivos criados pelo _Let's Encrypt_. Deve conter os arquivos: `cert.pem`, `chain.pem`, `dhparam4096.pem`, `fullchain.pem`, `privkey.pem`
- Para gerar os certificados utilize ou personalize o script: `make gen-certs domain_app=mydomain.com`
- Existe 4 configurações de _virtual server_, que são: `api.mydomain.com`, `admin.mydomain.com`, `mydomain.com`, `webmail.mydomain.com`. Todas dentro da pasta `nginx/servers/`

Use the following command to build the image:

```bash
$ make build-nginx nginx_image_name=webserver:3.0 domain_app=mydomain.com
```

- `nginx_image_name`: Parâmetro utilizado para TAG da imagem

- `domain_app`: Domínio que será utilizado no caminho `${APP_PATH_PREFIX}/${DOMAIN_APP}/`
    * `${APP_PATH_PREFIX}`: Prefixo do caminho da aplicação que corresponde ao mesmo valor na imagem [Laravel APP/PHP-FPM](#laravel-appphp-fpm) e seu valor padrão é `/var/www`
    * ${DOMAIN_APP}: Valor do parâmetro `domain_app` utilizado no comando `make build-nginx`
    * _O mesmo valor para o parâmetro `domain_app` dessa mesma imagem, deve corresponder ao mesmo valor usado no mesmo parâmetro `domain_app` na compilação da imagem [Laravel APP/PHP-FPM](#laravel-appphp-fpm), para não haver conflito na comunicação dos serviços do proxy reverso(NGINX) com o serviço CGI(PHP-FPM)_

Para executar o serviço por meio do comando `run` do _Docker_ utilize/personalize o seguinte script:

```bash
docker run \
        --rm \
        -p 80:80 \
        -p 443:443 \
            -v $(pwd)/../:/var/www/mydomain.com/ \
            -v $(pwd)/nginx/docker-entrypoint.sh:/entrypoint.sh:ro \
            -v $(pwd)/nginx/config/nginx.conf:/etc/nginx/nginx.conf:ro \
            -v $(pwd)/nginx/config/servers/:/etc/nginx/servers \
    --env "DOMAIN_APP=mydomain.com" \
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
$ make build-queue app_queue_image_name=app:queue app_image_name=app:3.0
```

**Run**

Para executar o container queue use o comando `run` do docker:

```bash
docker run \
        --rm \
        -p 8081:8080 \
        --workdir "/var/www/mydomain.com/" \
            -v $(pwd)/../:/var/www/mydomain.com/ \
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
$ make build-scheduler app_scheduler_image_name=app:scheduler app_image_name=app:3.0
```

## ELK

Conjunto de serviços que não estão no `docker-compose.yml` principal na raiz do projeto, mais se encontra na pasta `elastic` tendo suas próprias configurações, seu próprio `docker-compose.yml` por conta de ter um nível de complexidade mais elevada que os demais serviços(MySQL, PHP, Redis ...). Possue os seguintes serviços: `elasticsearch`, `kibana`, `logstash`, `metricbeat`, `filebeat` e `packetbeat`.

#### Starting the stack

First we need to:

1. set default password
2. create keystores to store passwords
3. install dashboards, index patterns, etc.. for beats and apm

This is accomplished using the docker-compose-setup.yml file:
```bash
cd elastic && docker-compose -f docker-compose-setup.yml up && docker-compose up
```

Please take note after the setup completes it will output the password
that is used for the `elastic` login.

Now we can launch the stack with `docker-compose up -d` to create a demonstration Elastic Stack with
Elasticsearch, Kibana, Logstash, Metricbeat, Filebeat and Packetbeat.

Point a browser at [`http://localhost:56011`](http://localhost:56011) to see the results.
> *NOTE*: Elasticsearch is now setup with self-signed certs.

Log in with `elastic` and what ever your auto generated elastic password is from the
setup.

#### [Change users password](https://www.elastic.co/guide/en/elastic-stack-overview/master/built-in-users.html#set-built-in-user-passwords)

Login in container:

```bash
docker exec -ti elasticsearch bash
```

Change users password:

```bash
bin/elasticsearch-setup-passwords interactive
```

or

```bash
/usr/local/bin/setup-users.sh
```

#### Solução de problemas

**Exclusão do volume do serviço `elasticsearch`**

Caso o volume principal dos dados do serviço `elasticsearch` venha à ser excluído, deve-se executar o script `/usr/local/bin/setup-users.sh` para que os usuários dos serviços que outrora foram configurados no SETUP inicial(Kibana, Logstash ...), possam ser configurados novamente.

_Obs: Antes de executar o script acima, é preciso descomentar a variável de ambiente `ELASTIC_PASSWORD: ${ELASTIC_PASSWORD}` do serviço `elasticsearch`, para que a senha possa ser configurada nos usuários dos serviços que estão com problemas de conexão._
_A senha em `ELASTIC_PASSWORD` deve ser a mesma configurada no SETUP inicial, caso contrário, ainda continuará acontecendo problemas nas conexões entre serviço._

## Use Makefile

When developing, you can use [Makefile](https://en.wikipedia.org/wiki/Make_(software)) for doing the following operations:

| Name                | Description                                               |
|---------------------|-----------------------------------------------------------|
| pull                | Download images                                           |
| build               | Build project images                                      |
| build-nginx         | Build the NGINX image to act as a reverse proxy           |
| in-nginx            | Access the NGINX container                                |
| build-php           | Build the base image of projects in PHP                   |
| build-app           | Build the image with settings for Laravel/PHP projects    |
| run-app             | Create a container for the application with docker run    |
| build-queue         | Build the image to act as queue management                |
| build-scheduler     | Build the image to act as scheduler management            |
| app-code-phpcs      | Check the APP with PHP Code Sniffer (`PSR2`)              |
| app-code-phpmd      | Analyse the APP with PHP Mess Detector                    |
| docker-clean        | Remove docker images with filter `<none>`                 |
| run-traefik         | Create a container for the traefik with docker run        |
| docker-stop         | Stop and execute $> make docker-clean                     |
| composer-up         | Update PHP dependencies with composer                     |
| gen-certs           | Generate SSL certificates                                 |
| get-certs           | Retrieves certificate expiration dates                    |
| mysql-dump          | Create backup of all databases                            |
| mysql-restore       | Restore backup of all databases                           |

## Assumptions

- You have Docker and Docker-Compose installed (Docker for Mac, Docker for Windows, get.docker.com and manual Compose installed for Linux).
- You want to use Docker for local development (i.e. never need to install php or npm on host) and have dev and prod Docker images be as close as possible.
- You don't want to lose fidelity in your dev workflow. You want a easy environment setup, using local editors, debug/inspect, local code repo, while web server runs in a container.
- You use `docker-compose` for local development only (docker-compose was never intended to be a production deployment tool anyway).
- The `docker-compose.yml` is not meant for `docker stack deploy` in Docker Swarm, it's meant for happy local development.

## Helpers commands / Use Docker commands

### Install PHP Modules

```bash
docker exec -t -i app /bin/bash
# After
$ /usr/local/bin/docker-php-ext-configure xdebug
$ /usr/local/bin/docker-php-ext-install xdebug
```

### Installing package with composer

```bash
docker run --rm -v $(pwd):/app composer require laravel/horizon
```

### Updating PHP dependencies with composer

```bash
docker run --rm -v $(pwd):/app composer update
```

### Testing PHP application with PHPUnit

```bash
docker-compose exec -T app ./vendor/bin/phpunit --colors=always --configuration ./app
```

### Fixing standard code with [PSR2](https://www.php-fig.org/psr/psr-2/)

```bash
docker-compose exec -T app ./vendor/bin/phpcbf -v --standard=PSR2 ./app
```

### Analyzing source code with [PHP Mess Detector](https://phpmd.org/)

```bash
docker-compose exec -T app ./vendor/bin/phpmd ./app text cleancode,codesize,controversial,design,naming,unusedcode
```

## Contributing

If you find an issue, or have a special wish not yet fulfilled, please [open an issue on GitHub](https://github.com/AllysonSilva/docker/issues) providing as many details as you can (the more you are specific about your problem, the easier it is for us to fix it).

Pull requests are welcome, too 😁! Also, it would be nice if you could stick to the [best practices for writing Dockerfiles](https://docs.docker.com/articles/dockerfile_best-practices/).

## License

[MIT License](https://github.com/AllysonSilva/docker/blob/master/LICENSE)
