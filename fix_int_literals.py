#!/usr/bin/env python3
"""
سكريبت لإصلاح جميع حالات prefer_int_literals في ملفات Dart
فريق وكلاء تطوير مشروع بصير
"""

import re
import sys

def fix_int_literals(content):
    """إصلاح جميع حالات استخدام double literals حيث يمكن استخدام int"""
    
    # Pattern 1: property: 100.0,
    content = re.sub(r'(\w+):\s*(\d+)\.0,', r'\1: \2,', content)
    
    # Pattern 2: property: 100.0)
    content = re.sub(r'(\w+):\s*(\d+)\.0\)', r'\1: \2)', content)
    
    # Pattern 3: property: 100.0;
    content = re.sub(r'(\w+):\s*(\d+)\.0;', r'\1: \2;', content)
    
    # Pattern 4: = 100.0,
    content = re.sub(r'=\s*(\d+)\.0,', r'= \1,', content)
    
    # Pattern 5: = 100.0)
    content = re.sub(r'=\s*(\d+)\.0\)', r'= \1)', content)
    
    # Pattern 6: (100.0)
    content = re.sub(r'\((\d+)\.0\)', r'(\1)', content)
    
    # Pattern 7: [100.0]
    content = re.sub(r'\[(\d+)\.0\]', r'[\1]', content)
    
    return content

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 fix_int_literals.py <file_path>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        fixed_content = fix_int_literals(content)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(fixed_content)
        
        print(f"✅ تم إصلاح {file_path}")
    except Exception as e:
        print(f"❌ خطأ في معالجة {file_path}: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
