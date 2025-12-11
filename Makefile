.PHONY: setup-env

setup-env:
	@if [ -f .env ]; then \
		echo ".env already exists. Remove it to generate a new one."; \
		exit 1; \
	fi
	@cp .env.example .env
	@echo "Generating secrets..."
	@sed -i '' "s/SESSION_SECRET=.*/SESSION_SECRET=$$(openssl rand -hex 16)/" .env
	@sed -i '' "s/ENCRYPTION_KEY=.*/ENCRYPTION_KEY=$$(openssl rand -hex 16)/" .env
	@sed -i '' "s/MAGIC_LINK_SECRET=.*/MAGIC_LINK_SECRET=$$(openssl rand -hex 16)/" .env
	@# Generate Neo4j password and update both NEO4J_PASSWORD and NEO4J_AUTH
	@NEO4J_PWD=$$(openssl rand -hex 16); \
	sed -i '' "s/NEO4J_PASSWORD=.*/NEO4J_PASSWORD=$$NEO4J_PWD/" .env; \
	sed -i '' "s/NEO4J_AUTH=.*/NEO4J_AUTH=neo4j\/$$NEO4J_PWD/" .env
	@echo "Secrets generated and updated in .env successfully."
