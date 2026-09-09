# Error Tracking & Analytics Setup

**المشروع:** [اسم المشروع]
**التاريخ:** [التاريخ]
**المؤلف:** فريق وكلاء تطوير المشروع

## نظام تتبع الأخطاء المتكامل

### 1. بنية نظام التتبع

```
logs/
├── errors/              # سجلات الأخطاء
│   ├── YYYY-MM-DD.log
│   └── critical.log
├── reports/            # التقارير التحليلية
│   ├── daily/
│   ├── weekly/
│   └── monthly/
├── archive/            # الأرشيف
└── metrics/            # المقاييس
```

### 2. Logger Service Template

```dart
// logger_service.dart
class LoggerService {
  private logDir: string;
  private errorLogPath: string;
  private metricsPath: string;

  constructor() {
    this.logDir = path.join(process.cwd(), "logs");
    this.errorLogPath = path.join(this.logDir, "errors");
    this.metricsPath = path.join(this.logDir, "metrics");
    this.ensureDirectories();
  }

  private ensureDirectories(): void {
    [this.logDir, this.errorLogPath, this.metricsPath].forEach((dir) => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
    });
  }

  logError(error: Error, context?: any): void {
    const timestamp = new Date().toISOString();
    const logEntry = {
      timestamp,
      level: "ERROR",
      message: error.message,
      stack: error.stack,
      context,
    };

    const filename = `${this.errorLogPath}/${this.getDateString()}.log`;
    fs.appendFileSync(filename, JSON.stringify(logEntry) + "\n");

    // Critical errors
    if (this.isCritical(error)) {
      const criticalPath = `${this.errorLogPath}/critical.log`;
      fs.appendFileSync(criticalPath, JSON.stringify(logEntry) + "\n");
    }
  }

  logMetric(
    metric: string,
    value: number,
    tags?: Record<string, string>
  ): void {
    const timestamp = new Date().toISOString();
    const metricEntry = {
      timestamp,
      metric,
      value,
      tags,
    };

    const filename = `${this.metricsPath}/${this.getDateString()}.json`;
    fs.appendFileSync(filename, JSON.stringify(metricEntry) + "\n");
  }

  private isCritical(error: Error): boolean {
    const criticalPatterns = [
      /database/i,
      /authentication/i,
      /security/i,
      /payment/i,
    ];
    return criticalPatterns.some((pattern) => pattern.test(error.message));
  }

  private getDateString(): string {
    return new Date().toISOString().split("T")[0];
  }

  async generateReport(period: "daily" | "weekly" | "monthly"): Promise<void> {
    // Implementation for report generation
  }
}
```

### 3. Error Analysis Script

```bash
#!/bin/bash
# analyze_errors.sh

LOG_DIR="logs/errors"
REPORT_DIR="logs/reports"
DATE=$(date +%Y-%m-%d)

echo "📊 Analyzing errors for $DATE..."

# Count errors by type
echo "## Error Summary" > "$REPORT_DIR/daily/$DATE.md"
echo "" >> "$REPORT_DIR/daily/$DATE.md"

# Total errors
TOTAL=$(grep -c "ERROR" "$LOG_DIR/$DATE.log" 2>/dev/null || echo "0")
echo "**Total Errors:** $TOTAL" >> "$REPORT_DIR/daily/$DATE.md"

# Critical errors
CRITICAL=$(grep -c "CRITICAL" "$LOG_DIR/critical.log" 2>/dev/null || echo "0")
echo "**Critical Errors:** $CRITICAL" >> "$REPORT_DIR/daily/$DATE.md"

# Top error messages
echo "" >> "$REPORT_DIR/daily/$DATE.md"
echo "## Top Error Messages" >> "$REPORT_DIR/daily/$DATE.md"
grep "ERROR" "$LOG_DIR/$DATE.log" 2>/dev/null | \
  jq -r '.message' | \
  sort | uniq -c | sort -rn | head -10 >> "$REPORT_DIR/daily/$DATE.md"

echo "✅ Report generated: $REPORT_DIR/daily/$DATE.md"
```

### 4. Monitoring Dashboard Config

```yaml
# monitoring-config.yml
monitoring:
  error_tracking:
    enabled: true
    log_level: ERROR
    retention_days: 90

  metrics:
    - name: error_rate
      type: counter
      description: "Total number of errors"

    - name: response_time
      type: histogram
      description: "API response time"

    - name: active_users
      type: gauge
      description: "Current active users"

  alerts:
    - name: high_error_rate
      condition: error_rate > 100/hour
      severity: critical
      notification: email, slack

    - name: slow_response
      condition: response_time > 2s
      severity: warning
      notification: slack

  dashboards:
    - name: system_health
      panels:
        - error_rate_chart
        - response_time_chart
        - active_users_gauge
```

### 5. Integration with CI/CD

```yaml
# .github/workflows/error-analysis.yml
name: Error Analysis

on:
  schedule:
    - cron: "0 0 * * *" # Daily at midnight
  workflow_dispatch:

jobs:
  analyze:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Analyze Errors
        run: |
          chmod +x scripts/analyze_errors.sh
          ./scripts/analyze_errors.sh

      - name: Upload Report
        uses: actions/upload-artifact@v3
        with:
          name: error-report
          path: logs/reports/daily/

      - name: Notify Team
        if: failure()
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: "Error analysis failed"
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

## Best Practices

### 1. Error Classification

- **Critical:** System failures, security breaches
- **High:** Feature failures, data corruption
- **Medium:** Performance issues, warnings
- **Low:** Info messages, debug logs

### 2. Retention Policy

- **Critical Logs:** 1 year
- **Error Logs:** 90 days
- **Info Logs:** 30 days
- **Debug Logs:** 7 days

### 3. Privacy & Security

- Never log sensitive data (passwords, tokens, PII)
- Sanitize error messages before logging
- Encrypt logs at rest
- Implement access controls

---

**تم إعداد هذا القالب بواسطة:** فريق وكلاء تطوير المشروع
**التاريخ:** [التاريخ]
**الإصدار:** 1.0
