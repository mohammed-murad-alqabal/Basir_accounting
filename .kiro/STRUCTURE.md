# .kiro Directory Structure

```
.kiro/
├── agents/                                    # AI Agent Layers
│   ├── l1-analysis/
│   │   ├── analyzers/
│   │   ├── collectors/
│   │   ├── monitors/
│   │   ├── reporters/
│   │   ├── l1-analysis-layer.ts
│   │   └── README.md
│   ├── l2-decision/
│   │   ├── actions/
│   │   ├── config/
│   │   ├── context/
│   │   ├── engine/
│   │   ├── ml/
│   │   ├── rules/
│   │   ├── l2-decision-layer.ts
│   │   └── README.md
│   ├── l3-execution/
│   │   ├── config/
│   │   ├── coordinator/
│   │   ├── dashboard/
│   │   ├── resources/
│   │   ├── scheduler/
│   │   ├── workflow/
│   │   ├── l3-execution-layer.ts
│   │   └── README.md
│   ├── package.json
│   └── tsconfig.json
├── data/
│   └── sqlite_mcp_server.db                  # SQLite Database
├── docs/                                     # Documentation & Reports
│   ├── plans/
│   │   ├── git/
│   │   ├── testing/
│   │   ├── KIRO_WORKFLOW_TESTING_PLAN.md
│   │   ├── PROJECT_ROOT_CLEANUP_EXECUTION_PLAN.md
│   │   └── SCRIPTS_TESTING_PLAN.md
│   ├── reports/
│   │   ├── components/
│   │   ├── enhancements/
│   │   ├── git/
│   │   ├── kiro/
│   │   ├── phases/
│   │   ├── quality/
│   │   ├── reorganization/
│   │   ├── sessions/
│   │   ├── status/
│   │   ├── testing/
│   │   ├── CUSTOMER_FORM_TEST_FIX_REPORT.md
│   │   └── SESSION_6_COMPLETION_REPORT.md
│   ├── ACHIEVEMENTS.md
│   ├── BEST_REPOSITORIES_AND_TEMPLATES_ANALYSIS.md
│   ├── COMPLETE_DOCS_REORGANIZATION_SUCCESS_REPORT.md
│   ├── COMPLETE_SYSTEM_FINAL_REPORT.md
│   ├── COMPREHENSIVE_KIRO_ANALYSIS_AND_ENHANCEMENT_PLAN.md
│   ├── COMPREHENSIVE_KIRO_STANDARDS_ANALYSIS_UPDATED.md
│   ├── COMPREHENSIVE_REPOSITORY_AUDIT.md
│   ├── COMPREHENSIVE_SPECS_ANALYSIS.md
│   ├── CONTEXT_OPTIMIZATION_SUCCESS.md
│   ├── context-monitor.md
│   ├── CRITICAL_ASSESSMENT_REALITY_CHECK.md
│   ├── CRITICAL_REORGANIZATION_ANALYSIS.md
│   ├── documentation_restructure_summary.md
│   ├── DOCUMENTATION_STRUCTURE_FINAL_SUMMARY.md
│   ├── FINAL_SESSION_ACHIEVEMENTS_REPORT.md
│   ├── FINAL_STRATEGIC_DECISION_ANALYSIS.md
│   ├── GIT_AND_DOCS_REORGANIZATION_FINAL_SUMMARY.md
│   ├── INTEGRATION_STATUS_REPORT.md
│   ├── KIRO_STANDARDS_IMPLEMENTATION_PLAN.md
│   ├── L1_ANALYSIS_LAYER_COMPLETION_REPORT.md
│   ├── L2_DECISION_LAYER_COMPLETION_REPORT.md
│   ├── L3_EXECUTION_LAYER_COMPLETION_REPORT.md
│   ├── OFFICIAL_KIRO_STANDARDS_COMPLIANCE_ANALYSIS.md
│   ├── PROFESSIONAL_KIRO_REFERENCES_ANALYSIS.md
│   ├── QUICK_START_PROFESSIONAL_COMPONENTS.md
│   ├── README.md
│   ├── REORGANIZATION_SUCCESS.md
│   ├── report-templates.md
│   ├── REPOSITORY_CLEANUP_REPORT.md
│   ├── SESSION_28_NOV_2025.md
│   ├── SESSION_COMPLETE_SUMMARY.md
│   ├── STEERING_CRITICAL_RULES.md
│   ├── STEERING_GUIDE.md
│   ├── STEERING_OPTIMIZATION_IMPLEMENTATION_PLAN.md
│   ├── WORKSPACE_TRANSFORMATION_FINAL_ASSESSMENT.md
│   └── WORKSPACE_TRANSFORMATION_STRATEGIC_ANALYSIS.md
├── guides/                                   # Development Guides
│   ├── deployment-guide.md
│   ├── flutter-guide.md
│   ├── git-guide.md
│   ├── security-guide.md
│   └── testing-guide.md
├── hooks/                                    # Automation Hooks
│   ├── automatic/                            # Auto-triggered hooks
│   │   ├── accessibility-audit.kiro.hook
│   │   ├── api-schema-validation.kiro.hook
│   │   ├── auto-test-on-save.kiro.hook
│   │   ├── cdk-synth-on-change.kiro.hook
│   │   ├── code-coverage-check.kiro.hook
│   │   ├── commit-message-helper.kiro.hook
│   │   ├── dependency-update-check.kiro.hook
│   │   ├── env-file-validation.kiro.hook
│   │   ├── lint-and-format-on-save.kiro.hook
│   │   ├── mcp-config-validation.kiro.hook
│   │   ├── mcp-server-test.kiro.hook
│   │   ├── performance-analysis.kiro.hook
│   │   ├── readme-spell-check.kiro.hook
│   │   ├── security-scan-on-dependency-change.kiro.hook
│   │   ├── translation-update.kiro.hook
│   │   ├── update-documentation.kiro.hook
│   │   └── validate-docker-on-change.kiro.hook
│   ├── manual/                               # Manual hooks
│   │   ├── 20_dependency_check.kiro.hook
│   │   └── 30_deploy_gitops.sh
│   ├── on-commit/                            # Git commit hooks
│   │   └── 10_security_scan.sh
│   ├── on-push/                              # Git push hooks
│   │   └── 20_quality_gate.sh
│   ├── on-save/                              # File save hooks
│   │   ├── 10_lint_and_format.kiro.hook
│   │   └── 30_update_docs.sh
│   ├── optional/                             # Optional hooks
│   ├── activate-all-agents.kiro.hook
│   ├── auto-analyze.json
│   ├── auto-format.json
│   ├── check-arabic-translation.json
│   ├── check-assets-optimization.json
│   ├── check-code-generation.json
│   ├── check-dartdoc.json
│   ├── check-database-operations.json
│   ├── check-dependencies-security.json
│   ├── check-error-handling.json
│   ├── check-naming.json
│   ├── check-performance-patterns.json
│   ├── check-readme-sync.json
│   ├── check-state-management.json
│   ├── check-tests-exist.json
│   ├── check-todo-age.json
│   ├── check-version-update.json
│   ├── HOOKS_IMPLEMENTATION_REPORT.md
│   ├── pre-commit-quality.json
│   ├── pre-push
│   ├── project-status.json
│   ├── QUICK_REFERENCE.md
│   ├── README.md
│   ├── remind-changelog.json
│   ├── run-related-tests.json
│   ├── security-check.json
│   ├── spec-compliance-check.json
│   └── weekly-health-check.json
├── powers/                                   # Kiro Powers
│   ├── aurora-dsql/
│   │   ├── steering/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── aws-agentcore/
│   │   ├── steering/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── aws-infrastructure-as-code/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── cloud-architect/
│   │   ├── steering/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── datadog/
│   │   ├── steering/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── dynatrace/
│   │   ├── steering/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── figma/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── neon/
│   │   ├── steering/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── postman/
│   │   ├── steering/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── power-builder/
│   │   ├── steering/
│   │   └── POWER.md
│   ├── saas-builder/
│   │   ├── steering/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── strands/
│   │   ├── steering/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── stripe/
│   │   ├── steering/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── terraform/
│   │   ├── steering/
│   │   ├── mcp.json
│   │   └── POWER.md
│   ├── CODE_OF_CONDUCT.md
│   ├── CONTRIBUTING.md
│   └── README.md
├── prompts/                                  # AI Prompts
│   ├── examples/                             # Prompt examples
│   │   ├── 01-createSpec-example.md
│   │   ├── 02-design-example.md
│   │   ├── 03-createTask-example.md
│   │   ├── 04-executeTask-example.md
│   │   ├── 05-commit-example.md
│   │   ├── 06-prReview-example.md
│   │   └── README.md
│   ├── models/                               # Model-specific prompts
│   │   ├── anthropic/
│   │   ├── bedrock/
│   │   ├── ollama/
│   │   ├── openai/
│   │   ├── alpaca-edit.md
│   │   ├── deepseek-edit.md
│   │   ├── delete-file.md
│   │   ├── execute-bash.md
│   │   ├── file-search.md
│   │   ├── fs-append.md
│   │   ├── fs-write.md
│   │   ├── gemma-edit.md
│   │   ├── grep-search.md
│   │   ├── hook-creation.md
│   │   ├── list-directory.md
│   │   ├── neural-chat-edit.md
│   │   ├── openchat-edit.md
│   │   ├── phind-edit.md
│   │   ├── read-file.md
│   │   ├── read-multiple-files.md
│   │   ├── simplified-edit.md
│   │   ├── spec-design-document.md
│   │   ├── spec-implementation-plan.md
│   │   ├── spec-requirements-clarification.md
│   │   ├── spec-task-execution.md
│   │   ├── str-replace.md
│   │   ├── system-prompt.md
│   │   ├── xwin-coder-edit.md
│   │   └── zephyr-edit.md
│   ├── providers/                            # Provider-specific prompts
│   │   ├── anthropic-claude.md
│   │   ├── aws-bedrock.md
│   │   ├── gemini-pro.md
│   │   ├── google-gemini.md
│   │   ├── llama-models.md
│   │   ├── ollama-local.md
│   │   └── openai-gpt4.md
│   ├── commit.prompt.md
│   ├── createSpec.prompt.md
│   ├── createTask.prompt.md
│   ├── design.prompt.md
│   ├── executeTask.prompt.md
│   ├── prReview.prompt.md
│   ├── QUICK_START.md
│   ├── README.md
│   ├── system_code_generator.prompt.md
│   ├── system_default.prompt.md
│   └── system_spec_writer.prompt.md
├── reference/                                # Reference Documentation
│   ├── arabic-dictionary.md
│   ├── best-practices.md
│   ├── examples.md
│   ├── full-standards.md
│   └── strategic-docs.md
├── rules/                                    # Rules & Policies (empty)
├── scripts/                                  # Automation Scripts
│   ├── automation/
│   │   ├── repository-monitor.sh
│   │   └── run.sh
│   ├── deployment/
│   │   ├── build-all.sh
│   │   ├── build-android.sh
│   │   ├── build-ios.sh
│   │   └── build-web.sh
│   ├── documentation/
│   │   └── generate-docs.sh
│   ├── maintenance/
│   │   ├── backup.sh
│   │   ├── cleanup.sh
│   │   ├── format-code.sh
│   │   ├── git-cleanup.sh
│   │   └── update-dependencies.sh
│   ├── setup/
│   │   ├── configure-environment.sh
│   │   ├── install-dependencies.sh
│   │   ├── setup-git-hooks.sh
│   │   ├── setup-pre-commit-hooks.sh
│   │   └── setup-project.sh
│   ├── testing/
│   │   ├── accessibility-test.sh
│   │   ├── check-quality-enhanced.sh
│   │   ├── check-quality.sh
│   │   ├── generate-coverage.sh
│   │   ├── i18n-test.sh
│   │   ├── performance-test.sh
│   │   ├── run-integration-tests.sh
│   │   └── run-tests.sh
│   ├── activate-blueprint.sh
│   ├── clone-professional-components.sh
│   └── README.md
├── security/                                 # Security (empty)
├── settings/                                 # System Settings
│   ├── editor.json
│   ├── error_tracking.yml
│   ├── mcp.json                              # MCP Server Configuration
│   └── performance.json
├── specs/                                    # Project Specifications
│   ├── beta-testing-program/
│   │   └── requirements.md
│   ├── brand-visual-identity/
│   │   ├── design.md
│   │   ├── requirements.md
│   │   └── tasks.md
│   ├── context-optimization/
│   │   └── archive/                          # Archived project
│   ├── enhanced-onboarding/
│   │   ├── DESIGN_DECISIONS.md
│   │   ├── design.md
│   │   ├── PROJECT_STATUS_REVIEW.md
│   │   ├── README.md
│   │   ├── requirements.md
│   │   └── tasks.md
│   ├── i18n-localization-system/
│   │   ├── design.md
│   │   ├── README.md
│   │   ├── RECOMMENDATIONS_SUMMARY.md
│   │   ├── requirements.md
│   │   └── tasks.md
│   ├── local-analytics/
│   │   └── requirements.md
│   ├── onboarding-tutorial/
│   │   ├── design.md
│   │   ├── requirements.md
│   │   └── tasks.md
│   ├── reports/
│   │   └── EXECUTIVE_SUMMARY_UPDATED.md
│   ├── repository-optimization/
│   │   ├── code-quality/
│   │   ├── context-optimization-closure/
│   │   ├── critical-fixes/
│   │   ├── documentation/
│   │   ├── error-tracking/
│   │   ├── git-repository-optimization-completed/
│   │   ├── release-management/
│   │   ├── repository-audit/
│   │   ├── steering-cleanup/
│   │   ├── testing-integration/
│   │   ├── INDEX.md
│   │   ├── README.md
│   │   └── REORGANIZATION_REPORT.md
│   ├── strategic-vision/
│   │   ├── design.md
│   │   ├── requirements.md
│   │   └── tasks.md
│   ├── ui-ux-improvements/
│   │   ├── ANALYSIS_REPORT.md
│   │   ├── color-states-analysis-report.md
│   │   ├── design.md
│   │   ├── README.md
│   │   ├── requirements.md
│   │   ├── tasks.md
│   │   ├── update-summary.md
│   │   └── UX_PSYCHOLOGY_ANALYSIS.md
│   ├── workspace-transformation/             # Active project
│   │   ├── phase-1-compliance/
│   │   ├── phase-2-intelligence/
│   │   ├── integration-plan.md
│   │   └── README.md
│   ├── IMMEDIATE_ACTION_PLAN.md
│   ├── l2-decision-layer-design.md
│   ├── l2-decision-layer-requirements.md
│   ├── l3-execution-layer-design.md
│   ├── l3-execution-layer-requirements.md
│   ├── PROGRESS_TRACKER.md
│   ├── QUICK_ACTION_PLAN.md
│   ├── README.md
│   ├── REALITY_CHECK_REPORT.md
│   └── STRATEGIC_DECISION.md
├── standards/                                # Development Standards
│   ├── arabic.md
│   ├── code-quality.md
│   ├── documentation.md
│   ├── file-organization.md
│   ├── flutter.md
│   ├── naming.md
│   └── testing.md
├── steering/                                 # Core Steering (Optimized)
│   ├── core/                                 # Essential files (160 lines)
│   │   ├── philosophy.md
│   │   ├── quick-reference.md
│   │   └── team-identity.md
│   ├── technologies/                         # Technology-specific guides
│   │   ├── api-design.md
│   │   ├── aws-cli-best-practices.md
│   │   ├── cdk-best-practices.md
│   │   ├── development-environment.md
│   │   ├── development-standards.md
│   │   ├── docker-best-practices.md
│   │   ├── flutter-dart-standards.md
│   │   ├── frontend-standards.md
│   │   ├── git-best-practices.md
│   │   ├── git-workflow.md
│   │   ├── mcp-best-practices.md
│   │   ├── microservices-patterns.md
│   │   ├── project-standards.md
│   │   ├── python-best-practices.md
│   │   ├── react-best-practices.md
│   │   ├── security-best-practices.md
│   │   ├── serverless-patterns.md
│   │   ├── steering-creation-guide.md
│   │   ├── testing-best-practices.md
│   │   └── typescript-best-practices.md
│   ├── CLEANUP_REPORT.md
│   └── config.json
├── templates/                                # Code & Doc Templates
│   ├── code/
│   │   ├── flutter_snippets.json
│   │   ├── integration_test_template.dart
│   │   ├── model_template.dart
│   │   ├── provider_template.dart
│   │   ├── README.md
│   │   ├── repository_template.dart
│   │   ├── service_template.dart
│   │   ├── test_template.dart
│   │   └── widget_template.dart
│   ├── docs/
│   │   ├── api_doc_template.md
│   │   ├── changelog_template.md
│   │   ├── feature_doc_template.md
│   │   └── README.md
│   ├── specs/
│   │   ├── design_template.md
│   │   ├── feature_spec_template.md
│   │   ├── README.md
│   │   └── task_breakdown_template.md
│   ├── workflows/
│   │   ├── cd_template.yml
│   │   ├── ci_template.yml
│   │   ├── quality_gate_template.yml
│   │   └── README.md
│   ├── documentation-automation.md
│   ├── ears-requirements.md                  # EARS methodology template
│   ├── error-tracking-setup.md
│   ├── provider_template.dart
│   ├── quality-gates-template.md
│   ├── README.md
│   ├── screen_template.dart
│   └── test_template.dart
├── INDEX.md                                  # Main index
├── README.md                                 # Main documentation
└── WORKSPACE_ACTIVATION.md                   # Workspace activation guide
```
