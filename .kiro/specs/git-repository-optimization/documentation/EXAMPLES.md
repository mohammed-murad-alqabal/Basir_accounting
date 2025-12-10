# أمثلة عملية - نظام التوثيق الشامل

## 📚 نظرة عامة

هذا الملف يحتوي على أمثلة عملية شاملة لاستخدام نظام التوثيق في سيناريوهات مختلفة.

## 🎯 الفهرس

1. [أمثلة بسيطة](#أمثلة-بسيطة)
2. [أمثلة متقدمة](#أمثلة-متقدمة)
3. [حالات استخدام شائعة](#حالات-استخدام-شائعة)
4. [التكامل مع CI/CD](#التكامل-مع-cicd)
5. [أمثلة البرمجة](#أمثلة-البرمجة)

---

## أمثلة بسيطة

### مثال 1: تحليل ملف واحد

```bash
# تحليل ملف customer_model.dart
dart lib/tools/documentation/cli/doc_cli.dart analyze \
  --path lib/data/models/customer_model.dart

# النتيجة المتوقعة:
# Analyzing: lib/data/models/customer_model.dart
#
# Results:
# - Total Elements: 15
# - Documented: 12
# - Undocumented: 3
# - Coverage: 80.0%
#
# Undocumented Elements:
# 1. Property: _id (line 10)
# 2. Method: _validatePhone (line 45)
# 3. Method: _formatName (line 67)
```

### مثال 2: توليد توثيق بسيط

```bash
# توليد توثيق لملف واحد
dart lib/tools/documentation/cli/doc_cli.dart generate \
  --path lib/core/constants.dart \
  --minimal

# النتيجة:
# Generating documentation for: lib/core/constants.dart
# ✓ Generated documentation for 8 elements
# ✓ Applied documentation to file
#
# Summary:
# - Classes: 0
# - Methods: 0
# - Properties: 8
# - Total: 8
```

### مثال 3: التحقق من جودة ملف

```bash
# التحقق من جودة التوثيق
dart lib/tools/documentation/cli/doc_cli.dart validate \
  --path lib/features/auth/auth_service.dart

# النتيجة:
# Validating: lib/features/auth/auth_service.dart
#
# Quality Score: 85/100 (Excellent)
#
# Issues Found: 2
# 1. [Warning] Missing example in method documentation (line 34)
# 2. [Info] Consider adding more details (line 56)
#
# Recommendations:
# - Add usage examples to public methods
# - Include parameter descriptions
```

---

## أمثلة متقدمة

### مثال 4: سير عمل كامل لميزة

```bash
#!/bin/bash
# Script: document_feature.sh
# Usage: ./document_feature.sh customers

FEATURE=$1
FEATURE_PATH="lib/features/$FEATURE"

echo "📊 Step 1: Analyzing $FEATURE feature..."
dart lib/tools/documentation/cli/doc_cli.dart analyze \
  --path "$FEATURE_PATH" \
  --verbose \
  --output "analysis_$FEATURE.json"

echo ""
echo "📝 Step 2: Generating documentation..."
dart lib/tools/documentation/cli/doc_cli.dart generate \
  --path "$FEATURE_PATH" \
  --comprehensive \
  --bilingual \
  --include-examples

echo ""
echo "✅ Step 3: Validating quality..."
dart lib/tools/documentation/cli/doc_cli.dart validate \
  --path "$FEATURE_PATH" \
  --strict

echo ""
echo "📄 Step 4: Creating report..."
dart lib/tools/documentation/cli/doc_cli.dart report \
  --format html \
  --output "report_$FEATURE.html" \
  --include-stats \
  --include-trends

echo ""
echo "✨ Done! Check report_$FEATURE.html for details."
```

### مثال 5: توليد توثيق مخصص

```dart
// example_custom_generation.dart
import 'package:basser_mvp/tools/documentation/generation/generation_engine.dart';
import 'package:basser_mvp/tools/documentation/analysis/analysis_engine.dart';

Future<void> main() async {
  // 1. تحليل الملف
  final engine = AnalysisEngine();
  final result = await engine.analyzeFile('lib/features/auth/auth_service.dart');

  print('Found ${result.undocumentedElements.length} undocumented elements');

  // 2. توليد توثيق مخصص
  final generator = GenerationEngine();
  final options = GenerationOptions(
    includeArabic: true,
    includeEnglish: true,
    includeExamples: true,
    includeDetails: true,
    includeParameters: true,
    includeReturns: true,
    includeExceptions: true,
  );

  final docs = <String, String>{};
  for (final element in result.undocumentedElements) {
    final doc = await generator.generateDocumentation(element, options);
    docs[element.name] = doc;
    print('Generated documentation for: ${element.name}');
  }

  // 3. تطبيق التوثيق
  await generator.applyDocumentation(
    'lib/features/auth/auth_service.dart',
    docs,
  );

  print('✓ Documentation applied successfully!');
}
```

### مثال 6: تحليل متقدم مع إحصائيات

```dart
// example_advanced_analysis.dart
import 'package:basser_mvp/tools/documentation/analysis/analysis_engine.dart';
import 'package:basser_mvp/tools/documentation/repository/documentation_repository.dart';

Future<void> main() async {
  final engine = AnalysisEngine();
  final repository = DocumentationRepository();

  // 1. تحليل المشروع بالكامل
  print('Analyzing entire project...');
  final results = await engine.analyzeDirectory('lib');

  // 2. حساب الإحصائيات
  final stats = await engine.getCoverageStats(results);

  print('\n📊 Project Statistics:');
  print('Total Elements: ${stats.totalElements}');
  print('Documented: ${stats.documentedElements}');
  print('Undocumented: ${stats.undocumentedElements}');
  print('Coverage: ${stats.coveragePercentage.toStringAsFixed(2)}%');

  print('\n📈 Breakdown by Type:');
  stats.elementBreakdown.forEach((type, count) {
    print('- $type: $count');
  });

  // 3. حفظ التقرير
  final report = CoverageReport(
    timestamp: DateTime.now(),
    totalElements: stats.totalElements,
    documentedElements: stats.documentedElements,
    undocumentedElements: stats.undocumentedElements,
    coveragePercentage: stats.coveragePercentage,
    fileResults: results,
  );

  await repository.saveCoverageReport(report);
  print('\n✓ Report saved successfully!');

  // 4. حساب الاتجاه
  final trend = await repository.calculateTrend();
  print('\n📉 Trend: ${trend.direction}');
  print('Change: ${trend.changePercentage.toStringAsFixed(2)}%');
}
```

---

## حالات استخدام شائعة

### حالة 1: توثيق ميزة جديدة

**السيناريو:** أنت تطور ميزة جديدة وتريد توثيقها بشكل كامل قبل الـ PR.

```bash
# 1. تطوير الميزة
# ... كتابة الكود ...

# 2. تحليل التغطية
dart lib/tools/documentation/cli/doc_cli.dart analyze \
  --path lib/features/new_feature

# 3. توليد التوثيق الأساسي
dart lib/tools/documentation/cli/doc_cli.dart generate \
  --path lib/features/new_feature \
  --comprehensive

# 4. مراجعة وتحسين التوثيق يدوياً
# ... تحسين التوثيق المولد ...

# 5. التحقق من الجودة
dart lib/tools/documentation/cli/doc_cli.dart validate \
  --path lib/features/new_feature

# 6. إنشاء PR
git add .
git commit -m "feat: add new feature with documentation"
git push origin feature/new-feature
```

### حالة 2: تحسين توثيق موجود

**السيناريو:** التوثيق الحالي ضعيف وتريد تحسينه.

```bash
# 1. تحليل الوضع الحالي
dart lib/tools/documentation/cli/doc_cli.dart analyze \
  --path lib/features/customers \
  --verbose > current_state.txt

# 2. توليد توثيق محسّن
dart lib/tools/documentation/cli/doc_cli.dart generate \
  --path lib/features/customers \
  --comprehensive \
  --bilingual \
  --include-examples \
  --include-details

# 3. مراجعة التغييرات
git diff lib/features/customers

# 4. التحقق من التحسين
dart lib/tools/documentation/cli/doc_cli.dart validate \
  --path lib/features/customers

# 5. إنشاء تقرير المقارنة
dart lib/tools/documentation/cli/doc_cli.dart report \
  --format markdown \
  --include-trends \
  --output improvement_report.md
```

### حالة 3: إصلاح PR مرفوض بسبب التوثيق

**السيناريو:** PR الخاص بك رُفض لأن التغطية أقل من 95%.

```bash
# 1. معرفة العناصر غير الموثقة
dart lib/tools/documentation/cli/doc_cli.dart analyze \
  --path lib/features/invoices \
  --json > undocumented.json

# 2. توليد التوثيق للعناصر المفقودة
dart lib/tools/documentation/cli/doc_cli.dart generate \
  --path lib/features/invoices \
  --comprehensive

# 3. التحقق من التغطية الجديدة
dart lib/tools/documentation/cli/doc_cli.dart analyze \
  --path lib/features/invoices

# 4. تحديث PR
git add .
git commit -m "docs: add missing documentation"
git push origin feature/invoices
```

### حالة 4: مراقبة جودة التوثيق بمرور الوقت

**السيناريو:** تريد تتبع تحسن التوثيق في المشروع.

```bash
# Script: monitor_documentation.sh
#!/bin/bash

# تشغيل أسبوعياً عبر cron
# 0 0 * * 0 /path/to/monitor_documentation.sh

DATE=$(date +%Y-%m-%d)

# 1. تحليل المشروع
dart lib/tools/documentation/cli/doc_cli.dart analyze \
  --json > "reports/analysis_$DATE.json"

# 2. إنشاء تقرير
dart lib/tools/documentation/cli/doc_cli.dart report \
  --format html \
  --include-trends \
  --output "reports/report_$DATE.html"

# 3. حساب الاتجاه
TREND=$(dart lib/tools/documentation/cli/doc_cli.dart trend)

# 4. إرسال إشعار إذا انخفضت التغطية
if [[ $TREND == *"declining"* ]]; then
  echo "⚠️ Documentation coverage is declining!" | \
    mail -s "Documentation Alert" team@example.com
fi

echo "✓ Weekly documentation report generated: reports/report_$DATE.html"
```

---

## التكامل مع CI/CD

### مثال 7: GitHub Actions - فحص شامل

```yaml
# .github/workflows/documentation_full.yml
name: Documentation Full Check

on:
  pull_request:
    branches: [main, develop]

jobs:
  documentation-check:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.24.0"

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze documentation
        id: analyze
        run: |
          dart lib/tools/documentation/cli/doc_cli.dart analyze \
            --json > analysis.json

          COVERAGE=$(jq '.coveragePercentage' analysis.json)
          echo "coverage=$COVERAGE" >> $GITHUB_OUTPUT

      - name: Generate documentation
        if: steps.analyze.outputs.coverage < 95
        run: |
          dart lib/tools/documentation/cli/doc_cli.dart generate \
            --comprehensive \
            --bilingual

      - name: Validate quality
        run: |
          dart lib/tools/documentation/cli/doc_cli.dart validate \
            --strict

      - name: Create report
        run: |
          dart lib/tools/documentation/cli/doc_cli.dart report \
            --format markdown \
            --output documentation_report.md

      - name: Upload report
        uses: actions/upload-artifact@v3
        with:
          name: documentation-report
          path: documentation_report.md

      - name: Comment on PR
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const report = fs.readFileSync('documentation_report.md', 'utf8');

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## 📚 Documentation Report\n\n${report}`
            });

      - name: Check coverage threshold
        run: |
          COVERAGE=$(jq '.coveragePercentage' analysis.json)
          if (( $(echo "$COVERAGE < 95" | bc -l) )); then
            echo "❌ Documentation coverage is below 95%: $COVERAGE%"
            exit 1
          fi
          echo "✅ Documentation coverage is sufficient: $COVERAGE%"
```

### مثال 8: GitLab CI - Pipeline متقدم

```yaml
# .gitlab-ci.yml
stages:
  - analyze
  - generate
  - validate
  - report

variables:
  FLUTTER_VERSION: "3.24.0"
  MIN_COVERAGE: "95"

.flutter_template:
  image: cirrusci/flutter:$FLUTTER_VERSION
  before_script:
    - flutter pub get

analyze_documentation:
  extends: .flutter_template
  stage: analyze
  script:
    - dart lib/tools/documentation/cli/doc_cli.dart analyze --json > analysis.json
    - COVERAGE=$(jq '.coveragePercentage' analysis.json)
    - echo "Current coverage: $COVERAGE%"
  artifacts:
    paths:
      - analysis.json
    expire_in: 1 week

generate_documentation:
  extends: .flutter_template
  stage: generate
  script:
    - COVERAGE=$(jq '.coveragePercentage' analysis.json)
    - |
      if (( $(echo "$COVERAGE < $MIN_COVERAGE" | bc -l) )); then
        echo "Generating missing documentation..."
        dart lib/tools/documentation/cli/doc_cli.dart generate --comprehensive
      else
        echo "Coverage is sufficient, skipping generation"
      fi
  dependencies:
    - analyze_documentation

validate_quality:
  extends: .flutter_template
  stage: validate
  script:
    - dart lib/tools/documentation/cli/doc_cli.dart validate --strict
  dependencies:
    - generate_documentation

create_report:
  extends: .flutter_template
  stage: report
  script:
    - dart lib/tools/documentation/cli/doc_cli.dart report --format html --output report.html
    - dart lib/tools/documentation/cli/doc_cli.dart report --format markdown --output report.md
  artifacts:
    paths:
      - report.html
      - report.md
    expire_in: 1 month
  dependencies:
    - validate_quality

check_threshold:
  extends: .flutter_template
  stage: report
  script:
    - COVERAGE=$(jq '.coveragePercentage' analysis.json)
    - |
      if (( $(echo "$COVERAGE < $MIN_COVERAGE" | bc -l) )); then
        echo "❌ Documentation coverage is below $MIN_COVERAGE%: $COVERAGE%"
        exit 1
      fi
    - echo "✅ Documentation coverage is sufficient: $COVERAGE%"
  dependencies:
    - analyze_documentation
```

---

## أمثلة البرمجة

### مثال 9: استخدام Analysis Engine برمجياً

```dart
// example_analysis_api.dart
import 'package:basser_mvp/tools/documentation/analysis/analysis_engine.dart';

Future<void> analyzeProject() async {
  final engine = AnalysisEngine();

  // تحليل مجلد واحد
  final results = await engine.analyzeDirectory('lib/features/auth');

  // معالجة النتائج
  for (final result in results) {
    print('\n📄 File: ${result.filePath}');
    print('Coverage: ${result.coveragePercentage.toStringAsFixed(2)}%');

    if (result.undocumentedElements.isNotEmpty) {
      print('\nUndocumented elements:');
      for (final element in result.undocumentedElements) {
        print('- ${element.type}: ${element.name} (line ${element.line})');
      }
    }
  }

  // حساب الإحصائيات الإجمالية
  final stats = await engine.getCoverageStats(results);

  print('\n📊 Overall Statistics:');
  print('Total: ${stats.totalElements}');
  print('Documented: ${stats.documentedElements}');
  print('Coverage: ${stats.coveragePercentage.toStringAsFixed(2)}%');
}
```

### مثال 10: استخدام Generation Engine برمجياً

```dart
// example_generation_api.dart
import 'package:basser_mvp/tools/documentation/generation/generation_engine.dart';
import 'package:basser_mvp/tools/documentation/analysis/analysis_engine.dart';

Future<void> generateDocumentation() async {
  final analyzer = AnalysisEngine();
  final generator = GenerationEngine();

  // 1. تحليل الملف
  final result = await analyzer.analyzeFile('lib/features/customers/customer.dart');

  // 2. إعداد خيارات التوليد
  final options = GenerationOptions.comprehensive;

  // 3. توليد التوثيق لكل عنصر
  final documentation = <String, String>{};

  for (final element in result.undocumentedElements) {
    final doc = await generator.generateDocumentation(element, options);
    documentation[element.name] = doc;

    print('Generated documentation for: ${element.name}');
    print(doc);
    print('---');
  }

  // 4. تطبيق التوثيق على الملف
  await generator.applyDocumentation(
    'lib/features/customers/customer.dart',
    documentation,
  );

  print('\n✓ Documentation applied successfully!');
}
```

### مثال 11: استخدام Validation Engine برمجياً

```dart
// example_validation_api.dart
import 'package:basser_mvp/tools/documentation/validation/validation_engine.dart';

Future<void> validateDocumentation() async {
  final engine = ValidationEngine();

  // التحقق من ملف واحد
  final result = await engine.validateFile('lib/features/auth/auth_service.dart');

  print('📄 File: ${result.filePath}');
  print('Valid: ${result.isValid}');
  print('Quality Score: ${result.qualityScore.score}/100 (${result.qualityScore.rating})');

  // عرض المشاكل
  if (result.issues.isNotEmpty) {
    print('\n⚠️ Issues Found:');
    for (final issue in result.issues) {
      final icon = issue.severity == IssueSeverity.error ? '❌' :
                    issue.severity == IssueSeverity.warning ? '⚠️' : 'ℹ️';
      print('$icon [${issue.severity}] ${issue.message}');
      if (issue.line != null) {
        print('   Line: ${issue.line}');
      }
      if (issue.suggestion != null) {
        print('   Suggestion: ${issue.suggestion}');
      }
    }
  }

  // التحقق من المشروع بالكامل
  final projectResult = await engine.validateProject('lib');

  print('\n📊 Project Validation:');
  print('Total Files: ${projectResult.fileResults.length}');
  print('Valid Files: ${projectResult.fileResults.where((f) => f.isValid).length}');
  print('Average Quality: ${projectResult.averageQuality.toStringAsFixed(2)}/100');
}
```

### مثال 12: استخدام Repository برمجياً

```dart
// example_repository_api.dart
import 'package:basser_mvp/tools/documentation/repository/documentation_repository.dart';
import 'package:basser_mvp/tools/documentation/analysis/analysis_engine.dart';

Future<void> manageReports() async {
  final repository = DocumentationRepository();
  final analyzer = AnalysisEngine();

  // 1. إنشاء تقرير جديد
  final results = await analyzer.analyzeDirectory('lib');
  final stats = await analyzer.getCoverageStats(results);

  final report = CoverageReport(
    timestamp: DateTime.now(),
    totalElements: stats.totalElements,
    documentedElements: stats.documentedElements,
    undocumentedElements: stats.undocumentedElements,
    coveragePercentage: stats.coveragePercentage,
    fileResults: results,
    notes: 'Weekly documentation check',
  );

  await repository.saveCoverageReport(report);
  print('✓ Report saved');

  // 2. استرجاع التاريخ
  final history = await repository.getCoverageHistory(limit: 10);

  print('\n📈 Coverage History:');
  for (final report in history) {
    print('${report.timestamp}: ${report.coveragePercentage.toStringAsFixed(2)}%');
  }

  // 3. حساب الاتجاه
  final trend = await repository.calculateTrend();

  print('\n📉 Trend Analysis:');
  print('Direction: ${trend.direction}');
  print('Change: ${trend.changePercentage.toStringAsFixed(2)}%');
  print('Period: ${trend.startDate} to ${trend.endDate}');

  // 4. تصدير تقرير
  final markdown = await repository.exportReport(
    report,
    ReportFormat.markdown,
  );

  print('\n📄 Markdown Report:');
  print(markdown);

  // 5. حذف التقارير القديمة
  final deleted = await repository.deleteOldReports(
    olderThan: Duration(days: 90),
  );

  print('\n🗑️ Deleted $deleted old reports');
}
```

---

## 💡 نصائح وحيل

### نصيحة 1: استخدام Aliases

```bash
# أضف إلى ~/.bashrc أو ~/.zshrc
alias doc-analyze='dart lib/tools/documentation/cli/doc_cli.dart analyze'
alias doc-generate='dart lib/tools/documentation/cli/doc_cli.dart generate'
alias doc-validate='dart lib/tools/documentation/cli/doc_cli.dart validate'
alias doc-report='dart lib/tools/documentation/cli/doc_cli.dart report'

# الاستخدام:
doc-analyze --path lib/features/auth
doc-generate --comprehensive
doc-validate --strict
doc-report --format html
```

### نصيحة 2: Pre-commit Hook

```bash
# .git/hooks/pre-commit
#!/bin/bash

echo "🔍 Checking documentation coverage..."

# تحليل الملفات المعدلة فقط
CHANGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.dart$')

if [ -z "$CHANGED_FILES" ]; then
  echo "✓ No Dart files changed"
  exit 0
fi

# تحليل كل ملف معدل
for file in $CHANGED_FILES; do
  COVERAGE=$(dart lib/tools/documentation/cli/doc_cli.dart analyze --path "$file" --json | jq '.coveragePercentage')

  if (( $(echo "$COVERAGE < 95" | bc -l) )); then
    echo "❌ $file has insufficient documentation coverage: $COVERAGE%"
    echo "Run: dart lib/tools/documentation/cli/doc_cli.dart generate --path $file"
    exit 1
  fi
done

echo "✓ All files have sufficient documentation coverage"
exit 0
```

### نصيحة 3: VS Code Task

```json
// .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Analyze Documentation",
      "type": "shell",
      "command": "dart",
      "args": [
        "lib/tools/documentation/cli/doc_cli.dart",
        "analyze",
        "--path",
        "${file}"
      ],
      "group": "test",
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "label": "Generate Documentation",
      "type": "shell",
      "command": "dart",
      "args": [
        "lib/tools/documentation/cli/doc_cli.dart",
        "generate",
        "--path",
        "${file}",
        "--comprehensive"
      ],
      "group": "build"
    }
  ]
}
```

---

## 📚 المزيد من الموارد

- [دليل المستخدم الكامل](USER_GUIDE.md)
- [وثائق API](API_DOCUMENTATION.md)
- [أسئلة شائعة](FAQ.md)
- [استكشاف الأخطاء](TROUBLESHOOTING.md)

---

**الإصدار:** 1.0.0  
**تاريخ التحديث:** 28 نوفمبر 2025  
**المؤلف:** فريق بصير MVP
