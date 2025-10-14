  # Nome do container do MySQL no Docker
CONTAINER_NAME=mysql_db
DB_USER=root
DB_PASS=root
DB_NAME=sistema_bancario

# Caminho para os arquivos SQL
PROCEDURE=./sql/procedures.sql
SCHEMA=./sql/schema.sql
SCHEMADROP=./sql/schema_drop.sql
INSERTS=./sql/inserts.sql
PROCEDURES=./sql/procedures.sql

# Apaga e recria apenas o schema

drop-tables:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) < $(SCHEMADROP
	)
create-tables:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) < $(SCHEMA)

# Apaga e recria o schema e popula com dados iniciais
reset-db:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) < $(SCHEMA)
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(PROCEDURES)
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(INSERTS)

# Executa apenas o seed (dados iniciais)
inserts:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(INSERTS)

# Cria procedures
create-procedures:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(PROCEDURES)

# Apaga e recria o schema e popula com dados iniciais
reset-db:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) < $(SCHEMA)
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(PROCEDURES)
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(INSERTS)

# Executa apenas o seed (dados iniciais)
inserts:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(INSERTS)

# Up container Dockers
start:
	docker-compose up -d
# Down container Dockers
stop:
	docker-compose down
# Restart container Dockers
restart: 
	stop start

# Verifica logs do container Web
logs:
	docker logs -f web