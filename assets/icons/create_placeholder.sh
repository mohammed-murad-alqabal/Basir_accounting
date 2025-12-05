#!/bin/bash
# إنشاء أيقونات placeholder بسيطة باستخدام أدوات النظام

# إنشاء أيقونة 1024x1024 (placeholder)
echo "P3
1024 1024
255" > assets/icons/app_icon.ppm

# ملء بلون أزرق
for i in {1..1024}; do
  for j in {1..1024}; do
    echo "0 86 179"
  done
done >> assets/icons/app_icon.ppm

echo "✅ تم إنشاء placeholder"
