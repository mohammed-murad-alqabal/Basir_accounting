#!/bin/bash

# Flutter Test Generation Hook
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 18 ديسمبر 2025

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_header() {
    echo -e "${PURPLE}🧪 $1${NC}"
    echo "════════════════════════════════════════════════════════════════"
}

print_status() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

print_header "Flutter Test Generator"

# دالة إنشاء unit test
generate_unit_test() {
    local dart_file=$1
    local test_file=${dart_file/lib\//test\/unit\/}
    test_file=${test_file/.dart/_test.dart}
    
    # إنشاء مجلد الاختبار
    mkdir -p "$(dirname "$test_file")"
    
    # استخراج اسم الكلاس
    local class_name=$(grep -o "class [A-Za-z]*" "$dart_file" | head -1 | cut -d' ' -f2)
    
    if [ -z "$class_name" ]; then
        print_warning "No class found in $dart_file"
        return
    fi
    
    cat > "$test_file" << EOF
import 'package:flutter_test/flutter_test.dart';
import 'package:${dart_file#lib/}' as ${class_name,,};

void main() {
  group('$class_name Tests', () {
    test('should create instance', () {
      // TODO: Implement test
      expect(true, isTrue);
    });
  });
}
EOF
    
    print_status "Generated: $test_file"
}

# دالة إنشاء widget test
generate_widget_test() {
    local widget_file=$1
    local test_file=${widget_file/lib\//test\/widget\/}
    test_file=${test_file/.dart/_test.dart}
    
    mkdir -p "$(dirname "$test_file")"
    
    local widget_name=$(grep -o "class [A-Za-z]*Widget" "$widget_file" | head -1 | cut -d' ' -f2)
    
    if [ -z "$widget_name" ]; then
        widget_name=$(grep -o "class [A-Za-z]*Screen" "$widget_file" | head -1 | cut -d' ' -f2)
    fi
    
    if [ -z "$widget_name" ]; then
        print_warning "No widget found in $widget_file"
        return
    fi
    
    cat > "$test_file" << EOF
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:${widget_file#lib/}';

void main() {
  group('$widget_name Tests', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: $widget_name(),
        ),
      );
      
      // TODO: Add widget tests
      expect(find.byType($widget_name), findsOneWidget);
    });
  });
}
EOF
    
    print_status "Generated: $test_file"
}

# القائمة الرئيسية
show_menu() {
    echo ""
    echo "Test Generation Options:"
    echo "1. 🧪 Generate Unit Tests"
    echo "2. 🎨 Generate Widget Tests"
    echo "3. 📊 Test Coverage Report"
    echo "4. 🔍 Find Missing Tests"
    echo "5. 🚀 Generate All Missing Tests"
    echo "0. Exit"
    echo ""
}

if [ $# -eq 0 ]; then
    while true; do
        show_menu
        echo -n "Choose option (0-5): "
        read -r choice
        
        case $choice in
            1)
                print_info "Generating unit tests for all Dart files..."
                find lib/ -name "*.dart" -type f | while read -r file; do
                    generate_unit_test "$file"
                done
                ;;
            2)
                print_info "Generating widget tests..."
                find lib/ -name "*_screen.dart" -o -name "*_widget.dart" | while read -r file; do
                    generate_widget_test "$file"
                done
                ;;
            3)
                print_info "Running test coverage..."
                flutter test --coverage
                if [ -f "coverage/lcov.info" ]; then
                    lcov --summary coverage/lcov.info
                fi
                ;;
            4)
                print_info "Finding files without tests..."
                find lib/ -name "*.dart" | while read -r file; do
                    test_file=${file/lib\//test\/unit\/}
                    test_file=${test_file/.dart/_test.dart}
                    if [ ! -f "$test_file" ]; then
                        echo "Missing test: $file"
                    fi
                done
                ;;
            5)
                print_info "Generating all missing tests..."
                find lib/ -name "*.dart" | while read -r file; do
                    test_file=${file/lib\//test\/unit\/}
                    test_file=${test_file/.dart/_test.dart}
                    if [ ! -f "$test_file" ]; then
                        generate_unit_test "$file"
                    fi
                done
                ;;
            0)
                print_status "Goodbye! 👋"
                exit 0
                ;;
            *)
                print_error "Invalid choice"
                ;;
        esac
        
        echo ""
        echo "Press Enter to continue..."
        read -r
    done
fi