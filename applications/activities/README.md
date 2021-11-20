# Activities Stack

The stack is composed of [activities-web](https://github.com/niehaitao/activities-web), [activities-api](https://github.com/niehaitao/activities-api) and [activities-database](activities/init-db.sql)

|                 Application                  |                Architecture                |
| :------------------------------------------: | :----------------------------------------: |
| <img src=".data/activities.gif" width="300" /> | <img src="../.data/architecture.png" width="800" /> |

## TL;DR

To build and run the whole stack together.

```bash
git clone https://github.com/niehaitao/activities-web.git web
git clone https://github.com/niehaitao/activities-api.git api
docker-compose -f docker-compose.build.yml up --force-recreate --abort-on-container-exit --build
```

## Build & Run

To build and run the stack's applications one by one.

### Network

Create the network
```bash
docker network create act
```

### Database

```bash
docker run --rm             \
  --net   act               \
  --name  act-db-postgres   \
  -v ${PWD}/init-db.sql:/docker-entrypoint-initdb.d/init.sql \
  -e POSTGRES_USER=foo      \
  -e POSTGRES_PASSWORD=bar  \
  -e POSTGRES_DB=demo       \
  postgres

docker run -it --rm  --net act  \
  jbergknoff/postgresql-client  \
  postgresql://foo:bar@act-db-postgres:5432/demo
\l
\dt
select * from activities;
```

### API - Back End

```bash
cd api

docker build . -t act-api

docker run -p 8081:8080 --name api --network act --rm act-api:latest -e 

```

### Web - Front End

```bash
cd web

docker build . \
  -f ops/docker/app.dockerfile \
  --build-arg ENV='test' \
  --build-arg BUILD="$(date "+%F %H:%M:%S")" \
  --build-arg GIT_HASH="$(git rev-parse --short HEAD)" \
  -t act-web

docker run -p 8082:80   --name web --network act --rm act-web:latest
```
