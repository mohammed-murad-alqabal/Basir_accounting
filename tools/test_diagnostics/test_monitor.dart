/// Test Monitoring System
///
/// Provides real-time monitoring of test health and performance
/// with automated alerting and historical tracking.
///
/// **Feature: test-failures-resolution, Property 13: Preventive Maintenance Alerting**
/// **Validates: Requirements 6.5**

library test_monitor;

// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars, avoid_slow_async_io, no_default_cases, discarded_futures, avoid_catches_without_on_clauses
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'test_failure_analyzer.dart';

/// Test health status levels
enum TestHealthStatus {
  /// Excellent status: 95%+ success rate
  excellent,

  /// Good status: 85-94% success rate
  good,

  /// Fair status: 70-84% success rate
  fair,

  /// Poor status: 55-69% success rate
  poor,

  /// Critical status: <55% success rate
  critical
}

/// Alert severity levels
enum AlertSeverity { info, warning, error, critical }

/// Represents a test health alert
class TestAlert {
  const TestAlert({
    required this.id,
    required this.severity,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.metadata,
    required this.actionItems,
  });

  factory TestAlert.fromJson(Map<String, dynamic> json) => TestAlert(
        id: json['id']?.toString() ?? '',
        severity:
            AlertSeverity.values.byName(json['severity']?.toString() ?? 'info'),
        title: json['title']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
        timestamp: DateTime.parse(
          json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
        ),
        metadata: json['metadata'] is Map
            ? Map<String, dynamic>.from(json['metadata'] as Map)
            : <String, dynamic>{},
        actionItems: json['actionItems'] is List
            ? List<String>.from(
                (json['actionItems'] as List).map((e) => e?.toString() ?? ''),
              )
            : <String>[],
      );
  final String id;
  final AlertSeverity severity;
  final String title;
  final String message;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final List<String> actionItems;

  Map<String, dynamic> toJson() => {
        'id': id,
        'severity': severity.name,
        'title': title,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'metadata': metadata,
        'actionItems': actionItems,
      };
}

/// Historical test performance data
class TestPerformanceHistory {
  const TestPerformanceHistory({
    required this.timestamp,
    required this.metrics,
    required this.healthStatus,
    required this.criticalFailures,
  });

  factory TestPerformanceHistory.fromJson(Map<String, dynamic> json) =>
      TestPerformanceHistory(
        timestamp: DateTime.parse(
          json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
        ),
        metrics: TestMetrics(
          totalTests: (json['metrics']?['totalTests'] as num?)?.toInt() ?? 0,
          passedTests: (json['metrics']?['passedTests'] as num?)?.toInt() ?? 0,
          failedTests: (json['metrics']?['failedTests'] as num?)?.toInt() ?? 0,
          skippedTests:
              (json['metrics']?['skippedTests'] as num?)?.toInt() ?? 0,
          successRate:
              (json['metrics']?['successRate'] as num?)?.toDouble() ?? 0.0,
          totalExecutionTime: Duration(
            milliseconds:
                (json['metrics']?['totalExecutionTime'] as num?)?.toInt() ?? 0,
          ),
          lastRun: DateTime.parse(
            json['metrics']?['lastRun']?.toString() ??
                DateTime.now().toIso8601String(),
          ),
          failuresByType: json['metrics']?['failuresByType'] is Map
              ? Map<TestFailureType, int>.fromEntries(
                  (json['metrics']['failuresByType'] as Map<String, dynamic>)
                      .entries
                      .map(
                        (e) => MapEntry(
                          TestFailureType.values.byName(e.key),
                          (e.value as num?)?.toInt() ?? 0,
                        ),
                      ),
                )
              : <TestFailureType, int>{},
        ),
        healthStatus: TestHealthStatus.values.byName(
          json['healthStatus']?.toString() ?? 'unknown',
        ),
        criticalFailures: json['criticalFailures'] is List
            ? (json['criticalFailures'] as List)
                .whereType<Map<String, dynamic>>()
                .map(TestFailure.fromJson)
                .toList()
            : <TestFailure>[],
      );
  final DateTime timestamp;
  final TestMetrics metrics;
  final TestHealthStatus healthStatus;
  final List<TestFailure> criticalFailures;

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'metrics': metrics.toJson(),
        'healthStatus': healthStatus.name,
        'criticalFailures': criticalFailures.map((f) => f.toJson()).toList(),
      };
}

/// Main test monitoring system
class TestMonitor {
  static const Duration _monitoringInterval = Duration(minutes: 5);
  static const Duration _alertCooldown = Duration(minutes: 15);
  static const int _maxHistoryEntries = 100;

  final TestFailureAnalyzer _analyzer = TestFailureAnalyzer();
  final List<TestPerformanceHistory> _history = [];
  final List<TestAlert> _activeAlerts = [];
  final Map<String, DateTime> _lastAlertTimes = {};

  Timer? _monitoringTimer;
  bool _isMonitoring = false;

  /// Starts continuous test monitoring
  ///
  /// **Feature: test-failures-resolution, Property 11: Test Failure Detection Speed**
  /// **Validates: Requirements 6.1, 6.2**
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    print('🔍 بدء مراقبة الاختبارات المستمرة...');

    _monitoringTimer = Timer.periodic(_monitoringInterval, (_) {
      _performHealthCheck();
    });

    // Perform initial check
    _performHealthCheck();
  }

  /// Stops test monitoring
  void stopMonitoring() {
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    print('⏹️ تم إيقاف مراقبة الاختبارات');
  }

  /// Performs a comprehensive health check
  ///
  /// **Feature: test-failures-resolution, Property 13: Preventive Maintenance Alerting**
  /// **Validates: Requirements 6.5**
  Future<void> _performHealthCheck() async {
    try {
      print('🔍 إجراء فحص صحة الاختبارات...');

      // Run quick test analysis
      final testResult = await Process.run(
        'flutter',
        ['test', '--reporter=compact', '--timeout=30s'],
        workingDirectory: '.',
      );

      final testOutput =
          testResult.stdout.toString() + testResult.stderr.toString();
      final failures = await _analyzer.analyzeTestOutput(testOutput);
      final metrics = _analyzer.generateMetrics();
      final healthStatus = _calculateHealthStatus(metrics.successRate);

      // Record performance history
      final historyEntry = TestPerformanceHistory(
        timestamp: DateTime.now(),
        metrics: metrics,
        healthStatus: healthStatus,
        criticalFailures:
            failures.where((f) => f.priority == Priority.critical).toList(),
      );

      _addToHistory(historyEntry);

      // Check for alerts
      await _checkForAlerts(historyEntry);

      print(
        '✅ فحص الصحة مكتمل - الحالة: ${_getHealthStatusName(healthStatus)}',
      );
    } catch (e) {
      print('❌ خطأ في فحص الصحة: $e');
      await _createAlert(
        AlertSeverity.error,
        'فشل فحص صحة الاختبارات',
        'حدث خطأ أثناء فحص صحة الاختبارات: $e',
        {'error': e.toString()},
        ['تحقق من إعدادات البيئة', 'راجع سجلات النظام'],
      );
    }
  }

  /// Calculates health status based on success rate
  TestHealthStatus _calculateHealthStatus(double successRate) {
    if (successRate >= 95.0) return TestHealthStatus.excellent;
    if (successRate >= 85.0) return TestHealthStatus.good;
    if (successRate >= 70.0) return TestHealthStatus.fair;
    if (successRate >= 55.0) return TestHealthStatus.poor;
    return TestHealthStatus.critical;
  }

  /// Checks for conditions that require alerts
  ///
  /// **Feature: test-failures-resolution, Property 13: Preventive Maintenance Alerting**
  /// **Validates: Requirements 6.5**
  Future<void> _checkForAlerts(TestPerformanceHistory current) async {
    // Check for declining performance trend
    if (_history.length >= 3) {
      final recent = _history.length >= 3
          ? _history.sublist(_history.length - 3)
          : _history;
      final isDecline =
          _isDecreasingTrend(recent.map((h) => h.metrics.successRate).toList());

      if (isDecline && current.metrics.successRate < 90.0) {
        await _createAlert(
          AlertSeverity.warning,
          'انخفاض في أداء الاختبارات',
          'تم اكتشاف انخفاض مستمر في معدل نجاح الاختبارات',
          {
            'currentSuccessRate': current.metrics.successRate,
            'trend': 'declining',
            'recentRates': recent.map((h) => h.metrics.successRate).toList(),
          },
          [
            'مراجعة الاختبارات الفاشلة الجديدة',
            'تحقق من التغييرات الأخيرة في الكود',
            'تشغيل تحليل شامل للأخطاء',
          ],
        );
      }
    }

    // Check for critical health status
    if (current.healthStatus == TestHealthStatus.critical) {
      await _createAlert(
        AlertSeverity.critical,
        'حالة حرجة في الاختبارات',
        'معدل نجاح الاختبارات أقل من 55% - يتطلب تدخل فوري',
        {
          'successRate': current.metrics.successRate,
          'failedTests': current.metrics.failedTests,
          'criticalFailures': current.criticalFailures.length,
        },
        [
          'إيقاف النشر حتى إصلاح المشاكل',
          'تشغيل تحليل شامل للأخطاء',
          'مراجعة التغييرات الأخيرة',
          'تصعيد للفريق التقني',
        ],
      );
    }

    // Check for high number of golden test failures
    final goldenFailures =
        current.metrics.failuresByType[TestFailureType.golden] ?? 0;
    if (goldenFailures > 5) {
      await _createAlert(
        AlertSeverity.warning,
        'عدد كبير من أخطاء Golden Tests',
        'تم اكتشاف $goldenFailures خطأ في Golden Tests',
        {'goldenFailures': goldenFailures},
        [
          'تشغيل: flutter test --update-goldens',
          'مراجعة التغييرات في واجهة المستخدم',
          'تحديث ملفات Golden المرجعية',
        ],
      );
    }

    // Check for timeout issues
    final timeoutFailures = current.criticalFailures
        .where((f) => f.type == TestFailureType.timeout)
        .length;
    if (timeoutFailures > 0) {
      await _createAlert(
        AlertSeverity.error,
        'مشاكل timeout في الاختبارات',
        'تم اكتشاف $timeoutFailures اختبار يعاني من مشاكل timeout',
        {'timeoutFailures': timeoutFailures},
        [
          'زيادة قيم timeout للاختبارات',
          'تحسين أداء الاختبارات',
          'مراجعة استخدام pumpAndSettle',
        ],
      );
    }

    // Check for maintenance needs based on test age
    await _checkMaintenanceNeeds(current);
  }

  /// Checks if maintenance is needed based on various factors
  ///
  /// **Feature: test-failures-resolution, Property 13: Preventive Maintenance Alerting**
  /// **Validates: Requirements 6.5**
  Future<void> _checkMaintenanceNeeds(TestPerformanceHistory current) async {
    final now = DateTime.now();

    // Check if golden files need updating (weekly check)
    final lastGoldenUpdate = await _getLastGoldenUpdateTime();
    if (lastGoldenUpdate != null &&
        now.difference(lastGoldenUpdate).inDays > 7 &&
        current.metrics.failuresByType[TestFailureType.golden] != null) {
      await _createAlert(
        AlertSeverity.info,
        'صيانة دورية مطلوبة - Golden Tests',
        'لم يتم تحديث Golden Tests منذ أكثر من أسبوع',
        {'daysSinceUpdate': now.difference(lastGoldenUpdate).inDays},
        [
          'مراجعة وتحديث Golden Tests',
          'تشغيل: flutter test --update-goldens',
          'التحقق من تغييرات واجهة المستخدم',
        ],
      );
    }

    // Check test execution time trends
    if (_history.length >= 5) {
      final recentTimes = _history.length >= 5
          ? _history
              .sublist(_history.length - 5)
              .map((h) => h.metrics.totalExecutionTime.inMinutes)
              .toList()
          : _history
              .map((h) => h.metrics.totalExecutionTime.inMinutes)
              .toList();

      final avgTime = recentTimes.reduce((a, b) => a + b) / recentTimes.length;
      if (avgTime > 10) {
        // More than 10 minutes average
        await _createAlert(
          AlertSeverity.warning,
          'وقت تنفيذ الاختبارات طويل',
          'متوسط وقت تنفيذ الاختبارات: ${avgTime.toStringAsFixed(1)} دقيقة',
          {'averageExecutionTime': avgTime},
          [
            'تحسين أداء الاختبارات',
            'مراجعة الاختبارات البطيئة',
            'استخدام mocking للعمليات البطيئة',
          ],
        );
      }
    }
  }

  /// Creates and manages alerts with cooldown
  Future<void> _createAlert(
    AlertSeverity severity,
    String title,
    String message,
    Map<String, dynamic> metadata,
    List<String> actionItems,
  ) async {
    final alertId = '${title.hashCode}_${severity.name}';
    final now = DateTime.now();

    // Check cooldown
    final lastAlert = _lastAlertTimes[alertId];
    if (lastAlert != null && now.difference(lastAlert) < _alertCooldown) {
      return; // Skip duplicate alert within cooldown period
    }

    final alert = TestAlert(
      id: alertId,
      severity: severity,
      title: title,
      message: message,
      timestamp: now,
      metadata: metadata,
      actionItems: actionItems,
    );

    _activeAlerts.add(alert);
    _lastAlertTimes[alertId] = now;

    // Print alert to console
    final severityIcon = _getSeverityIcon(severity);
    print('\n$severityIcon تنبيه: $title');
    print('   📝 $message');
    if (actionItems.isNotEmpty) {
      print('   🔧 الإجراءات المطلوبة:');
      for (var i = 0; i < actionItems.length; i++) {
        print('      ${i + 1}. ${actionItems[i]}');
      }
    }
    print('');

    // Save alert to file
    await _saveAlert(alert);
  }

  /// Helper methods
  void _addToHistory(TestPerformanceHistory entry) {
    _history.add(entry);
    if (_history.length > _maxHistoryEntries) {
      _history.removeAt(0);
    }
  }

  bool _isDecreasingTrend(List<double> values) {
    if (values.length < 2) return false;

    for (var i = 1; i < values.length; i++) {
      if (values[i] >= values[i - 1]) return false;
    }
    return true;
  }

  Future<DateTime?> _getLastGoldenUpdateTime() async {
    try {
      final goldenDir = Directory('test/golden');
      if (!await goldenDir.exists()) return null;

      final files = await goldenDir
          .list(recursive: true)
          .where((f) => f.path.endsWith('.png'))
          .toList();

      if (files.isEmpty) return null;

      DateTime? latest;
      for (final file in files) {
        final stat = await file.stat();
        if (latest == null || stat.modified.isAfter(latest)) {
          latest = stat.modified;
        }
      }

      return latest;
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveAlert(TestAlert alert) async {
    try {
      final alertsDir = Directory('test_results/alerts');
      await alertsDir.create(recursive: true);

      final alertFile = File(
        '${alertsDir.path}/alert_${alert.id}_${alert.timestamp.millisecondsSinceEpoch}.json',
      );
      await alertFile.writeAsString(jsonEncode(alert.toJson()));
    } on Exception catch (e) {
      print('❌ فشل في حفظ التنبيه: $e');
    }
  }

  String _getSeverityIcon(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.info:
        return 'ℹ️';
      case AlertSeverity.warning:
        return '⚠️';
      case AlertSeverity.error:
        return '❌';
      case AlertSeverity.critical:
        return '🚨';
    }
  }

  /// Gets the display name for a health status
  String _getHealthStatusName(TestHealthStatus status) {
    switch (status) {
      case TestHealthStatus.excellent:
        return 'ممتاز';
      case TestHealthStatus.good:
        return 'جيد';
      case TestHealthStatus.fair:
        return 'مقبول';
      case TestHealthStatus.poor:
        return 'ضعيف';
      case TestHealthStatus.critical:
        return 'حرج';
    }
  }

  /// The history of test performance
  List<TestPerformanceHistory> get history => List.unmodifiable(_history);

  /// The list of active alerts
  List<TestAlert> get activeAlerts => List.unmodifiable(_activeAlerts);
  bool get isMonitoring => _isMonitoring;

  /// Save monitoring data
  Future<void> saveMonitoringData(String filePath) async {
    final data = {
      'timestamp': DateTime.now().toIso8601String(),
      'history': _history.map((h) => h.toJson()).toList(),
      'activeAlerts': _activeAlerts.map((a) => a.toJson()).toList(),
    };

    final file = File(filePath);
    await file.writeAsString(jsonEncode(data));
  }

  /// Load monitoring data
  Future<void> loadMonitoringData(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return;

    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;

    _history.clear();
    _activeAlerts.clear();

    for (final historyData in data['history'] as List) {
      _history.add(
        TestPerformanceHistory.fromJson(
          historyData as Map<String, dynamic>,
        ),
      );
    }

    for (final alertData in data['activeAlerts'] as List) {
      _activeAlerts.add(
        TestAlert.fromJson(
          alertData as Map<String, dynamic>,
        ),
      );
    }
  }
}
