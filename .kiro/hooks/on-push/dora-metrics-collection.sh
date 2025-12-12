#!/bin/bash
# DORA Metrics Collection Hook
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 11 ديسمبر 2025

set -e

echo "📊 DORA Metrics Collection Starting..."

# Create metrics directory
mkdir -p .kiro/metrics

# Get current timestamp
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
UNIX_TIMESTAMP=$(date +%s)

# Get git information
COMMIT_HASH=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
COMMIT_TIME=$(git log -1 --format=%ct 2>/dev/null || echo "$UNIX_TIMESTAMP")
BRANCH_NAME=$(git branch --show-current 2>/dev/null || echo "unknown")
AUTHOR=$(git log -1 --format=%an 2>/dev/null || echo "unknown")

echo "📈 Collecting DORA Metrics for commit: $COMMIT_HASH"

# 1. Deployment Frequency Tracking
echo "📊 Tracking deployment frequency..."
if [ "$BRANCH_NAME" = "main" ] || [ "$BRANCH_NAME" = "master" ]; then
    echo "$TIMESTAMP,$COMMIT_HASH,$BRANCH_NAME,main_branch_push,1" >> .kiro/metrics/deployment-frequency.csv
    echo "✅ Main branch push recorded for deployment frequency"
fi

# 2. Lead Time Calculation
echo "📊 Calculating lead time..."
if [ -f ".kiro/metrics/feature-start-times.csv" ]; then
    # Try to find when this feature/branch was started
    FEATURE_START=$(grep "$BRANCH_NAME" .kiro/metrics/feature-start-times.csv 2>/dev/null | tail -1 | cut -d',' -f2 || echo "$COMMIT_TIME")
    LEAD_TIME=$((UNIX_TIMESTAMP - FEATURE_START))
    LEAD_TIME_HOURS=$((LEAD_TIME / 3600))
    
    echo "$TIMESTAMP,$COMMIT_HASH,$BRANCH_NAME,$FEATURE_START,$UNIX_TIMESTAMP,$LEAD_TIME,$LEAD_TIME_HOURS" >> .kiro/metrics/lead-time.csv
    echo "✅ Lead time recorded: $LEAD_TIME_HOURS hours"
else
    # Create initial feature start time file
    echo "timestamp,branch,start_time" > .kiro/metrics/feature-start-times.csv
    echo "$TIMESTAMP,$BRANCH_NAME,$COMMIT_TIME" >> .kiro/metrics/feature-start-times.csv
fi

# 3. Change Quality Assessment (for Change Failure Rate)
echo "📊 Assessing change quality..."
QUALITY_SCORE=0

# Check test coverage if available
if [ -f "coverage/lcov.info" ]; then
    COVERAGE=$(grep -o 'LF:[0-9]*' coverage/lcov.info | awk -F: '{sum+=$2} END {print sum}' 2>/dev/null || echo "0")
    if [ "$COVERAGE" -gt 70 ]; then
        QUALITY_SCORE=$((QUALITY_SCORE + 25))
    fi
fi

# Check code analysis results
if command -v dart >/dev/null 2>&1 && [ -f "analysis_options.yaml" ]; then
    ANALYSIS_ISSUES=$(dart analyze --format=json 2>/dev/null | jq '[.diagnostics[] | select(.severity == "error")] | length' 2>/dev/null || echo "0")
    if [ "$ANALYSIS_ISSUES" -eq 0 ]; then
        QUALITY_SCORE=$((QUALITY_SCORE + 25))
    fi
fi

# Check commit message quality (conventional commits)
COMMIT_MSG=$(git log -1 --format=%s 2>/dev/null || echo "")
if echo "$COMMIT_MSG" | grep -E "^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+" >/dev/null; then
    QUALITY_SCORE=$((QUALITY_SCORE + 25))
fi

# Check file changes (smaller changes are generally safer)
FILES_CHANGED=$(git diff --name-only HEAD~1 2>/dev/null | wc -l || echo "1")
if [ "$FILES_CHANGED" -le 5 ]; then
    QUALITY_SCORE=$((QUALITY_SCORE + 25))
fi

echo "$TIMESTAMP,$COMMIT_HASH,$BRANCH_NAME,$QUALITY_SCORE,$FILES_CHANGED,$ANALYSIS_ISSUES" >> .kiro/metrics/change-quality.csv
echo "✅ Change quality assessed: $QUALITY_SCORE/100"

# 4. SPACE Framework Metrics Collection
echo "📊 Collecting SPACE metrics..."

# Activity metrics
COMMITS_TODAY=$(git log --since="1 day ago" --author="$AUTHOR" --oneline 2>/dev/null | wc -l || echo "1")
COMMITS_WEEK=$(git log --since="1 week ago" --author="$AUTHOR" --oneline 2>/dev/null | wc -l || echo "1")

echo "$TIMESTAMP,$AUTHOR,$COMMITS_TODAY,$COMMITS_WEEK,$FILES_CHANGED" >> .kiro/metrics/developer-activity.csv
echo "✅ Developer activity recorded: $COMMITS_TODAY commits today, $COMMITS_WEEK this week"

# 5. Security Metrics Integration
echo "📊 Collecting security metrics..."
SECURITY_SCAN_RESULT="unknown"
if [ -f ".kiro/audit/security-scan.log" ]; then
    LAST_SCAN=$(tail -1 .kiro/audit/security-scan.log 2>/dev/null || echo "")
    if echo "$LAST_SCAN" | grep -q "completed successfully"; then
        SECURITY_SCAN_RESULT="passed"
    elif echo "$LAST_SCAN" | grep -q "BLOCKED"; then
        SECURITY_SCAN_RESULT="failed"
    fi
fi

echo "$TIMESTAMP,$COMMIT_HASH,$SECURITY_SCAN_RESULT" >> .kiro/metrics/security-metrics.csv
echo "✅ Security metrics recorded: $SECURITY_SCAN_RESULT"

# 6. Performance Metrics (Build Time Tracking)
echo "📊 Tracking build performance..."
if [ -f "pubspec.yaml" ]; then
    BUILD_START=$(date +%s)
    
    # Simulate build time check (in real scenario, this would be actual build)
    if command -v flutter >/dev/null 2>&1; then
        flutter analyze --no-pub >/dev/null 2>&1 || true
    fi
    
    BUILD_END=$(date +%s)
    BUILD_TIME=$((BUILD_END - BUILD_START))
    
    echo "$TIMESTAMP,$COMMIT_HASH,$BUILD_TIME" >> .kiro/metrics/build-performance.csv
    echo "✅ Build performance recorded: ${BUILD_TIME}s"
fi

# 7. Generate Summary Report
echo "📊 Generating metrics summary..."
cat > .kiro/metrics/latest-push-summary.md << EOF
# Push Metrics Summary

**Timestamp**: $TIMESTAMP  
**Commit**: $COMMIT_HASH  
**Branch**: $BRANCH_NAME  
**Author**: $AUTHOR  

## DORA Metrics
- **Lead Time**: $LEAD_TIME_HOURS hours
- **Quality Score**: $QUALITY_SCORE/100
- **Files Changed**: $FILES_CHANGED
- **Security Scan**: $SECURITY_SCAN_RESULT

## SPACE Metrics
- **Activity**: $COMMITS_TODAY commits today, $COMMITS_WEEK this week
- **Performance**: Build time ${BUILD_TIME:-"N/A"}s

## Recommendations
$(if [ "$LEAD_TIME_HOURS" -gt 24 ]; then echo "- ⚠️  Lead time exceeds 1 day target"; fi)
$(if [ "$QUALITY_SCORE" -lt 75 ]; then echo "- ⚠️  Quality score below recommended threshold"; fi)
$(if [ "$FILES_CHANGED" -gt 10 ]; then echo "- ⚠️  Large change set - consider breaking into smaller commits"; fi)
$(if [ "$SECURITY_SCAN_RESULT" != "passed" ]; then echo "- 🔒 Security scan issues need attention"; fi)
EOF

echo "✅ DORA Metrics Collection Complete!"
echo "📄 Summary report: .kiro/metrics/latest-push-summary.md"

# Optional: Display key metrics
echo ""
echo "🎯 Key Metrics Summary:"
echo "   Lead Time: $LEAD_TIME_HOURS hours (Target: <24h)"
echo "   Quality Score: $QUALITY_SCORE/100 (Target: >75)"
echo "   Security: $SECURITY_SCAN_RESULT"
echo "   Activity: $COMMITS_TODAY commits today"

exit 0