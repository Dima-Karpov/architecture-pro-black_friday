.PHONY: up init seed count

up:
	docker compose up -d

init:
	./scripts/init-cluster.sh

seed:
	./scripts/seed-hellodoc.sh

count:
	./scripts/count-documents.sh
