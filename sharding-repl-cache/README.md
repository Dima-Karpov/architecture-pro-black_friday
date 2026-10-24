# sharding-repl-cache

Два шарда MongoDB, в каждом наборе три реплики. `configSrv` — один узел. Приложение на порту 8080 ходит в базу `somedb` через `mongos_router`. Коллекция `somedb.helloDoc`, ключ `{ "name": "hashed" }`.

Redis поднимается вместе с `docker compose up -d` и отдельно не инициализируется. Приложение берёт его по `REDIS_URL`.

Порты 27017 и 8080 общие с корневым стендом, каталогами `mongo-sharding` и `mongo-sharding-repl`. Порт 27019 общий с `mongo-sharding` и `mongo-sharding-repl`. Остановить их:

```shell
# корень репозитория
docker compose down

cd mongo-sharding
docker compose down

cd ../mongo-sharding-repl
docker compose down
```

Дальше два одинаковых сценария из каталога `sharding-repl-cache`: скрипты или `make`. Достаточно одного. Цели `make` вызывают те же скрипты. `make init` и `scripts/init-cluster.sh` идут по шагам: config, `shard1`, `shard2`, шардирование коллекции.

- `scripts/init-config.sh` — `rs.initiate` для `configSrv`, один участник, порт 27019, затем ожидание `mongos_router` на порту 27017.
- `scripts/init-shard1.sh` — `rs.initiate` набора `shard1` с хостами `shard1-1:27018`, `shard1-2:27018`, `shard1-3:27018`, ожидание primary, `sh.addShard("shard1/shard1-1:27018,shard1-2:27018,shard1-3:27018")`.
- `scripts/init-shard2.sh` — `rs.initiate` набора `shard2` с хостами `shard2-1:27018`, `shard2-2:27018`, `shard2-3:27018`, ожидание primary, `sh.addShard("shard2/shard2-1:27018,shard2-2:27018,shard2-3:27018")`.
- `scripts/enable-sharding.sh` — `sh.enableSharding("somedb")` и `sh.shardCollection("somedb.helloDoc", { "name": "hashed" })`.
- `scripts/init-cluster.sh` — четыре скрипта выше по порядку.
- `scripts/seed-hellodoc.sh` — 1000 документов `{ age: i, name: "ly" + i }` в `somedb.helloDoc` и `countDocuments()` на роутере. Роутер возвращает 1000.
- `scripts/count-documents.sh` — `countDocuments()` на роутере и по одному разу на `shard1` и `shard2`, затем `rs.status().members.length` на каждом наборе.

## Скрипты

```shell
cd sharding-repl-cache
docker compose up -d
./scripts/init-config.sh
./scripts/init-shard1.sh
./scripts/init-shard2.sh
./scripts/enable-sharding.sh
./scripts/seed-hellodoc.sh
./scripts/count-documents.sh
```

Те же четыре шага выполняет `./scripts/init-cluster.sh`.

## Make

```shell
cd sharding-repl-cache
make up
make init-config
make init-shard1
make init-shard2
make enable-sharding
make seed
make count
```

Те же четыре шага выполняет `make init`.

## Проверка

Общее число документов — строка `mongos_router` в выводе подсчёта и поле `collections.helloDoc.documents_count` в JSON `http://localhost:8080`. После сида роутер возвращает 1000.

Число документов шарда — строки `shard1` и `shard2`. У каждого шарда своё число, сумма совпадает с роутером. Хэш по `name` делит документы не поровну. На трёх репликах шарда одни и те же документы, поэтому шард считают один раз.

Число реплик — строки `shard1 replicas` и `shard2 replicas`, это `rs.status().members.length`. В каждом наборе 3.

Кеш проверяет `make test` из каталога `sharding-repl-cache`. Цель вызывает `scripts/check-cache.sh`: три раза `GET /helloDoc/users`, печать времени каждого вызова. Первый вызов с порогом не сравнивается. Второй и третий должны быть быстрее 100 мс. Скрипт также печатает `cache_enabled` и число документов `helloDoc` из `GET /`.

```shell
cd sharding-repl-cache
make test
```

Вывод в таком виде:

```text
cache_enabled: true
helloDoc: 1000
1  1052 ms
2    18 ms  < 100 ms
3    12 ms  < 100 ms
```

Те же адреса вручную:

```shell
curl -s http://localhost:8080
curl -s -o /dev/null -w '1 %{time_total}s\n' http://localhost:8080/helloDoc/users
curl -s -o /dev/null -w '2 %{time_total}s\n' http://localhost:8080/helloDoc/users
curl -s -o /dev/null -w '3 %{time_total}s\n' http://localhost:8080/helloDoc/users
```
