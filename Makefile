# <====================================================================================================================>
#                                                 GLTrace - Makefile
# <====================================================================================================================>

.PHONY: help usage check deps lint test test-deps fmt install-local docs-up docs-down docs-logs

.DEFAULT_GOAL := help

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'


# <====================================================================================================================>
#                                                    Dependencies
# <====================================================================================================================>

check: ## Validate required core dependencies (curl, jq)
	command -v curl >/dev/null || (echo "Missing: curl" && exit 1)
	command -v jq   >/dev/null || (echo "Missing: jq"   && exit 1)
	echo "OK: curl + jq present"

deps: ## Show optional dependency status (gum for wizard; fzf for picker)
	command -v gum >/dev/null && echo "OK: gum" || echo "Missing: gum (auto-installed in wizard mode)"
	command -v fzf >/dev/null && echo "OK: fzf" || echo "Missing (optional): fzf"

test-deps: ## Install test dependencies (bats-core via brew)
	brew install bats-core


# <====================================================================================================================>
#                                                    Code quality
# <====================================================================================================================>

lint: ## Run shellcheck on the script
	shellcheck ./gltrace

fmt: ## Format with shfmt (if installed)
	command -v shfmt >/dev/null && shfmt -w ./gltrace || echo "shfmt not installed, skipping"


# <====================================================================================================================>
#                                                       Tests
# <====================================================================================================================>

test: ## Run bats test suite
	bats tests/


# <====================================================================================================================>
#                                                     Docs site
# <====================================================================================================================>

docs-up: ## Start docs dev server (localhost:4321/gltrace/)
	cd docs && docker compose up -d

docs-down: ## Stop docs container
	cd docs && docker compose down

docs-logs: ## Tail docs container logs
	cd docs && docker compose logs -f docs


# <====================================================================================================================>
#                                                   Local install
# <====================================================================================================================>

usage: ## Show CLI usage
	./gltrace --help

install-local: ## Install script to ~/.local/bin/gltrace
	mkdir -p "$$HOME/.local/bin"
	cp ./gltrace "$$HOME/.local/bin/gltrace"
	chmod +x "$$HOME/.local/bin/gltrace"
	echo "Installed: $$HOME/.local/bin/gltrace"
	echo "Make sure $$HOME/.local/bin is in your PATH"
