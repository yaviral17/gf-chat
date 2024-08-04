start-db:
	@sudo docker run -d --name gf-db -p 8089:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=rnbro123 -e POSTGRES_DB=gfdb postgres:12-alpine

stop-db:
	@sudo docker stop gf-db
	@sudo docker rm gf-db

restart-db: stop-db start-db

rm-db:
	@sudo docker rm gf-db

create-migration:
	@sudo ./migrate create -ext sql -dir db/migrations -seq init_schema

db-up:
	@sudo ./migrate -path db/migrations -database "postgresql://root:rnbro123@localhost:8089/gfdb?sslmode=disable" up

db-down:
	@sudo ./migrate -path db/migrations -database "postgresql://root:rnbro123@localhost:8089/gfdb?sslmode=disable" down

run:
	@go run main.go

test:
	@go test -v ./...

.PHONY: start-db stop-db restart-db run test db-up db-down