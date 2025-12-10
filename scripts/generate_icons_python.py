#!/usr/bin/env python3
"""
سكريبت لتوليد أيقونات التطبيق باستخدام Python و PIL
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_icon(size, filename):
    """إنشاء أيقونة بحجم محدد"""
    print(f"  📝 توليد {filename} ({size}x{size})...")
    
    # إنشاء صورة جديدة بخلفية زرقاء
    img = Image.new('RGB', (size, size), color='#0056B3')
    draw = ImageDraw.Draw(img)
    
    # رسم الفاتورة (مستطيل أبيض)
    margin = size * 0.2
    invoice_width = size * 0.6
    invoice_height = size * 0.7
    invoice_x = margin
    invoice_y = size * 0.15
    
    # رسم مستطيل الفاتورة
    draw.rectangle(
        [invoice_x, invoice_y, invoice_x + invoice_width, invoice_y + invoice_height],
        outline='white',
        width=int(size * 0.04)
    )
    
    # رسم خطوط الفاتورة
    line_start_x = invoice_x + size * 0.1
    line_end_x = invoice_x + invoice_width - size * 0.1
    
    line_y1 = invoice_y + size * 0.2
    line_y2 = invoice_y + size * 0.35
    line_y3 = invoice_y + size * 0.5
    
    line_width = int(size * 0.03)
    
    draw.line([line_start_x, line_y1, line_end_x, line_y1], fill='white', width=line_width)
    draw.line([line_start_x, line_y2, line_end_x * 0.95, line_y2], fill='white', width=line_width)
    draw.line([line_start_x, line_y3, line_end_x * 0.9, line_y3], fill='white', width=line_width)
    
    # رسم دائرة بيضاء لعلامة الصح
    check_center_x = invoice_x + invoice_width * 0.85
    check_center_y = invoice_y + invoice_height * 0.85
    check_radius = size * 0.12
    
    draw.ellipse(
        [check_center_x - check_radius, check_center_y - check_radius,
         check_center_x + check_radius, check_center_y + check_radius],
        fill='white'
    )
    
    # رسم علامة الصح (✓) باللون الأزرق
    check_width = int(size * 0.05)
    check_x1 = check_center_x - check_radius * 0.5
    check_y1 = check_center_y
    check_x2 = check_center_x - check_radius * 0.15
    check_y2 = check_center_y + check_radius * 0.5
    check_x3 = check_center_x + check_radius * 0.6
    check_y3 = check_center_y - check_radius * 0.4
    
    draw.line([check_x1, check_y1, check_x2, check_y2], fill='#0056B3', width=check_width)
    draw.line([check_x2, check_y2, check_x3, check_y3], fill='#0056B3', width=check_width)
    
    # حفظ الصورة
    img.save(f'assets/icons/{filename}')
    print(f"  ✅ تم حفظ {filename}")

def main():
    """الدالة الرئيسية"""
    print('🎨 بدء توليد أيقونات التطبيق...')
    
    # إنشاء المجلد إذا لم يكن موجوداً
    os.makedirs('assets/icons', exist_ok=True)
    
    # توليد الأيقونات بأحجام مختلفة
    create_icon(1024, 'app_icon.png')
    create_icon(512, 'app_icon_foreground.png')
    create_icon(512, 'splash_logo.png')
    
    print('✅ تم توليد جميع الأيقونات بنجاح!')
    print('📁 الموقع: assets/icons/')
    print('')
    print('الخطوات التالية:')
    print('1. flutter pub run flutter_launcher_icons')
    print('2. dart run flutter_native_splash:create')

if __name__ == '__main__':
    main()
