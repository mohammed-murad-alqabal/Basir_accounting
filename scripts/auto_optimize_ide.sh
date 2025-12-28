#!/bin/bash

# سكريبت التحسين التلقائي لمحرر الأكواد
# المؤلف: فريق وكلاء تطوير مشروع بصير

echo "🔧 بدء التحسين التلقائي..."

# 1. تنظيف الذاكرة
echo "🧹 تنظيف الذاكرة..."
sync
echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

# 2. إيقاف العمليات غير الضرورية
echo "🛑 إيقاف العمليات غير الضرورية..."

# قائمة العمليات التي يمكن إيقافها مؤقتاً
UNNECESSARY_PROCESSES="
    snapd
    packagekit
    update-notifier
    gnome-software
    evolution
    thunderbird
    firefox
    chrome
    spotify
"

for process in $UNNECESSARY_PROCESSES; do
    pkill -STOP $process 2>/dev/null
done

# 3. تحسين عمليات محرر الأكواد
echo "⚡ تحسين عمليات محرر الأكواد..."

IDE_PROCESSES=$(pgrep -f "code|vscode|kiro|cursor")

if [ ! -z "$IDE_PROCESSES" ]; then
    for pid in $IDE_PROCESSES; do
        # أولوية CPU عالية جداً
        sudo renice -15 $pid 2>/dev/null
        
        # أولوية I/O عالية جداً
        sudo ionice -c 1 -n 0 -p $pid 2>/dev/null
        
        # تخصيص CPU cores محددة (اختياري)
        # sudo taskset -cp 0-3 $pid 2>/dev/null
    done
    echo "✅ تم تحسين ${#IDE_PROCESSES[@]} عملية"
else
    echo "⚠️  لم يتم العثور على محرر أكواد نشط"
fi

# 4. تحسين Flutter/Dart processes
echo "🎯 تحسين عمليات Flutter/Dart..."

FLUTTER_PROCESSES=$(pgrep -f "flutter|dart|gradle")

if [ ! -z "$FLUTTER_PROCESSES" ]; then
    for pid in $FLUTTER_PROCESSES; do
        sudo renice -10 $pid 2>/dev/null
        sudo ionice -c 2 -n 0 -p $pid 2>/dev/null
    done
    echo "✅ تم تحسين عمليات Flutter/Dart"
fi

# 5. تحسين Git operations
echo "📦 تحسين عمليات Git..."
git config --global core.preloadindex true
git config --global core.fscache true
git config --global gc.auto 256

# 6. عرض النتائج
echo ""
echo "✅ اكتمل التحسين التلقائي!"
echo "📊 الحالة الحالية:"
echo "  - الذاكرة المتاحة: $(free -h | awk '/^Mem:/ {print $7}')"
echo "  - استخدام CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
echo "  - عمليات محرر الأكواد: $(pgrep -f "code|vscode|kiro" | wc -l)"

echo ""
echo "💡 نصيحة: شغّل هذا السكريبت كل ساعة للحفاظ على الأداء الأمثل"