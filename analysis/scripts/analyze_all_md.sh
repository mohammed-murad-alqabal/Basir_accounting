#!/bin/bash
echo "🔍 Comprehensive analysis of $(find . -name "*.md" | wc -l) markdown files..."

# Basic stats
echo "=== Basic Statistics ===" > analysis/reports/full_analysis.txt
echo "Total .md files: $(find . -name "*.md" | wc -l)" >> analysis/reports/full_analysis.txt
echo "REPORT files: $(find . -name "*REPORT*.md" | wc -l)" >> analysis/reports/full_analysis.txt
echo "STATUS files: $(find . -name "*STATUS*.md" | wc -l)" >> analysis/reports/full_analysis.txt
echo "TASK files: $(find . -name "*TASK*.md" | wc -l)" >> analysis/reports/full_analysis.txt
echo "LOG files: $(find . -name "*.log" | wc -l)" >> analysis/reports/full_analysis.txt

# Directory distribution
echo -e "\n=== Directory Distribution ===" >> analysis/reports/full_analysis.txt
find . -name "*.md" | cut -d'/' -f2 | sort | uniq -c | sort -nr >> analysis/reports/full_analysis.txt

# File sizes
echo -e "\n=== Top 20 Largest Files ===" >> analysis/reports/full_analysis.txt
find . -name "*.md" -exec wc -l {} + | sort -nr | head -20 >> analysis/reports/full_analysis.txt

# Detect duplicates
echo -e "\n=== Detected Duplicates ===" >> analysis/reports/full_analysis.txt
find . -name "*.md" -exec basename {} \; | sort | uniq -d | head -50 >> analysis/reports/full_analysis.txt
