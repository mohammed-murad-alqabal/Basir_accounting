#!/usr/bin/env python3
import os
import re
from datetime import datetime

def categorize_by_content(filepath):
    """Categorize file based on content patterns."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        # Classification rules
        if re.search(r'تقرير|report|REPORT', content, re.IGNORECASE):
            return 'REPORT'
        elif re.search(r'حالة|status|STATUS', content, re.IGNORECASE):
            return 'STATUS'
        elif re.search(r'مهمة|task|TASK', content, re.IGNORECASE):
            return 'TASK'
        elif re.search(r'دليل|guide|GUIDE', content, re.IGNORECASE):
            return 'GUIDE'
        elif re.search(r'فهرس|index|INDEX', content, re.IGNORECASE):
            return 'INDEX'
        else:
            return 'OTHER'
    except Exception as e:
        return f'ERROR: {str(e)}'

def analyze_all_md_files(base_dir):
    """Analyze all .md files in the directory."""
    categories = {}
    for root, dirs, files in os.walk(base_dir):
        # Skip .git directory only
        if '.git' in root:
            continue
            
        for file in files:
            if file.endswith('.md'):
                filepath = os.path.join(root, file)
                category = categorize_by_content(filepath)
                if category not in categories:
                    categories[category] = []
                categories[category].append(filepath)

    return categories

if __name__ == "__main__":
    base_dir = "."
    categories = analyze_all_md_files(base_dir)
    
    os.makedirs("analysis/reports", exist_ok=True)
    with open("analysis/reports/smart_classification.txt", "w", encoding='utf-8') as f:
        for category, files in categories.items():
            f.write(f"\n=== {category} ({len(files)} files) ===\n")
            for file in files[:20]:  # Show top 20
                f.write(f"  {file}\n")
            if len(files) > 20:
                f.write(f"  ... and {len(files) - 20} more files\n")
    
    print(f"✅ Smart classification report generated in analysis/reports/smart_classification.txt")
