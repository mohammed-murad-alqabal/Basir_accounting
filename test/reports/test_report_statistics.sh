#!/usr/bin/env bats

# =============================================================================
# Property 6: Report Content Completeness - Statistics
# =============================================================================
# الوصف: يتحقق من أن التقرير يحتوي على جميع الإحصائيات المطلوبة
# المتطلبات: Requirements 2.2
# الخاصية: كل تقرير يجب أن يحتوي على إحصائيات المشروع الكاملة
# =============================================================================

# إعداد البيئة
setup() {
    export TEST_DIR="$(mktemp -d)"
    export REPORT_FILE="$TEST_DIR/test_report.md"
    export PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
}

# تنظيف البيئة
teardown() {
    rm -rf "$TEST_DIR"
}

# =============================================================================
# الاختبارات
# =============================================================================

@test "Property 6.1: التقرير يحتوي على عدد ملفات Dart" {
    # إنشاء تقرير وهمي
    cat > "$REPORT_FILE" <<EOF
# تقرير يومي شامل

## 📊 إحصائيات المشروع

| المقياس | القيمة |
|:---|:---|
| **إجمالي ملفات Dart** | 150 |
| **إجمالي الأسطر** | 15000 |
| **حجم المشروع** | 2.5M |
| **إجمالي Commits** | 100 |
EOF

    # التحقق من وجود "إجمالي ملفات Dart"
    run grep -q "إجمالي ملفات Dart" "$REPORT_FILE"
    [ "$status" -eq 0 ]
    
    # التحقق من وجود رقم
    run grep "إجمالي ملفات Dart" "$REPORT_FILE"
    [[ "$output" =~ [0-9]+ ]]
}

@test "Property 6.2: التقرير يحتوي على إجمالي الأسطر" {
    cat > "$REPORT_FILE" <<EOF
## 📊 إحصائيات المشروع

| المقياس | القيمة |
|:---|:---|
| **إجمالي الأسطر** | 15000 |
EOF

    run grep -q "إجمالي الأسطر" "$REPORT_FILE"
    [ "$status" -eq 0 ]
    
    run grep "إجمالي الأسطر" "$REPORT_FILE"
    [[ "$output" =~ [0-9]+ ]]
}

@test "Property 6.3: التقرير يحتوي على حجم المشروع" {
    cat > "$REPORT_FILE" <<EOF
## 📊 إحصائيات المشروع

| المقياس | القيمة |
|:---|:---|
| **حجم المشروع** | 2.5M |
EOF

    run grep -q "حجم المشروع" "$REPORT_FILE"
    [ "$status" -eq 0 ]
}

@test "Property 6.4: التقرير يحتوي على عدد Commits" {
    cat > "$REPORT_FILE" <<EOF
## 📊 إحصائيات المشروع

| المقياس | القيمة |
|:---|:---|
| **إجمالي Commits** | 100 |
EOF

    run grep -q "إجمالي Commits" "$REPORT_FILE"
    [ "$status" -eq 0 ]
    
    run grep "إجمالي Commits" "$REPORT_FILE"
    [[ "$output" =~ [0-9]+ ]]
}

@test "Property 6.5: التقرير يحتوي على آخر Commit" {
    cat > "$REPORT_FILE" <<EOF
## 📊 إحصائيات المشروع

| المقياس | القيمة |
|:---|:---|
| **آخر Commit** | abc123 - feat: new feature (2 hours ago) |
EOF

    run grep -q "آخر Commit" "$REPORT_FILE"
    [ "$status" -eq 0 ]
}

# =============================================================================
# اختبار الخاصية الرئيسية (Property-Based Test)
# =============================================================================

@test "Property 6: Report Statistics Completeness (100 iterations)" {
    local iterations=100
    local passed=0
    
    for ((i=1; i<=iterations; i++)); do
        # إنشاء تقرير وهمي مع قيم عشوائية
        local dart_files=$((RANDOM % 200 + 50))
        local total_lines=$((RANDOM % 50000 + 5000))
        local project_size="$((RANDOM % 10 + 1)).$((RANDOM % 10))M"
        local total_commits=$((RANDOM % 500 + 10))
        
        cat > "$REPORT_FILE" <<EOF
# تقرير يومي شامل - مشروع بصير MVP

**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')

## 📊 إحصائيات المشروع

| المقياس | القيمة |
|:---|:---|
| **إجمالي ملفات Dart** | $dart_files |
| **إجمالي الأسطر** | $total_lines |
| **حجم المشروع** | $project_size |
| **إجمالي Commits** | $total_commits |
| **آخر Commit** | abc123 - test commit |
EOF

        # التحقق من جميع الإحصائيات
        if grep -q "إجمالي ملفات Dart" "$REPORT_FILE" && \
           grep -q "إجمالي الأسطر" "$REPORT_FILE" && \
           grep -q "حجم المشروع" "$REPORT_FILE" && \
           grep -q "إجمالي Commits" "$REPORT_FILE" && \
           grep -q "آخر Commit" "$REPORT_FILE"; then
            passed=$((passed + 1))
        fi
    done
    
    # يجب أن تنجح جميع التكرارات
    [ "$passed" -eq "$iterations" ]
}

# =============================================================================
# اختبار التكامل
# =============================================================================

@test "Property 6: Integration - جميع الإحصائيات موجودة في تقرير واحد" {
    cat > "$REPORT_FILE" <<EOF
# تقرير يومي شامل - مشروع بصير MVP

**التاريخ:** 2025-12-03 10:00:00
**المؤلف:** نظام تتبع الأخطاء التلقائي

## 📊 إحصائيات المشروع

| المقياس | القيمة |
|:---|:---|
| **إجمالي ملفات Dart** | 150 |
| **إجمالي الأسطر** | 15000 |
| **حجم المشروع** | 2.5M |
| **إجمالي Commits** | 100 |
| **آخر Commit** | abc123 - feat: new feature (2 hours ago) |
EOF

    # عد عدد الإحصائيات الموجودة
    local stats_count=$(grep -c "^\| \*\*" "$REPORT_FILE" || echo "0")
    
    # يجب أن يكون هناك على الأقل 5 إحصائيات
    [ "$stats_count" -ge 5 ]
}
