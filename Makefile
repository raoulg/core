.PHONY: setup-env

setup-env:
	@if [ -f .env ]; then \
		echo ".env already exists. Remove it to generate a new one."; \
		exit 1; \
	fi
	@cp .env.example .env
	@echo "Generating secrets..."
	@# Use a portable way to edit files that works on both macOS (BSD) and Linux (GNU)
	@sed "s/SESSION_SECRET=.*/SESSION_SECRET=$$(openssl rand -hex 16)/" .env > .env.tmp && mv .env.tmp .env
	@sed "s/ENCRYPTION_KEY=.*/ENCRYPTION_KEY=$$(openssl rand -hex 16)/" .env > .env.tmp && mv .env.tmp .env
	@sed "s/MAGIC_LINK_SECRET=.*/MAGIC_LINK_SECRET=$$(openssl rand -hex 16)/" .env > .env.tmp && mv .env.tmp .env
	@# Generate Neo4j password and update both NEO4J_PASSWORD and NEO4J_AUTH
	@NEO4J_PWD=$$(openssl rand -hex 16); \
	sed "s/NEO4J_PASSWORD=.*/NEO4J_PASSWORD=$$NEO4J_PWD/" .env > .env.tmp && mv .env.tmp .env; \
	sed "s/NEO4J_AUTH=.*/NEO4J_AUTH=neo4j\/$$NEO4J_PWD/" .env > .env.tmp && mv .env.tmp .env
	@echo "Secrets generated and updated in .env successfully."
	@if [ -f hosting/docker/.env ]; then \
		echo "Updating secrets in hosting/docker/.env..."; \
		sed "s/SESSION_SECRET=.*/SESSION_SECRET=$$(grep SESSION_SECRET .env | cut -d= -f2)/" hosting/docker/.env > hosting/docker/.env.tmp && mv hosting/docker/.env.tmp hosting/docker/.env; \
		sed "s/ENCRYPTION_KEY=.*/ENCRYPTION_KEY=$$(grep ENCRYPTION_KEY .env | cut -d= -f2)/" hosting/docker/.env > hosting/docker/.env.tmp && mv hosting/docker/.env.tmp hosting/docker/.env; \
		sed "s/MAGIC_LINK_SECRET=.*/MAGIC_LINK_SECRET=$$(grep MAGIC_LINK_SECRET .env | cut -d= -f2)/" hosting/docker/.env > hosting/docker/.env.tmp && mv hosting/docker/.env.tmp hosting/docker/.env; \
		NEO4J_PWD=$$(grep NEO4J_PASSWORD .env | cut -d= -f2); \
		sed "s/NEO4J_PASSWORD=.*/NEO4J_PASSWORD=$$NEO4J_PWD/" hosting/docker/.env > hosting/docker/.env.tmp && mv hosting/docker/.env.tmp hosting/docker/.env; \
		sed "s/NEO4J_AUTH=.*/NEO4J_AUTH=neo4j\/$$NEO4J_PWD/" hosting/docker/.env > hosting/docker/.env.tmp && mv hosting/docker/.env.tmp hosting/docker/.env; \
		echo "Secrets updated in hosting/docker/.env successfully."; \
	fi
