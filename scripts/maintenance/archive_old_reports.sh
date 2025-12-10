#!/bin/bash
# Archive Old Reports Script
# Archives reports older than 90 days
# Part of Basser MVP maintenance tools

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
DAYS_OLD=90
ARCHIVE_DIR=".kiro/archives"
DATE=$(date +%Y%m%d_%H%M%S)

echo -e "${BLUE}📦 أرشفة التقارير القديمة (> $DAYS_OLD يوم)${NC}"
echo "========================================"
echo ""

# Create archive directory if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

# Function to archive old files
archive_directory() {
  local dir=$1
  local name=$2
  
  if [ ! -d "$dir" ]; then
    echo -e "${YELLOW}⚠️  $name: المجلد غير موجود${NC}"
    return
  fi
  
  # Find old files
  local old_files=$(find "$dir" -name "*.md" -type f -mtime +$DAYS_OLD 2>/dev/null)
  local count=$(echo "$old_files" | grep -c "^" 2>/dev/null)
  
  if [ -z "$old_files" ] || [ "$count" -eq 0 ]; then
    echo -e "${GREEN}✅ $name: لا توجد ملفات قديمة${NC}"
    return 0
  fi
  
  echo -e "${YELLOW}📋 $name: تم العثور على $count ملف قديم${NC}"
  
  # Create archive
  local archive_name="${ARCHIVE_DIR}/${name//\//_}_${DATE}.tar.gz"
  
  echo "$old_files" | tar -czf "$archive_name" -T - 2>/dev/null
  
  if [ $? -eq 0 ]; then
    local archive_size=$(du -sh "$archive_name" | cut -f1)
    echo -e "${GREEN}✅ تم إنشاء الأرشيف: $archive_name ($archive_size)${NC}"
    
    # Ask for confirmation before deleting
    echo -e "${YELLOW}هل تريد حذف الملفات المؤرشفة؟ (y/n)${NC}"
    read -r response
    
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
      echo "$old_files" | xargs rm -f
      echo -e "${GREEN}✅ تم حذف الملفات القديمة${NC}"
    else
      echo -e "${BLUE}ℹ️  تم الاحتفاظ بالملفات الأصلية${NC}"
    fi
  else
    echo -e "${RED}❌ فشل إنشاء الأرشيف${NC}"
    return 1
  fi
  
  echo ""
}

# Archive directories
archive_directory ".kiro/docs/reports" "kiro_docs_reports"
archive_directory "Documentation/reports" "documentation_reports"
archive_directory "Documentation/Archive" "documentation_archive"

echo "========================================"
echo -e "${GREEN}✅ اكتملت عملية الأرشفة${NC}"
echo ""
echo -e "${BLUE}الأرشيفات المُنشأة:${NC}"
ls -lh "$ARCHIVE_DIR"/*.tar.gz 2>/dev/null | tail -5
echo ""
echo -e "${YELLOW}ملاحظة: يمكنك استعادة الملفات من الأرشيف باستخدام:${NC}"
echo "  tar -xzf $ARCHIVE_DIR/[archive_name].tar.gz"
