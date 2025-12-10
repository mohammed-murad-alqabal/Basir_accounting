#!/bin/bash

# سكريبت إعداد بيئة التطوير لمشروع بصير MVP
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

# الألوان
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  إعداد بيئة التطوير - مشروع بصير MVP  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# دالة للطباعة مع تنسيق
print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# دالة للتحقق من وجود أمر
command_exists() {
    command -v "$1" &> /dev/null
}

# دالة لطلب إدخال من المستخدم
ask_user() {
    local prompt="$1"
    local default="$2"
    local response
    
    read -p "$prompt [$default]: " response
    echo "${response:-$default}"
}

# دالة لطلب تأكيد
confirm() {
    local prompt="$1"
    local response
    
    read -p "$prompt (y/n): " response
    [[ "$response" =~ ^[Yy]$ ]]
}

# ====================
# 1. إعداد Git
# ====================
setup_git() {
    print_step "إعداد Git..."
    echo ""
    
    # التحقق من user.name
    if ! git config --global user.name &> /dev/null; then
        print_warning "Git user.name غير مضبوط"
        local name=$(ask_user "أدخل اسمك" "Your Name")
        git config --global user.name "$name"
        print_success "تم ضبط user.name: $name"
    else
        local current_name=$(git config --global user.name)
        print_success "user.name مضبوط: $current_name"
    fi
    
    # التحقق من user.email
    if ! git config --global user.email &> /dev/null; then
        print_warning "Git user.email غير مضبوط"
        local email=$(ask_user "أدخل بريدك الإلكتروني" "your.email@example.com")
        git config --global user.email "$email"
        print_success "تم ضبط user.email: $email"
    else
        local current_email=$(git config --global user.email)
        print_success "user.email مضبوط: $current_email"
    fi
    
    echo ""
}

# ====================
# 2. إعداد متغيرات البيئة
# ====================
setup_environment_variables() {
    print_step "إعداد متغيرات البيئة..."
    echo ""
    
    # تحديد ملف shell
    local shell_rc=""
    if [ -f "$HOME/.bashrc" ]; then
        shell_rc="$HOME/.bashrc"
    elif [ -f "$HOME/.zshrc" ]; then
        shell_rc="$HOME/.zshrc"
    else
        print_error "لم يتم العثور على .bashrc أو .zshrc"
        return 1
    fi
    
    print_success "سيتم استخدام: $shell_rc"
    
    # التحقق من ANDROID_HOME
    if [ -z "$ANDROID_HOME" ]; then
        print_warning "ANDROID_HOME غير مضبوط"
        
        # البحث عن Android SDK
        local android_sdk=""
        if [ -d "$HOME/Android/Sdk" ]; then
            android_sdk="$HOME/Android/Sdk"
        elif [ -d "$HOME/Library/Android/sdk" ]; then
            android_sdk="$HOME/Library/Android/sdk"
        fi
        
        if [ -n "$android_sdk" ]; then
            print_success "تم العثور على Android SDK: $android_sdk"
            
            # إضافة إلى shell_rc
            if ! grep -q "ANDROID_HOME" "$shell_rc"; then
                cat >> "$shell_rc" << EOF

# Android SDK (added by setup script)
export ANDROID_HOME=$android_sdk
export PATH=\$PATH:\$ANDROID_HOME/tools
export PATH=\$PATH:\$ANDROID_HOME/tools/bin
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
EOF
                print_success "تم إضافة ANDROID_HOME إلى $shell_rc"
            else
                print_success "ANDROID_HOME موجود بالفعل في $shell_rc"
            fi
        else
            print_warning "لم يتم العثور على Android SDK"
        fi
    else
        print_success "ANDROID_HOME مضبوط: $ANDROID_HOME"
    fi
    
    # التحقق من JAVA_HOME
    if [ -z "$JAVA_HOME" ]; then
        print_warning "JAVA_HOME غير مضبوط"
        
        # البحث عن Java من Android Studio
        local java_home=""
        if [ -d "/snap/android-studio/current/jbr" ]; then
            java_home="/snap/android-studio/current/jbr"
        elif [ -d "/snap/android-studio/209/jbr" ]; then
            java_home="/snap/android-studio/209/jbr"
        elif [ -d "/Applications/Android Studio.app/Contents/jbr/Contents/Home" ]; then
            java_home="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
        fi
        
        if [ -n "$java_home" ]; then
            print_success "تم العثور على Java: $java_home"
            
            # إضافة إلى shell_rc
            if ! grep -q "JAVA_HOME" "$shell_rc"; then
                cat >> "$shell_rc" << EOF

# Java (added by setup script)
export JAVA_HOME=$java_home
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
                print_success "تم إضافة JAVA_HOME إلى $shell_rc"
            else
                print_success "JAVA_HOME موجود بالفعل في $shell_rc"
            fi
        else
            print_warning "لم يتم العثور على Java"
        fi
    else
        print_success "JAVA_HOME مضبوط: $JAVA_HOME"
    fi
    
    # التحقق من Flutter في PATH
    if ! grep -q "flutter/bin" "$shell_rc"; then
        if [ -d "$HOME/flutter/bin" ]; then
            cat >> "$shell_rc" << EOF

# Flutter (added by setup script)
export PATH=\$PATH:$HOME/flutter/bin
EOF
            print_success "تم إضافة Flutter إلى PATH"
        fi
    else
        print_success "Flutter موجود في PATH"
    fi
    
    echo ""
    print_warning "يجب إعادة تشغيل Terminal أو تنفيذ: source $shell_rc"
    echo ""
}

# ====================
# 3. تثبيت GitHub CLI (اختياري)
# ====================
install_github_cli() {
    print_step "تثبيت GitHub CLI..."
    echo ""
    
    if command_exists gh; then
        print_success "GitHub CLI مثبت بالفعل"
        gh --version
    else
        if confirm "هل تريد تثبيت GitHub CLI؟"; then
            if command_exists apt; then
                sudo apt update
                sudo apt install -y gh
                print_success "تم تثبيت GitHub CLI"
            elif command_exists brew; then
                brew install gh
                print_success "تم تثبيت GitHub CLI"
            else
                print_warning "لم يتم العثور على مدير حزم مناسب"
                print_warning "يرجى تثبيت GitHub CLI يدوياً من: https://cli.github.com/"
            fi
        else
            print_warning "تم تخطي تثبيت GitHub CLI"
        fi
    fi
    
    echo ""
}

# ====================
# 4. تثبيت yq (اختياري)
# ====================
install_yq() {
    print_step "تثبيت yq..."
    echo ""
    
    if command_exists yq; then
        print_success "yq مثبت بالفعل"
        yq --version
    else
        if confirm "هل تريد تثبيت yq؟"; then
            if command_exists apt; then
                sudo apt update
                sudo apt install -y yq
                print_success "تم تثبيت yq"
            elif command_exists snap; then
                sudo snap install yq
                print_success "تم تثبيت yq"
            elif command_exists brew; then
                brew install yq
                print_success "تم تثبيت yq"
            else
                print_warning "لم يتم العثور على مدير حزم مناسب"
                print_warning "يرجى تثبيت yq يدوياً من: https://github.com/mikefarah/yq"
            fi
        else
            print_warning "تم تخطي تثبيت yq"
        fi
    fi
    
    echo ""
}

# ====================
# 5. التحقق من Flutter
# ====================
verify_flutter() {
    print_step "التحقق من Flutter..."
    echo ""
    
    if command_exists flutter; then
        flutter doctor -v
        echo ""
        print_success "Flutter جاهز!"
    else
        print_error "Flutter غير مثبت!"
        print_warning "يرجى تثبيت Flutter من: https://flutter.dev/docs/get-started/install"
    fi
    
    echo ""
}

# ====================
# 6. تحديث التبعيات
# ====================
update_dependencies() {
    print_step "تحديث تبعيات المشروع..."
    echo ""
    
    if [ -f "pubspec.yaml" ]; then
        flutter pub get
        print_success "تم تحديث التبعيات"
        
        echo ""
        print_step "التحقق من التحديثات المتاحة..."
        flutter pub outdated
    else
        print_warning "لم يتم العثور على pubspec.yaml"
    fi
    
    echo ""
}

# ====================
# 7. تشغيل الاختبارات
# ====================
run_tests() {
    print_step "تشغيل الاختبارات..."
    echo ""
    
    if [ -d "test" ]; then
        flutter test
        print_success "الاختبارات نجحت!"
    else
        print_warning "لم يتم العثور على مجلد test"
    fi
    
    echo ""
}

# ====================
# Main
# ====================
main() {
    echo -e "${BLUE}هذا السكريبت سيقوم بإعداد بيئة التطوير لمشروع بصير MVP${NC}"
    echo ""
    
    # اختيار نوع الإعداد
    echo "اختر نوع الإعداد:"
    echo "1) إعداد كامل (موصى به)"
    echo "2) إعداد أساسي (Git + متغيرات البيئة فقط)"
    echo "3) إعداد مخصص"
    echo ""
    
    local choice=$(ask_user "اختيارك" "1")
    echo ""
    
    case $choice in
        1)
            # إعداد كامل
            setup_git
            setup_environment_variables
            install_github_cli
            install_yq
            verify_flutter
            update_dependencies
            ;;
        2)
            # إعداد أساسي
            setup_git
            setup_environment_variables
            verify_flutter
            ;;
        3)
            # إعداد مخصص
            if confirm "إعداد Git؟"; then
                setup_git
            fi
            
            if confirm "إعداد متغيرات البيئة؟"; then
                setup_environment_variables
            fi
            
            if confirm "تثبيت GitHub CLI؟"; then
                install_github_cli
            fi
            
            if confirm "تثبيت yq؟"; then
                install_yq
            fi
            
            if confirm "التحقق من Flutter؟"; then
                verify_flutter
            fi
            
            if confirm "تحديث التبعيات؟"; then
                update_dependencies
            fi
            
            if confirm "تشغيل الاختبارات؟"; then
                run_tests
            fi
            ;;
        *)
            print_error "اختيار غير صحيح"
            exit 1
            ;;
    esac
    
    # الخلاصة
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         تم الانتهاء من الإعداد!        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    print_warning "الخطوات التالية:"
    echo "  1. إعادة تشغيل Terminal أو تنفيذ: source ~/.bashrc"
    echo "  2. التحقق من الإعداد: flutter doctor -v"
    echo "  3. البدء في التطوير! 🚀"
    echo ""
    
    print_success "بيئة التطوير جاهزة لمشروع بصير MVP!"
}

# تشغيل السكريبت
main "$@"
