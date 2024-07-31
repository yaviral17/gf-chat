start-db:
	@docker run -d --name gf-db -p 8089:8089 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=rnbro123 -e POSTGRES_DB=gfdb postgres:12-alpine

stop-db:
	@docker stop gf-db
	@docker rm gf-db

restart-db: stop-db start-db

run:
	@go run main.go

test:
	@go test -v ./...

.PHONY: start-db stop-db restart-db run test