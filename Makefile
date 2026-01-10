# basir_accounting_system Project Makefile
# نظام أتمتة شامل يدعم Flutter و Rust ومعايير الجودة الصارمة

.PHONY: help setup dev-start dev-stop run test clean build analyze format gen gen-watch rust-build sqlx-prepare sqlx-migrate purity-check health-check auto-fix update-deps setup-hooks release-check

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
RED := \033[0;31m
YELLOW := \033[0;33m
NC := \033[0m # No Color

# =============================================================================
# Meta & Help
# =============================================================================

help: ## Show this help message (عرض رسالة المساعدة)
	@echo '$(BLUE)basir_accounting_system Project Commands / أوامر مشروع بصير:$(NC)'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-25s$(NC) %s\n", $$1, $$2}'

# =============================================================================
# Setup & Installation (الإعداد والتثبيت)
# =============================================================================

setup: ## Initial project setup (dependencies) / الإعداد الأولي للمشروع
	@echo "$(BLUE)Setting up basir_accounting_system...$(NC)"
	@flutter pub get
	@cd rust && cargo fetch
	@echo "$(GREEN)✓ Setup complete! / اكتمل الإعداد$(NC)"

setup-hooks: ## Install Git hooks / تثبيت خطافات Git
	@echo "$(BLUE)Installing Git hooks...$(NC)"
	@bash scripts/install_hooks.sh || bash scripts/install_steering_hooks.sh
	@echo "$(GREEN)✓ Hooks installed!$(NC)"

# =============================================================================
# Development Workflow (سير العمل التطويري)
# =============================================================================

run: ## Run Flutter app / تشغيل التطبيق
	@flutter run

dev-start: ## Start development environment / بدء بيئة التطوير
	@bash scripts/run_dev.sh

gen: ## Generate code (build_runner) / توليد الكود التلقائي
	@echo "$(BLUE)Generating code...$(NC)"
	@flutter pub run build_runner build --delete-conflicting-outputs
	@echo "$(GREEN)✓ Code generation complete!$(NC)"

gen-watch: ## Watch and generate code / مراقبة التغييرات وتوليد الكود
	@flutter pub run build_runner watch --delete-conflicting-outputs

# =============================================================================
# Rust & Database (التعامل مع Rust وقواعد البيانات)
# =============================================================================

rust-build: ## Build native Rust libraries / بناء مكتبات Rust الأصلية
	@echo "$(BLUE)Building Rust libraries...$(NC)"
	@cd rust && cargo build --release
	@echo "$(GREEN)✓ Rust build complete!$(NC)"

sqlx-prepare: ## Prepare SQLx query metadata / إعداد بيانات SQLx الوصفية
	@echo "$(BLUE)Preparing SQLx metadata...$(NC)"
	@cd rust && cargo sqlx prepare
	@echo "$(GREEN)✓ SQLx prepared!$(NC)"

sqlx-migrate: ## Run SQLx migrations / تشغيل هجرات قواعد البيانات
	@echo "$(BLUE)Running migrations...$(NC)"
	@cd rust && cargo sqlx migrate run
	@echo "$(GREEN)✓ Migrations applied!$(NC)"

# =============================================================================
# Quality Assurance & Purity (جودة الكود والنقاء الفني)
# =============================================================================

analyze: ## Analyze Flutter code / تحليل الكود
	@echo "$(BLUE)Analyzing code...$(NC)"
	@flutter analyze
	@echo "$(GREEN)✓ Analysis complete!$(NC)"

test: ## Run all tests / تشغيل جميع الاختبارات
	@echo "$(BLUE)Running Flutter tests...$(NC)"
	@flutter test
	@echo "$(BLUE)Running Rust tests...$(NC)"
	@cd rust && cargo test
	@echo "$(GREEN)✓ All tests passed!$(NC)"

purity-check: ## Run "Diamond Purity" quality gates / التحقق من جودة "النقاء الماسي"
	@echo "$(BLUE)Running quality gates...$(NC)"
	@bash scripts/run_quality_gates.sh

health-check: ## Comprehensive health scan / مسح شامل لصحة المشروع
	@bash scripts/health_check.sh

auto-fix: ## Automatically fix linter issues / إصلاح المشاكل تلقائياً
	@dart fix --apply

format: ## Format all code / تنسيق الكود
	@echo "$(BLUE)Formatting Flutter code...$(NC)"
	@dart format .
	@echo "$(BLUE)Formatting Rust code...$(NC)"
	@cd rust && cargo fmt
	@echo "$(GREEN)✓ Formatting complete!$(NC)"

# =============================================================================
# Build & Distribution (البناء والتوزيع)
# =============================================================================

build-apk: ## Build Android APK (Release) / بناء حزمة أندرويد
	@flutter build apk --release

build-web: ## Build Web version / بناء نسخة الويب
	@flutter build web --release

clean: ## Deep clean Project / تنظيف شامل للمشروع
	@echo "$(BLUE)Cleaning build artifacts...$(NC)"
	@flutter clean
	@cd rust && cargo clean
	@echo "$(GREEN)✓ Cleaned! / تم التنظيف$(NC)"

# =============================================================================
# Maintenance (الصيانة)
# =============================================================================

update-deps: ## Update all dependencies / تحديث جميع التبعيات
	@flutter pub upgrade --major-versions
	@cd rust && cargo update

release-check: ## Final check before release / فحص نهائي قبل الإصدار
	@make clean
	@make format
	@make analyze
	@make test
	@make gen
	@make rust-build
	@make purity-check
	@echo "$(GREEN)✨ Project is ready for release! / المشروع جاهز للإصدار ✨$(NC)"
