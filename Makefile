# Baseer MVP Project Makefile
# المرجع: مقتبس من أرشيف Baseer_0_Foundation ومكيف للمشروع الحالي

.PHONY: help setup dev-start dev-stop test clean build

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
NC := \033[0m # No Color

help: ## Show this help message
	@echo '$(BLUE)Baseer MVP Project Commands:$(NC)'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

# =============================================================================
# Setup & Installation
# =============================================================================

setup: ## Initial project setup (dependencies)
	@echo "$(BLUE)Setting up Baseer MVP...$(NC)"
	@echo "Installing Flutter dependencies..."
	flutter pub get
	@echo "$(GREEN)✓ Setup complete!$(NC)"

setup-hooks: ## Install Git hooks
	@echo "$(BLUE)Installing Git hooks...$(NC)"
	@mkdir -p .git/hooks
	# Check if .githooks exists before linking
	@if [ -d ".githooks" ]; then \
		ln -sf ../../.githooks/pre-commit .git/hooks/pre-commit; \
		ln -sf ../../.githooks/commit-msg .git/hooks/commit-msg; \
		chmod +x .githooks/pre-commit .githooks/commit-msg; \
		echo "$(GREEN)✓ Hooks installed and symlinked!$(NC)"; \
	else \
		echo "Warning: .githooks directory not found."; \
	fi

# =============================================================================
# Development
# =============================================================================

dev-start: ## Start development (Flutter run)
	@echo "$(BLUE)Starting Flutter app...$(NC)"
	flutter run

# =============================================================================
# Flutter Commands
# =============================================================================

run: ## Run Flutter app
	flutter run

build-apk: ## Build Android APK
	flutter build apk --release

build-web: ## Build web app
	flutter build web --release

test: ## Run Flutter tests
	@echo "$(BLUE)Running all tests...$(NC)"
	flutter test
	@echo "$(GREEN)✓ All tests passed!$(NC)"

coverage: ## Run tests with coverage
	flutter test --coverage
	@echo "Coverage report generated in coverage/lcov.info"

analyze: ## Analyze Flutter code
	flutter analyze

format: ## Format Flutter code
	dart format .

clean: ## Clean Flutter build
	@echo "$(BLUE)Cleaning build artifacts...$(NC)"
	flutter clean
	flutter pub get
	@echo "$(GREEN)✓ Cleaned!$(NC)"

# =============================================================================
# Code Generation (Riverpod, Isar, Freezed)
# =============================================================================

gen: ## Generate code (build_runner build)
	@echo "$(BLUE)Generating code...$(NC)"
	dart run build_runner build --delete-conflicting-outputs
	@echo "$(GREEN)✓ Code generation complete!$(NC)"

gen-watch: ## Watch and generate code
	@echo "$(BLUE)Watching for changes...$(NC)"
	dart run build_runner watch --delete-conflicting-outputs

# =============================================================================
# Database (Isar)
# =============================================================================

# Isar commands handled via build_runner mostly

# =============================================================================
# Agent Commands (Compatible with Agentic Workflow)
# =============================================================================

health-check: ## Run project-wide health check
	@echo "$(BLUE)Running Health Check...$(NC)"
	flutter analyze
	flutter test
	@echo "$(GREEN)✓ Health check complete!$(NC)"

auto-fix: ## Automatically fix linter issues
	dart fix --apply

update-deps: ## Update dependencies
	flutter pub upgrade --major-versions

# =============================================================================
# Release
# =============================================================================

release-check: ## Check before release
	@make clean
	@make format
	@make analyze
	@make test
	@make gen
