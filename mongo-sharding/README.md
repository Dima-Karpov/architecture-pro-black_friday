# mongo-sharding

Два шарда MongoDB, сервер конфигурации и роутер. Приложение на порту 8080 ходит в базу `somedb` через `mongos_router`.

Порты 27017 и 8080 общие с корневым стендом. Остановить его в корне репозитория:

```shell
# корень репозитория
docker compose down
```

Дальше два одинаковых сценария из каталога `mongo-sharding`: скрипты или `make`. Достаточно одного. Цели `make init`, `make seed` и `make count` вызывают те же скрипты.

- `scripts/init-cluster.sh` — `rs.initiate` для `configSrv` (порт 27019), `shard1` и `shard2` (порт 27018), ожидание `mongos_router` на порту 27017, подключение обоих шардов, `sh.enableSharding("somedb")`, `sh.shardCollection("somedb.helloDoc", { "name": "hashed" })`.
- `scripts/seed-hellodoc.sh` — 1000 документов `{ age: i, name: "ly" + i }` в `somedb.helloDoc` и `countDocuments()` на роутере. Роутер возвращает 1000.
- `scripts/count-documents.sh` — `countDocuments()` на роутере, `shard1` и `shard2`. У каждого шарда своё число, сумма совпадает с роутером. Хэш по `name` делит документы не поровну.

## Скрипты

```shell
cd mongo-sharding
docker compose up -d
./scripts/init-cluster.sh
./scripts/seed-hellodoc.sh
./scripts/count-documents.sh
```

## Make

```shell
cd mongo-sharding
make up
make init
make seed
make count
```

## Проверка

Общее число документов — в JSON `http://localhost:8080`, поле `collections.helloDoc.documents_count`, и в выводе подсчёта на роутере.
