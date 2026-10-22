# Решения

Индекс ADR по стенду «Мобильный мир». Схемы задания 1 лежат в `docs/c4/` и на страницах `mobile-world.drawio`. Consul, API Gateway и CDN в этот индекс не входят: это задания 5 и 6.

| ADR | Файл | Решение | Статус |
| --- | --- | --- | --- |
| 001 | [0001-as-is.md](0001-as-is.md) | Один `pymongo-api` и один `mongodb1`, без шардов и Redis | Accepted |
| 002 | [0002-two-shards.md](0002-two-shards.md) | Хэш по `name`, два шарда, маршрутизирует `mongos` | Accepted |
| 003 | [0003-three-replicas.md](0003-three-replicas.md) | Replica set: 1 primary + 2 secondary в каждом шарде | Accepted |
| 004 | [0004-redis.md](0004-redis.md) | Один Redis, Cache Aside, сброс ключа списка на `POST` | Accepted |
