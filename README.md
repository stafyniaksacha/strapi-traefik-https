# :lock: Strapi HTTPS with Traefik

Simple docker https configuration for strapi using traefik 

- https://github.com/containous/traefik
- https://github.com/strapi/strapi
- https://github.com/postgres/postgres (for this example)

## :rocket: Quickstart (5 steps)

1. Clone this repository (or fork it)
```sh
git clone git@github.com:stafyniaksacha/strapi-traefik-https.git

cd ./strapi-traefik-https
```

2. Create a new Strapi project in `./strapi` folder
```sh
yarn create strapi-app strapi
```
> or copy your project to `./strapi`   
> or create a symlink to your existing project to `./strapi`
> or clone a git submodule into `./strapi`
  
3. Update Strapi configuration 
```js
// ./strapi/config/database.js

module.exports = ({ env }) => ({
  defaultConnection: 'default',
  connections: {
    default: {
      connector: 'bookshelf',
      settings: {
        client: 'postgres',
        host: env('DATABASE_HOST', 'postgres'),
        port: env.int('DATABASE_PORT', 5432),
        database: env('DATABASE_NAME', 'postgresdb'),
        username: env('DATABASE_USERNAME', 'postgresuser'),
        password: env('DATABASE_PASSWORD', 'postgrespassword'),
      },
      options: {},
    },
  },
});
```

```js
// ./strapi/config/server.js

module.exports = ({ env }) => ({
  host: env('HOST', '0.0.0.0'),
  port: env.int('PORT', 1337),
  url: `https://${env('STRAPI_URL', '127.0.0.1')}/`,
  admin: {
    auth: {
      secret: env('ADMIN_JWT_SECRET'),
    },
  }
});
```

4. Create docker network
```sh
docker network create my-app-services
```

5. Start the whole stack
```sh
docker-compose up
```

## :tada: Access your services

**Strapi admin**: https://strapi.127.0.0.1.xip.io/admin  
**Traefik dashboard**: https://traefik.127.0.0.1.xip.io/ (htpasswd auth: user/pass)  

> Traefik is binded to the host network:   
> using xip.io service allow us to have a wildcard dns pointing to 127.0.0.1

> You can change `./traefik/htpasswd` file to change http auth for traefik dashboard

## :arrows_counterclockwise: Development with hotreload

1. install `node_modules` from your host
```sh
yarn
```

2. start your stack with `docker-compose.dev.yml`
```sh
CURRENT_UID=$(id -u):$(id -g) docker-compose -f docker-compose.dev.yml up
```
> `CURRENT_UID` is used to bind your host user to the docker container user  
> so files created inside the container or outside remain the same (no fs erros !)

## :triangular_flag_on_post: Environment variables

| Name  | Default | Description |
| ------------- | ------------- | ------------- |
| HOST  | `127.0.0.1.xip.io`  | main host for all services  |
| DOCKER_SERVICES_RESTART  | `no` | docker auto restart policy, can be `always` |
| POSTGRES_DB  | `postgresdb`  | postgres default database name |
| DATABASE_USERNAME  | `postgresuser`  | postgres default user name |
| DATABASE_PASSWORD  | `postgrespassword`  | postgres default user password |
| ADMIN_JWT_SECRET  | `jwtsecret`  | strapi admin jwt token (since 3.1.x) |
