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
