.PHONY: setup-env

setup-env:
	@if [ -f hosting/docker/.env ]; then \
		echo "hosting/docker/.env already exists. Remove it to generate a new one."; \
		exit 1; \
	fi
	@cp hosting/docker/.env.example hosting/docker/.env
	@echo "Generating secrets..."
	@# Use a portable way to edit files that works on both macOS (BSD) and Linux (GNU)
	@sed "s/SESSION_SECRET=.*/SESSION_SECRET=$$(openssl rand -hex 16)/" hosting/docker/.env > hosting/docker/.env.tmp && mv hosting/docker/.env.tmp hosting/docker/.env
	@sed "s/ENCRYPTION_KEY=.*/ENCRYPTION_KEY=$$(openssl rand -hex 16)/" hosting/docker/.env > hosting/docker/.env.tmp && mv hosting/docker/.env.tmp hosting/docker/.env
	@sed "s/MAGIC_LINK_SECRET=.*/MAGIC_LINK_SECRET=$$(openssl rand -hex 16)/" hosting/docker/.env > hosting/docker/.env.tmp && mv hosting/docker/.env.tmp hosting/docker/.env
	@# Generate Neo4j password and update both NEO4J_PASSWORD and NEO4J_AUTH
	@NEO4J_PWD=$$(openssl rand -hex 16); \
		sed "s/NEO4J_PASSWORD=.*/NEO4J_PASSWORD=$$NEO4J_PWD/" hosting/docker/.env > hosting/docker/.env.tmp && mv hosting/docker/.env.tmp hosting/docker/.env; \
		sed "s/NEO4J_AUTH=.*/NEO4J_AUTH=neo4j\/$$NEO4J_PWD/" hosting/docker/.env > hosting/docker/.env.tmp && mv hosting/docker/.env.tmp hosting/docker/.env
	@echo "Secrets generated and updated in hosting/docker/.env successfully."
