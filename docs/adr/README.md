# Решения

Индекс ADR по стенду «Мобильный мир». Схемы задания 1 лежат в `docs/c4/` и на страницах `mobile-world.drawio`. Consul, API Gateway и CDN в этот индекс не входят: это задания 5 и 6. Ключи коллекций магазина `shop` — ADR-005…ADR-007. Горячие шарды — ADR-008. Чтение с реплик — ADR-009. Стенд при них остаётся прежним. Текст и команды — в [архитектурном документе](../07-10.md).

| ADR | Файл | Решение | Статус |
| --- | --- | --- | --- |
| 001 | [0001-as-is.md](0001-as-is.md) | Один `pymongo-api` и один `mongodb1`, без шардов и Redis | Accepted |
| 002 | [0002-two-shards.md](0002-two-shards.md) | Хэш по `name`, два шарда, маршрутизирует `mongos` | Accepted |
| 003 | [0003-three-replicas.md](0003-three-replicas.md) | Replica set: 1 primary + 2 secondary в каждом шарде | Accepted |
| 004 | [0004-redis.md](0004-redis.md) | Один Redis, Cache Aside, сброс ключа списка на `POST` | Accepted |
| 005 | [0005-orders-shard-key.md](0005-orders-shard-key.md) | `shop.orders`: хэш `user_id` | Accepted |
| 006 | [0006-products-shard-key.md](0006-products-shard-key.md) | `shop.products`: хэш `_id` | Accepted |
| 007 | [0007-carts-shard-key.md](0007-carts-shard-key.md) | `shop.carts`: хэш `session_id` | Accepted |
| 008 | [0008-hot-shards.md](0008-hot-shards.md) | Горячий шард: доля операций ≥ 0,70 или разница данных ≥ 384 МБ, ключ `products` не меняем | Accepted |
| 009 | [0009-read-preference.md](0009-read-preference.md) | Статус, остаток и корзина — primary; история и каталог — secondary, допуск секунды | Accepted |
