#!/bin/bash
# Check Size Script
# Monitors directory sizes and warns if they exceed thresholds
# Part of Basser MVP maintenance tools

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Thresholds (in MB)
DOCUMENTATION_THRESHOLD=25
KIRO_DOCS_THRESHOLD=2
SCRIPTS_THRESHOLD=1
LOGS_THRESHOLD=10

echo -e "${BLUE}📊 فحص أحجام المجلدات الرئيسية${NC}"
echo "========================================"
echo ""

# Function to check size
check_size() {
  local dir=$1
  local threshold=$2
  local name=$3
  
  if [ ! -d "$dir" ]; then
    echo -e "${YELLOW}⚠️  $name: المجلد غير موجود${NC}"
    return
  fi
  
  local size=$(du -sm "$dir" 2>/dev/null | cut -f1)
  local size_human=$(du -sh "$dir" 2>/dev/null | cut -f1)
  
  if [ $size -gt $threshold ]; then
    echo -e "${RED}❌ $name: $size_human (تجاوز الحد: ${threshold}MB)${NC}"
    return 1
  elif [ $size -gt $((threshold * 80 / 100)) ]; then
    echo -e "${YELLOW}⚠️  $name: $size_human (قريب من الحد: ${threshold}MB)${NC}"
    return 2
  else
    echo -e "${GREEN}✅ $name: $size_human${NC}"
    return 0
  fi
}

# Check directories
WARNINGS=0
ERRORS=0

check_size "Documentation" $DOCUMENTATION_THRESHOLD "docs/"
result=$?
[ $result -eq 1 ] && ((ERRORS++))
[ $result -eq 2 ] && ((WARNINGS++))

check_size ".kiro/docs" $KIRO_DOCS_THRESHOLD ".kiro/docs/"
result=$?
[ $result -eq 1 ] && ((ERRORS++))
[ $result -eq 2 ] && ((WARNINGS++))

check_size "scripts" $SCRIPTS_THRESHOLD "scripts/"
result=$?
[ $result -eq 1 ] && ((ERRORS++))
[ $result -eq 2 ] && ((WARNINGS++))

check_size "logs" $LOGS_THRESHOLD "logs/"
result=$?
[ $result -eq 1 ] && ((ERRORS++))
[ $result -eq 2 ] && ((WARNINGS++))

echo ""
echo "========================================"

# Summary
if [ $ERRORS -gt 0 ]; then
  echo -e "${RED}❌ تم العثور على $ERRORS مجلد(ات) تجاوزت الحد${NC}"
  echo ""
  echo -e "${YELLOW}الإجراءات الموصى بها:${NC}"
  echo "  1. أرشفة الملفات القديمة"
  echo "  2. حذف الملفات غير الضرورية"
  echo "  3. نقل الملفات الكبيرة إلى مكان آخر"
  echo ""
  echo -e "${BLUE}للأرشفة:${NC}"
  echo "  bash scripts/maintenance/archive_old_reports.sh"
  exit 1
elif [ $WARNINGS -gt 0 ]; then
  echo -e "${YELLOW}⚠️  تم العثور على $WARNINGS مجلد(ات) قريبة من الحد${NC}"
  echo ""
  echo -e "${YELLOW}يُنصح بمراجعة وأرشفة الملفات القديمة قريباً${NC}"
  exit 0
else
  echo -e "${GREEN}✅ جميع المجلدات ضمن الحدود المقبولة${NC}"
  exit 0
fi
