#!/bin/bash
echo "🏥 فحص صحة البيئة التطويرية..."
echo "Flutter Version:"
flutter --version | head -1
echo -e "\nAnalyze Issues:"
flutter analyze --no-fatal-infos 2>&1 | grep "issues found" || echo "No issues found"
echo -e "\nGenerated Files:"
find . -name "*.g.dart" -type f | wc -l
echo -e "\nMemory Usage:"
free -h | grep Mem
echo "✅ فحص الصحة مكتمل!"