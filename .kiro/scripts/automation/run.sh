#!/bin/bash
# سكريبت تشغيل نظام الأتمتة الذكي للوكلاء
# المشروع: بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 5 ديسمبر 2025

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# المسار الأساسي
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# دالة عرض الرسالة
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# دالة عرض العنوان
print_header() {
    echo ""
    echo "=========================================="
    echo "🤖 نظام الأتمتة الذكي للوكلاء"
    echo "   Intelligent Agents Automation System"
    echo "=========================================="
    echo ""
}

# دالة التحقق من Python
check_python() {
    if ! command -v python3 &> /dev/null; then
        print_message "$RED" "❌ Python 3 غير مثبت!"
        print_message "$YELLOW" "   يرجى تثبيت Python 3.8 أو أحدث"
        exit 1
    fi
    
    local python_version=$(python3 --version | cut -d' ' -f2)
    print_message "$GREEN" "✅ Python $python_version"
}

# دالة التحقق من المتطلبات
check_requirements() {
    if [ ! -f "requirements.txt" ]; then
        print_message "$RED" "❌ ملف requirements.txt غير موجود!"
        exit 1
    fi
    
    print_message "$BLUE" "📦 التحقق من المتطلبات..."
    
    # التحقق من وجود البيئة الافتراضية
    if [ ! -d "venv" ]; then
        print_message "$YELLOW" "⚠️  البيئة الافتراضية غير موجودة"
        print_message "$BLUE" "📦 إنشاء بيئة افتراضية..."
        python3 -m venv venv
        print_message "$GREEN" "✅ تم إنشاء البيئة الافتراضية"
    fi
    
    # تفعيل البيئة الافتراضية
    source venv/bin/activate
    
    # تثبيت المتطلبات
    print_message "$BLUE" "📦 تثبيت المتطلبات..."
    pip install -q --upgrade pip
    pip install -q -r requirements.txt
    print_message "$GREEN" "✅ تم تثبيت جميع المتطلبات"
}

# دالة إنشاء المجلدات
create_directories() {
    print_message "$BLUE" "📁 إنشاء المجلدات المطلوبة..."
    
    mkdir -p logs
    mkdir -p logs/alerts
    mkdir -p logs/reports
    mkdir -p logs/metrics
    
    print_message "$GREEN" "✅ تم إنشاء المجلدات"
}

# دالة التحقق من التكوين
check_config() {
    if [ ! -f "config.yaml" ]; then
        print_message "$YELLOW" "⚠️  ملف config.yaml غير موجود"
        print_message "$BLUE" "📝 استخدام التكوينات الافتراضية"
    else
        print_message "$GREEN" "✅ ملف التكوين موجود"
    fi
}

# دالة تشغيل النظام
start_system() {
    print_header
    
    print_message "$BLUE" "🚀 بدء نظام الأتمتة الذكي..."
    echo ""
    
    # تفعيل البيئة الافتراضية
    source venv/bin/activate
    
    # تشغيل النظام
    python3 main.py
}

# دالة إيقاف النظام
stop_system() {
    print_message "$YELLOW" "⏹️  إيقاف النظام..."
    
    # البحث عن العملية
    local pid=$(pgrep -f "python3 main.py")
    
    if [ -n "$pid" ]; then
        kill -SIGTERM "$pid"
        print_message "$GREEN" "✅ تم إيقاف النظام (PID: $pid)"
    else
        print_message "$YELLOW" "⚠️  النظام غير قيد التشغيل"
    fi
}

# دالة عرض الحالة
show_status() {
    print_header
    
    # التحقق من التشغيل
    local pid=$(pgrep -f "python3 main.py")
    
    if [ -n "$pid" ]; then
        print_message "$GREEN" "✅ النظام يعمل (PID: $pid)"
        
        # عرض معلومات إضافية
        if [ -f "logs/dashboard.json" ]; then
            print_message "$BLUE" "\n📊 آخر حالة:"
            python3 -c "
import json
with open('logs/dashboard.json', 'r') as f:
    data = json.load(f)
    print(f\"  الوقت: {data.get('timestamp', 'N/A')}\")
    print(f\"  الوكلاء النشطون: {data.get('agents', {})}\")
    print(f\"  حجم قائمة المهام: {data.get('task_queue_size', 0)}\")
    print(f\"  صحة النظام: {data.get('system_health', 0):.1f}%\")
"
        fi
    else
        print_message "$RED" "❌ النظام غير قيد التشغيل"
    fi
    
    echo ""
}

# دالة عرض السجلات
show_logs() {
    if [ -f "logs/main.log" ]; then
        print_message "$BLUE" "📋 آخر 20 سطر من السجل:"
        echo ""
        tail -n 20 logs/main.log
    else
        print_message "$YELLOW" "⚠️  لا توجد سجلات"
    fi
}

# دالة التنظيف
cleanup() {
    print_message "$BLUE" "🧹 تنظيف الملفات المؤقتة..."
    
    # حذف ملفات Python المؤقتة
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
    find . -type f -name "*.pyc" -delete 2>/dev/null || true
    
    # حذف السجلات القديمة (أكثر من 7 أيام)
    find logs -type f -name "*.log" -mtime +7 -delete 2>/dev/null || true
    
    print_message "$GREEN" "✅ تم التنظيف"
}

# دالة التثبيت
install() {
    print_header
    
    print_message "$BLUE" "📦 تثبيت نظام الأتمتة الذكي..."
    echo ""
    
    check_python
    check_requirements
    create_directories
    check_config
    
    # جعل السكريبت قابل للتنفيذ
    chmod +x run.sh
    
    echo ""
    print_message "$GREEN" "✅ تم التثبيت بنجاح!"
    echo ""
    print_message "$BLUE" "للتشغيل:"
    print_message "$YELLOW" "  ./run.sh start"
    echo ""
}

# دالة عرض المساعدة
show_help() {
    print_header
    
    echo "الاستخدام: ./run.sh [command]"
    echo ""
    echo "الأوامر المتاحة:"
    echo "  install    - تثبيت النظام والمتطلبات"
    echo "  start      - تشغيل النظام"
    echo "  stop       - إيقاف النظام"
    echo "  restart    - إعادة تشغيل النظام"
    echo "  status     - عرض حالة النظام"
    echo "  logs       - عرض السجلات"
    echo "  cleanup    - تنظيف الملفات المؤقتة"
    echo "  help       - عرض هذه المساعدة"
    echo ""
    echo "أمثلة:"
    echo "  ./run.sh install    # تثبيت النظام"
    echo "  ./run.sh start      # تشغيل النظام"
    echo "  ./run.sh status     # عرض الحالة"
    echo ""
}

# المعالج الرئيسي
main() {
    case "${1:-help}" in
        install)
            install
            ;;
        start)
            check_python
            create_directories
            start_system
            ;;
        stop)
            stop_system
            ;;
        restart)
            stop_system
            sleep 2
            start_system
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs
            ;;
        cleanup)
            cleanup
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_message "$RED" "❌ أمر غير معروف: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# تشغيل
main "$@"
