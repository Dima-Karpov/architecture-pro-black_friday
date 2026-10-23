.PHONY: up init init-config init-shard1 init-shard2 enable-sharding seed count

up:
	docker compose up -d

init-config:
	./scripts/init-config.sh

init-shard1:
	./scripts/init-shard1.sh

init-shard2:
	./scripts/init-shard2.sh

enable-sharding:
	./scripts/enable-sharding.sh

init:
	./scripts/init-cluster.sh

seed:
	./scripts/seed-hellodoc.sh

count:
	./scripts/count-documents.sh
