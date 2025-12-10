#!/bin/bash

# سكريبت مراقبة أداء النظام
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 5 ديسمبر 2025

echo "📊 مراقبة أداء النظام - مشروع بصير"
echo "========================================"
echo ""

# معلومات النظام
echo "💻 معلومات النظام:"
echo "   النظام: $(uname -s)"
echo "   الإصدار: $(uname -r)"
echo "   المعمارية: $(uname -m)"
echo ""

# CPU Usage
echo "🔥 استخدام المعالج (CPU):"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
echo "   المستخدم: ${CPU_USAGE}%"
echo ""

# Memory Usage
echo "💾 استخدام الذاكرة (RAM):"
MEM_INFO=$(free -h | grep "Mem:")
MEM_TOTAL=$(echo $MEM_INFO | awk '{print $2}')
MEM_USED=$(echo $MEM_INFO | awk '{print $3}')
MEM_PERCENT=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
echo "   المستخدم: $MEM_USED / $MEM_TOTAL (${MEM_PERCENT}%)"
echo ""

# Disk Usage
echo "💿 استخدام القرص:"
DISK_INFO=$(df -h . | tail -1)
DISK_TOTAL=$(echo $DISK_INFO | awk '{print $2}')
DISK_USED=$(echo $DISK_INFO | awk '{print $3}')
DISK_PERCENT=$(echo $DISK_INFO | awk '{print $5}')
echo "   المستخدم: $DISK_USED / $DISK_TOTAL ($DISK_PERCENT)"
echo ""

# Load Average
echo "⚡ Load Average:"
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}')
echo "   $LOAD_AVG"
echo ""

# Top Processes by CPU
echo "🔝 أكثر 5 عمليات استهلاكاً للـ CPU:"
ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "   %-20s: %5.1f%% CPU, %5.1f%% MEM\n", substr($11,1,20), $3, $4}'
echo ""

# Top Processes by Memory
echo "💾 أكثر 5 عمليات استهلاكاً للذاكرة:"
ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "   %-20s: %5.1f%% MEM, %5.1f%% CPU\n", substr($11,1,20), $4, $3}'
echo ""

# Project Size
echo "📦 حجم المشروع:"
if [ -d "." ]; then
    TOTAL_SIZE=$(du -sh . 2>/dev/null | awk '{print $1}')
    echo "   الإجمالي: $TOTAL_SIZE"
    
    if [ -d "build" ]; then
        BUILD_SIZE=$(du -sh build 2>/dev/null | awk '{print $1}')
        echo "   build/: $BUILD_SIZE"
    fi
    
    if [ -d "lib" ]; then
        LIB_SIZE=$(du -sh lib 2>/dev/null | awk '{print $1}')
        echo "   lib/: $LIB_SIZE"
    fi
    
    if [ -d "test" ]; then
        TEST_SIZE=$(du -sh test 2>/dev/null | awk '{print $1}')
        echo "   test/: $TEST_SIZE"
    fi
fi
echo ""

# Flutter Doctor
echo "🎯 حالة Flutter:"
FLUTTER_VERSION=$(flutter --version 2>&1 | head -1 | awk '{print $2}')
DART_VERSION=$(dart --version 2>&1 | awk '{print $4}')
echo "   Flutter: $FLUTTER_VERSION"
echo "   Dart: $DART_VERSION"
echo ""

# Git Status
echo "📝 حالة Git:"
if [ -d ".git" ]; then
    MODIFIED=$(git status --short | grep "^ M" | wc -l)
    UNTRACKED=$(git status --short | grep "^??" | wc -l)
    BRANCH=$(git branch --show-current)
    echo "   الفرع: $BRANCH"
    echo "   ملفات معدلة: $MODIFIED"
    echo "   ملفات جديدة: $UNTRACKED"
else
    echo "   ℹ️  ليس مستودع Git"
fi
echo ""

# Performance Score
echo "🎯 تقييم الأداء:"
SCORE=100

# تقليل النقاط بناءً على الاستخدام
if (( $(echo "$MEM_PERCENT > 80" | bc -l) )); then
    SCORE=$((SCORE - 20))
    echo "   ⚠️  استخدام الذاكرة مرتفع (>80%)"
elif (( $(echo "$MEM_PERCENT > 60" | bc -l) )); then
    SCORE=$((SCORE - 10))
    echo "   ⚠️  استخدام الذاكرة متوسط (>60%)"
fi

DISK_NUM=$(echo $DISK_PERCENT | tr -d '%')
if [ "$DISK_NUM" -gt 80 ]; then
    SCORE=$((SCORE - 20))
    echo "   ⚠️  استخدام القرص مرتفع (>80%)"
elif [ "$DISK_NUM" -gt 60 ]; then
    SCORE=$((SCORE - 10))
    echo "   ⚠️  استخدام القرص متوسط (>60%)"
fi

if [ -d "build" ] && [ "$(du -s build 2>/dev/null | awk '{print $1}')" -gt 1000000 ]; then
    SCORE=$((SCORE - 15))
    echo "   ⚠️  مجلد build كبير (>1GB)"
fi

if [ "$MODIFIED" -gt 20 ]; then
    SCORE=$((SCORE - 10))
    echo "   ⚠️  عدد كبير من الملفات المعدلة (>20)"
fi

echo ""
echo "   النتيجة النهائية: $SCORE/100"

if [ "$SCORE" -ge 80 ]; then
    echo "   ✅ الأداء ممتاز!"
elif [ "$SCORE" -ge 60 ]; then
    echo "   ⚠️  الأداء جيد، يمكن تحسينه"
else
    echo "   ❌ الأداء يحتاج تحسين فوري!"
    echo ""
    echo "💡 توصيات:"
    echo "   • قم بتشغيل ./scripts/cleanup.sh"
    echo "   • أغلق التطبيقات غير المستخدمة"
    echo "   • احفظ التغييرات في Git"
fi

echo ""
echo "========================================"
echo "📅 التاريخ: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
