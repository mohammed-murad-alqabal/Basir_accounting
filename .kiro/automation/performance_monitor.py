#!/usr/bin/env python3
"""
Performance Monitor - مراقب الأداء المستمر
المشروع: بصير MVP
المؤلف: فريق وكلاء تطوير مشروع بصير
التاريخ: 5 ديسمبر 2025
"""

import os
import psutil
import subprocess
import time
import logging
from datetime import datetime
from typing import Dict, List, Optional
from dataclasses import dataclass, asdict
from pathlib import Path

logger = logging.getLogger('PerformanceMonitor')


@dataclass
class SystemMetrics:
    """مقاييس النظام"""
    timestamp: datetime
    cpu_percent: float
    memory_percent: float
    disk_percent: float
    load_average: float
    process_count: int
    
    def to_dict(self) -> Dict:
        data = asdict(self)
        data['timestamp'] = self.timestamp.isoformat()
        return data


@dataclass
class ProjectMetrics:
    """مقاييس المشروع"""
    timestamp: datetime
    project_size_mb: float
    build_folder_size_mb: float
    test_coverage: float
    code_quality_score: int
    analyze_issues: int
    
    def to_dict(self) -> Dict:
        data = asdict(self)
        data['timestamp'] = self.timestamp.isoformat()
        return data


class PerformanceMonitor:
    """مراقب الأداء المستمر"""
    
    def __init__(self, config: Dict = None):
        """تهيئة المراقب"""
        self.config = config or self._default_config()
        self.metrics_history: List[SystemMetrics] = []
        self.project_metrics_history: List[ProjectMetrics] = []
        self.alerts: List[Dict] = []
        
        logger.info("📊 Performance Monitor initialized")
    
    def _default_config(self) -> Dict:
        """التكوينات الافتراضية"""
        return {
            'thresholds': {
                'cpu_percent': 80.0,
                'memory_percent': 85.0,
                'disk_percent': 90.0,
                'load_average': 8.0,
                'project_size_mb': 500.0,
                'build_time_seconds': 120.0
            },
            'monitoring': {
                'interval': 60,
                'history_retention': 1000
            }
        }
    
    def collect_system_metrics(self) -> SystemMetrics:
        """جمع مقاييس النظام"""
        try:
            cpu_percent = psutil.cpu_percent(interval=1)
            memory = psutil.virtual_memory()
            disk = psutil.disk_usage('/')
            load_avg = os.getloadavg()[0] if hasattr(os, 'getloadavg') else 0.0
            process_count = len(psutil.pids())
            
            metrics = SystemMetrics(
                timestamp=datetime.now(),
                cpu_percent=cpu_percent,
                memory_percent=memory.percent,
                disk_percent=disk.percent,
                load_average=load_avg,
                process_count=process_count
            )
            
            # حفظ في السجل
            self.metrics_history.append(metrics)
            self._trim_history()
            
            # التحقق من العتبات
            self._check_system_thresholds(metrics)
            
            logger.debug(f"System metrics collected: CPU={cpu_percent}%, MEM={memory.percent}%")
            return metrics
            
        except Exception as e:
            logger.error(f"Error collecting system metrics: {e}")
            return None
    
    def collect_project_metrics(self) -> ProjectMetrics:
        """جمع مقاييس المشروع"""
        try:
            # حجم المشروع
            project_size = self._get_directory_size('.')
            build_size = self._get_directory_size('build')
            
            # تغطية الاختبارات
            test_coverage = self._get_test_coverage()
            
            # جودة الكود
            code_quality = self._get_code_quality()
            
            # مشاكل التحليل
            analyze_issues = self._get_analyze_issues()
            
            metrics = ProjectMetrics(
                timestamp=datetime.now(),
                project_size_mb=project_size,
                build_folder_size_mb=build_size,
                test_coverage=test_coverage,
                code_quality_score=code_quality,
                analyze_issues=analyze_issues
            )
            
            # حفظ في السجل
            self.project_metrics_history.append(metrics)
            self._trim_history()
            
            # التحقق من العتبات
            self._check_project_thresholds(metrics)
            
            logger.debug(f"Project metrics collected: Size={project_size}MB, Coverage={test_coverage}%")
            return metrics
            
        except Exception as e:
            logger.error(f"Error collecting project metrics: {e}")
            return None
    
    def _get_directory_size(self, path: str) -> float:
        """حساب حجم مجلد بالميجابايت"""
        try:
            if not os.path.exists(path):
                return 0.0
            
            total_size = 0
            for dirpath, dirnames, filenames in os.walk(path):
                # تجاهل المجلدات المخفية
                dirnames[:] = [d for d in dirnames if not d.startswith('.')]
                
                for filename in filenames:
                    filepath = os.path.join(dirpath, filename)
                    if os.path.exists(filepath):
                        total_size += os.path.getsize(filepath)
            
            return total_size / (1024 * 1024)  # تحويل إلى MB
            
        except Exception as e:
            logger.error(f"Error calculating directory size for {path}: {e}")
            return 0.0
    
    def _get_test_coverage(self) -> float:
        """الحصول على تغطية الاختبارات"""
        try:
            coverage_file = Path('coverage/lcov.info')
            if not coverage_file.exists():
                return 0.0
            
            # قراءة ملف التغطية
            result = subprocess.run(
                ['lcov', '--summary', str(coverage_file)],
                capture_output=True,
                text=True,
                timeout=10
            )
            
            # استخراج النسبة
            for line in result.stdout.split('\n'):
                if 'lines' in line.lower():
                    parts = line.split()
                    for part in parts:
                        if '%' in part:
                            return float(part.replace('%', ''))
            
            return 0.0
            
        except Exception as e:
            logger.debug(f"Could not get test coverage: {e}")
            return 0.0
    
    def _get_code_quality(self) -> int:
        """الحصول على درجة جودة الكود (0-100)"""
        try:
            # تشغيل flutter analyze
            result = subprocess.run(
                ['flutter', 'analyze', '--no-pub'],
                capture_output=True,
                text=True,
                timeout=30
            )
            
            # حساب الدرجة بناءً على عدد المشاكل
            issues = result.stdout.count('•')
            
            if issues == 0:
                return 100
            elif issues <= 5:
                return 90
            elif issues <= 10:
                return 80
            elif issues <= 20:
                return 70
            else:
                return max(0, 70 - (issues - 20))
            
        except Exception as e:
            logger.debug(f"Could not get code quality: {e}")
            return 0
    
    def _get_analyze_issues(self) -> int:
        """الحصول على عدد مشاكل التحليل"""
        try:
            result = subprocess.run(
                ['flutter', 'analyze', '--no-pub'],
                capture_output=True,
                text=True,
                timeout=30
            )
            
            return result.stdout.count('•')
            
        except Exception as e:
            logger.debug(f"Could not get analyze issues: {e}")
            return 0
    
    def _check_system_thresholds(self, metrics: SystemMetrics):
        """التحقق من عتبات النظام"""
        thresholds = self.config['thresholds']
        
        if metrics.cpu_percent > thresholds['cpu_percent']:
            self._create_alert(
                'critical',
                'high_cpu_usage',
                f"CPU usage is {metrics.cpu_percent}% (threshold: {thresholds['cpu_percent']}%)",
                {'cpu_percent': metrics.cpu_percent}
            )
        
        if metrics.memory_percent > thresholds['memory_percent']:
            self._create_alert(
                'warning',
                'high_memory_usage',
                f"Memory usage is {metrics.memory_percent}% (threshold: {thresholds['memory_percent']}%)",
                {'memory_percent': metrics.memory_percent}
            )
        
        if metrics.disk_percent > thresholds['disk_percent']:
            self._create_alert(
                'critical',
                'high_disk_usage',
                f"Disk usage is {metrics.disk_percent}% (threshold: {thresholds['disk_percent']}%)",
                {'disk_percent': metrics.disk_percent}
            )
    
    def _check_project_thresholds(self, metrics: ProjectMetrics):
        """التحقق من عتبات المشروع"""
        thresholds = self.config['thresholds']
        
        if metrics.project_size_mb > thresholds['project_size_mb']:
            self._create_alert(
                'warning',
                'large_project_size',
                f"Project size is {metrics.project_size_mb:.1f}MB (threshold: {thresholds['project_size_mb']}MB)",
                {'project_size_mb': metrics.project_size_mb}
            )
        
        if metrics.code_quality_score < 70:
            self._create_alert(
                'warning',
                'low_code_quality',
                f"Code quality score is {metrics.code_quality_score}/100",
                {'code_quality_score': metrics.code_quality_score}
            )
    
    def _create_alert(self, severity: str, alert_type: str, message: str, data: Dict = None):
        """إنشاء تنبيه"""
        alert = {
            'timestamp': datetime.now().isoformat(),
            'severity': severity,
            'type': alert_type,
            'message': message,
            'data': data or {}
        }
        
        self.alerts.append(alert)
        
        # تسجيل التنبيه
        if severity == 'critical':
            logger.error(f"🔴 CRITICAL: {message}")
        elif severity == 'warning':
            logger.warning(f"🟡 WARNING: {message}")
        else:
            logger.info(f"🟢 INFO: {message}")
    
    def _trim_history(self):
        """تقليم السجل للحفاظ على الحجم"""
        max_history = self.config['monitoring']['history_retention']
        
        if len(self.metrics_history) > max_history:
            self.metrics_history = self.metrics_history[-max_history:]
        
        if len(self.project_metrics_history) > max_history:
            self.project_metrics_history = self.project_metrics_history[-max_history:]
    
    def get_performance_score(self) -> int:
        """حساب درجة الأداء الإجمالية (0-100)"""
        if not self.metrics_history or not self.project_metrics_history:
            return 0
        
        # أحدث المقاييس
        system = self.metrics_history[-1]
        project = self.project_metrics_history[-1]
        
        # حساب الدرجات الفرعية
        cpu_score = max(0, 100 - system.cpu_percent)
        memory_score = max(0, 100 - system.memory_percent)
        disk_score = max(0, 100 - system.disk_percent)
        quality_score = project.code_quality_score
        
        # المتوسط المرجح
        total_score = (
            cpu_score * 0.25 +
            memory_score * 0.25 +
            disk_score * 0.20 +
            quality_score * 0.30
        )
        
        return int(total_score)
    
    def get_summary(self) -> Dict:
        """الحصول على ملخص الأداء"""
        if not self.metrics_history or not self.project_metrics_history:
            return {'status': 'no_data'}
        
        system = self.metrics_history[-1]
        project = self.project_metrics_history[-1]
        
        return {
            'timestamp': datetime.now().isoformat(),
            'performance_score': self.get_performance_score(),
            'system': system.to_dict(),
            'project': project.to_dict(),
            'alerts_count': len(self.alerts),
            'recent_alerts': self.alerts[-5:] if self.alerts else []
        }


def main():
    """نقطة الدخول الرئيسية"""
    print("📊 Performance Monitor - مراقب الأداء المستمر")
    print("=" * 60)
    
    monitor = PerformanceMonitor()
    
    try:
        while True:
            # جمع المقاييس
            system_metrics = monitor.collect_system_metrics()
            project_metrics = monitor.collect_project_metrics()
            
            # عرض الملخص
            summary = monitor.get_summary()
            print(f"\n⏰ {datetime.now().strftime('%H:%M:%S')}")
            print(f"📊 Performance Score: {summary['performance_score']}/100")
            print(f"💻 CPU: {system_metrics.cpu_percent:.1f}%")
            print(f"🧠 Memory: {system_metrics.memory_percent:.1f}%")
            print(f"💾 Disk: {system_metrics.disk_percent:.1f}%")
            print(f"📦 Project Size: {project_metrics.project_size_mb:.1f}MB")
            print(f"✅ Code Quality: {project_metrics.code_quality_score}/100")
            
            if monitor.alerts:
                print(f"⚠️  Alerts: {len(monitor.alerts)}")
            
            # انتظار الفترة التالية
            time.sleep(monitor.config['monitoring']['interval'])
            
    except KeyboardInterrupt:
        print("\n⏹️  Monitor stopped by user")


if __name__ == "__main__":
    main()
