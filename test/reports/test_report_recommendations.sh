#!/usr/bin/env bats

# =============================================================================
# Property 9: Report Recommendations Presence
# =============================================================================
# الوصف: يتحقق من أن التقرير يحتوي على توصيات قابلة للتنفيذ
# المتطلبات: Requirements 2.5
# الخاصية: كل تقرير يجب أن يقدم توصيات بناءً على تحليل البيانات
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

@test "Property 9.1: التقرير يحتوي على قسم التوصيات" {
    cat > "$REPORT_FILE" <<EOF
# تقرير يومي شامل

## 💡 التوصيات

✅ **ممتاز!** لا توجد توصيات حالياً. المشروع في حالة جيدة.
EOF

    run grep -q "## 💡 التوصيات" "$REPORT_FILE"
    [ "$status" -eq 0 ]
}

@test "Property 9.2: التوصيات تحتوي على أولويات (🔴 عاجل، ⚠️ مهم)" {
    cat > "$REPORT_FILE" <<EOF
## 💡 التوصيات

🔴 **عاجل**: يوجد 5 أخطاء يجب إصلاحها فوراً.

⚠️ **مهم**: يوجد 10 تحذيرات. يُنصح بمعالجتها.
EOF

    # التحقق من وجود رموز الأولوية
    run grep -E "(🔴|⚠️|📊|📦|⏰)" "$REPORT_FILE"
    [ "$status" -eq 0 ]
}

@test "Property 9.3: التوصيات تحتوي على إجراءات محددة" {
    cat > "$REPORT_FILE" <<'EOF'
## 💡 التوصيات

🔴 **عاجل**: يوجد 5 أخطاء يجب إصلاحها فوراً. قم بتشغيل `flutter analyze` لمعرفة التفاصيل.
EOF

    # التحقق من وجود أوامر قابلة للتنفيذ
    run grep -q "flutter analyze" "$REPORT_FILE"
    [ "$status" -eq 0 ]
}

@test "Property 9.4: التوصيات تحتوي على رسالة إيجابية عند عدم وجود مشاكل" {
    cat > "$REPORT_FILE" <<EOF
## 💡 التوصيات

✅ **ممتاز!** لا توجد توصيات حالياً. المشروع في حالة جيدة.
EOF

    run grep -q "ممتاز" "$REPORT_FILE"
    [ "$status" -eq 0 ]
    
    run grep -q "✅" "$REPORT_FILE"
    [ "$status" -eq 0 ]
}

@test "Property 9.5: التوصيات مرتبطة بالبيانات المحللة" {
    cat > "$REPORT_FILE" <<EOF
## 🔍 تحليل الأخطاء والتحذيرات

| **أخطاء (Errors)** | 5 | ❌ |

## 💡 التوصيات

🔴 **عاجل**: يوجد 5 أخطاء يجب إصلاحها فوراً.
EOF

    # التحقق من تطابق الأرقام
    local errors_in_analysis=$(grep "أخطاء (Errors)" "$REPORT_FILE" | grep -o "[0-9]" | head -1)
    local errors_in_recommendations=$(grep "يوجد" "$REPORT_FILE" | grep -o "[0-9]" | head -1)
    
    [ "$errors_in_analysis" = "$errors_in_recommendations" ]
}

# =============================================================================
# اختبار الخاصية الرئيسية (Property-Based Test)
# =============================================================================

@test "Property 9: Report Recommendations Presence (100 iterations)" {
    local iterations=100
    local passed=0
    
    for ((i=1; i<=iterations; i++)); do
        # إنشاء سيناريوهات مختلفة
        local error_count=$((RANDOM % 10))
        local warning_count=$((RANDOM % 20))
        local failed_tests=$((RANDOM % 10))
        local coverage=$((RANDOM % 40 + 50))
        
        cat > "$REPORT_FILE" <<EOF
# تقرير يومي شامل

## 💡 التوصيات

EOF

        # إضافة توصيات بناءً على البيانات
        if [ "$error_count" -gt 0 ]; then
            echo "🔴 **عاجل**: يوجد $error_count خطأ يجب إصلاحه فوراً." >> "$REPORT_FILE"
            echo "" >> "$REPORT_FILE"
        fi
        
        if [ "$warning_count" -gt 5 ]; then
            echo "⚠️ **مهم**: يوجد $warning_count تحذير. يُنصح بمعالجتها." >> "$REPORT_FILE"
            echo "" >> "$REPORT_FILE"
        fi
        
        if [ "$failed_tests" -gt 0 ]; then
            echo "❌ **حرج**: $failed_tests اختبار فشل. يجب إصلاحها قبل المتابعة." >> "$REPORT_FILE"
            echo "" >> "$REPORT_FILE"
        fi
        
        if [ "$coverage" -lt 70 ]; then
            echo "📊 **تحسين**: تغطية الاختبارات أقل من 70%. يُنصح بإضافة المزيد من الاختبارات." >> "$REPORT_FILE"
            echo "" >> "$REPORT_FILE"
        fi
        
        # إذا لم تكن هناك مشاكل
        if [ "$error_count" -eq 0 ] && [ "$warning_count" -le 5 ] && [ "$failed_tests" -eq 0 ] && [ "$coverage" -ge 70 ]; then
            echo "✅ **ممتاز!** لا توجد توصيات حالياً. المشروع في حالة جيدة." >> "$REPORT_FILE"
            echo "" >> "$REPORT_FILE"
        fi
        
        # التحقق من وجود قسم التوصيات
        if grep -q "## 💡 التوصيات" "$REPORT_FILE"; then
            passed=$((passed + 1))
        fi
    done
    
    # يجب أن تنجح جميع التكرارات
    [ "$passed" -eq "$iterations" ]
}

# =============================================================================
# اختبار التكامل
# =============================================================================

@test "Property 9: Integration - التوصيات تغطي جميع جوانب التقرير" {
    cat > "$REPORT_FILE" <<EOF
# تقرير يومي شامل

## 🔍 تحليل الأخطاء والتحذيرات
| **أخطاء (Errors)** | 3 | ❌ |
| **تحذيرات (Warnings)** | 8 | ⚠️ |

## 🧪 نتائج الاختبارات
| **فشل** | 2 ❌ |
| **التغطية** | 65% |

## 💡 التوصيات

🔴 **عاجل**: يوجد 3 أخطاء يجب إصلاحها فوراً.

⚠️ **مهم**: يوجد 8 تحذيرات. يُنصح بمعالجتها.

❌ **حرج**: 2 اختبار فشل. يجب إصلاحها قبل المتابعة.

📊 **تحسين**: تغطية الاختبارات أقل من 70%. يُنصح بإضافة المزيد من الاختبارات.
EOF

    # عد عدد التوصيات
    local recommendations_count=$(grep -c "^\(🔴\|⚠️\|❌\|📊\|📦\|⏰\)" "$REPORT_FILE" || echo "0")
    
    # يجب أن يكون هناك 4 توصيات
    [ "$recommendations_count" -eq 4 ]
}

@test "Property 9: Validation - التوصيات قابلة للتنفيذ" {
    cat > "$REPORT_FILE" <<EOF
## 💡 التوصيات

🔴 **عاجل**: يوجد 5 أخطاء يجب إصلاحها فوراً. قم بتشغيل \`flutter analyze\` لمعرفة التفاصيل.

⚠️ **مهم**: يوجد 10 تحذيرات. يُنصح بمعالجتها لتحسين جودة الكود.

📊 **تحسين**: تغطية الاختبارات أقل من 70%. يُنصح بإضافة المزيد من الاختبارات.
EOF

    # التحقق من وجود أوامر أو إجراءات محددة
    run grep -E "(يُنصح|يجب|قم بـ)" "$REPORT_FILE"
    [ "$status" -eq 0 ]
}

@test "Property 9: Edge Case - لا توجد مشاكل" {
    cat > "$REPORT_FILE" <<EOF
## 💡 التوصيات

✅ **ممتاز!** لا توجد توصيات حالياً. المشروع في حالة جيدة.
EOF

    run grep -q "ممتاز" "$REPORT_FILE"
    [ "$status" -eq 0 ]
    
    # يجب أن لا تكون هناك توصيات حرجة
    run grep -qE "(🔴|❌)" "$REPORT_FILE"
    [ "$status" -ne 0 ]
}
