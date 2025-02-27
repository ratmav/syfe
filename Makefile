# Makefile for syfe Neovim plugin

.PHONY: lint lint.lua help

# Lint Lua code
lint.lua:
	@echo "Linting Lua code..."
	@if command -v luacheck >/dev/null 2>&1; then \
		luacheck lua/; \
	else \
		echo "luacheck not found. Please install luacheck: 'luarocks install luacheck'"; \
		exit 1; \
	fi
	@echo "Lua linting complete"

# Lint all code
lint: lint.lua
	@echo "All linting complete"

# Help target
help:
	@echo "Syfe Makefile"
	@echo ""
	@echo "Available commands:"
	@echo "  make lint             Run all linters"
	@echo "  make lint.lua         Run Lua linter (luacheck)"
	@echo "  make help             Show this help message"