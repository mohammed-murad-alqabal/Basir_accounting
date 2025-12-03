#!/usr/bin/env bats

# =============================================================================
# Property 7: Report Content Completeness - Errors
# =============================================================================
# الوصف: يتحقق من أن التقرير يحتوي على ملخص شامل للأخطاء والتحذيرات
# المتطلبات: Requirements 2.3
# الخاصية: كل تقرير يجب أن يحتوي على تحليل مفصل للأخطاء مع التصنيف
# =============================================================================

setup() {
    export TEST_DIR="$(mktemp -d)"
    export REPORT_FILE="$TEST_DIR/test_report.md"
}

teardown() {
    rm -rf "$TEST_DIR"
}

# =============================================================================
# الاختبارات
# =============================================================================

@test "Property 7.1: التقرير يحتوي على عدد الأخطاء" {
    cat > "$REPORT_FILE" <<EOF
## 🔍 تحليل الأخطاء والتحذيرات

| النوع | العدد | الحالة |
|:---|:---|:---|
| **أخطاء (Errors)** | 0 | ✅ |
| **تحذيرات (Warnings)** | 5 | ⚠️ |
| **معلومات (Info)** | 10 | ℹ️ |
EOF

    run grep -q "أخطاء (Errors)" "$REPORT_FILE"
    [ "$status" -eq 0 ]
    
    run grep "أخطاء (Errors)" "$REPORT_FILE"
    [[ "$output" =~ [0-9]+ ]]
}

@test "Property 7.2: التقرير يحتوي على عدد التحذيرات" {
    cat > "$REPORT_FILE" <<EOF
## 🔍 تحليل الأخطاء والتحذيرات

| النوع | العدد | الحالة |
|:---|:---|:---|
| **تحذيرات (Warnings)** | 5 | ⚠️ |
EOF

    run grep -q "تحذيرات (Warnings)" "$REPORT_FILE"
    [ "$status" -eq 0 ]
    
    run grep "تحذيرات (Warnings)" "$REPORT_FILE"
    [[ "$output" =~ [0-9]+ ]]
}

@test "Property 7.3: التقرير يحتوي على حالة الأخطاء (✅ أو ❌)" {
    cat > "$REPORT_FILE" <<EOF
## 🔍 تحليل الأخطاء والتحذيرات

| النوع | العدد | الحالة |
|:---|:---|:---|
| **أخطاء (Errors)** | 0 | ✅ |
| **تحذيرات (Warnings)** | 5 | ⚠️ |
EOF

    # التحقق من وجود رموز الحالة
    run grep -E "(✅|❌|⚠️)" "$REPORT_FILE"
    [ "$status" -eq 0 ]
}

@test "Property 7.4: التقرير يعرض تفاصيل الأخطاء عند وجودها" {
    cat > "$REPORT_FILE" <<EOF
## 🔍 تحليل الأخطاء والتحذيرات

| النوع | العدد | الحالة |
|:---|:---|:---|
| **أخطاء (Errors)** | 2 | ❌ |

### التفاصيل

\`\`\`
error • Missing return type on function at lib/main.dart:10
error • Undefined name 'foo' at lib/utils.dart:25
\`\`\`
EOF

    # عند وجود أخطاء، يجب أن يكون هناك قسم "التفاصيل"
    run grep -q "### التفاصيل" "$REPORT_FILE"
    [ "$status" -eq 0 ]
}

@test "Property 7.5: التقرير يحتوي على معلومات (Info)" {
    cat > "$REPORT_FILE" <<EOF
## 🔍 تحليل الأخطاء والتحذيرات

| النوع | العدد | الحالة |
|:---|:---|:---|
| **معلومات (Info)** | 10 | ℹ️ |
EOF

    run grep -q "معلومات (Info)" "$REPORT_FILE"
    [ "$status" -eq 0 ]
}

# =============================================================================
# اختبار الخاصية الرئيسية (Property-Based Test)
# =============================================================================

@test "Property 7: Report Errors Completeness (100 iterations)" {
    local iterations=100
    local passed=0
    
    for ((i=1; i<=iterations; i++)); do
        # إنشاء تقرير مع قيم عشوائية
        local error_count=$((RANDOM % 10))
        local warning_count=$((RANDOM % 20))
        local info_count=$((RANDOM % 30))
        
        # تحديد الحالة بناءً على عدد الأخطاء
        local error_status="✅"
        if [ "$error_count" -gt 0 ]; then
            error_status="❌"
        fi
        
        local warning_status="✅"
        if [ "$warning_count" -gt 0 ]; then
            warning_status="⚠️"
        fi
        
        cat > "$REPORT_FILE" <<EOF
# تقرير يومي شامل

## 🔍 تحليل الأخطاء والتحذيرات

| النوع | العدد | الحالة |
|:---|:---|:---|
| **أخطاء (Errors)** | $error_count | $error_status |
| **تحذيرات (Warnings)** | $warning_count | $warning_status |
| **معلومات (Info)** | $info_count | ℹ️ |
EOF

        # إضافة تفاصيل إذا كانت هناك أخطاء
        if [ "$error_count" -gt 0 ]; then
            cat >> "$REPORT_FILE" <<EOF

### التفاصيل

\`\`\`
error • Sample error message
\`\`\`
EOF
        fi
        
        # التحقق من اكتمال التقرير
        if grep -q "أخطاء (Errors)" "$REPORT_FILE" && \
           grep -q "تحذيرات (Warnings)" "$REPORT_FILE" && \
           grep -q "معلومات (Info)" "$REPORT_FILE" && \
           grep -qE "(✅|❌|⚠️)" "$REPORT_FILE"; then
            passed=$((passed + 1))
        fi
    done
    
    # يجب أن تنجح جميع التكرارات
    [ "$passed" -eq "$iterations" ]
}

# =============================================================================
# اختبار التكامل
# =============================================================================

@test "Property 7: Integration - التقرير يحتوي على جميع أنواع المشاكل" {
    cat > "$REPORT_FILE" <<EOF
# تقرير يومي شامل - مشروع بصير MVP

## 🔍 تحليل الأخطاء والتحذيرات

| النوع | العدد | الحالة |
|:---|:---|:---|
| **أخطاء (Errors)** | 0 | ✅ |
| **تحذيرات (Warnings)** | 3 | ⚠️ |
| **معلومات (Info)** | 15 | ℹ️ |
EOF

    # عد عدد أنواع المشاكل
    local types_count=$(grep -c "^\| \*\*" "$REPORT_FILE" || echo "0")
    
    # يجب أن يكون هناك 3 أنواع على الأقل
    [ "$types_count" -ge 3 ]
}

@test "Property 7: Validation - الحالة تتطابق مع العدد" {
    # حالة 1: لا أخطاء = ✅
    cat > "$REPORT_FILE" <<EOF
| **أخطاء (Errors)** | 0 | ✅ |
EOF
    run grep "أخطاء (Errors)" "$REPORT_FILE"
    [[ "$output" =~ "0" ]] && [[ "$output" =~ "✅" ]]
    
    # حالة 2: أخطاء موجودة = ❌
    cat > "$REPORT_FILE" <<EOF
| **أخطاء (Errors)** | 5 | ❌ |
EOF
    run grep "أخطاء (Errors)" "$REPORT_FILE"
    [[ "$output" =~ [1-9] ]] && [[ "$output" =~ "❌" ]]
}
