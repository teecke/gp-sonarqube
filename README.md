# Generic Platform - Sonar Service

## Overview

Docker image and docker-compose sample configuration to bring up a Sonar Service to the Teecke [Docker Generic Platform (GP)](https://github.com/teecke/docker-generic-platform).

## Configuration

The service is formed by two containers:

- **sonarqube**: based on [SonarQube](https://hub.docker.com/_/sonarqube) docker image.
- **sonardb**: based on [PostgreSQL](https://hub.docker.com/_/postgres) databasse docker image.

## Operation

1. Configure the following elements on the docker host as it figures on the [SonarQube](https://hub.docker.com/_/sonarqube) Docker hub documentation.

    ```console
    sysctl -w vm.max_map_count=262144
    sysctl -w fs.file-max=65536
    ulimit -n 65536
    ulimit -u 4096
    ```

2. Create the `.env` file based on the `.env.dist` template and configure the Postgres password:

    ```console
    $ cp .env.dist .env
    $ cat .env
    POSTGRES_USER=sonar
    POSTGRES_PASSWORD=[PUT_YOUR_POSTGRES_PASSWORD_HERE]
    $ vim .env

    [...]

    $ cat .env
    POSTGRES_USER=sonar
    POSTGRES_PASSWORD=sonar
    ```

3. Use the `docker-compose.yml.sample` file as your docker-compose configuration file.

4. Create a docker network called "platform_services" before start the services with `docker network create platform_services`.

5. Install assets

    ```console
    $ devcontrol assets-install
    Generic Platform - SonarQube Service (c) Teecke 2020

    - Creating 'data' directory...[OK]
    - Setting 'data' permissions...[OK]
    - Creating 'data/conf' directory...[OK]
    - Setting 'data/conf' permissions...[OK]
    - Creating 'data/data' directory...[OK]
    - Setting 'data/data' permissions...[OK]
    - Creating 'data/extensions' directory...[OK]
    - Setting 'data/extensions' permissions...[OK]
    - Creating 'data/bundled-plugins' directory...[OK]
    - Setting 'data/bundled-plugins' permissions...[OK]
    ```

6. Start with `docker-compose up -d`.

7. Open the url <http://localhost:9000> in a browser to access to the SonarQube gui and complete the configuration.

8. Manage backups of your files:

   1. Make a backup executing `docker-compose exec sonarqube backup`.
   2. Find the current backup within the `/var/backups/gp/sonarqube/` of the container.
   3. Extract the current backup executing `docker cp $(docker-compose ps -q sonarqube):/var/backups/gp gp`.

9. Stop the platform with `docker-compose stop`.

There are two volumes created with the database. All data and configuration are on those volumes, so never delete it.

```console
$ docker volume ls|grep sonarqube
local               gp-sonarqube_postgresql
local               gp-sonarqube_postgresql_data
```

You can use this docker piece with the [Docker Generic Platform](https://github.com/teecke/docker-generic-platform) project.

## Known issues

None known
