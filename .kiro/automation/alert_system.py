#!/usr/bin/env python3
"""
Alert System - نظام التنبيهات الذكي
المشروع: بصير MVP
المؤلف: فريق وكلاء تطوير مشروع بصير
التاريخ: 5 ديسمبر 2025
"""

import os
import json
import logging
from datetime import datetime
from typing import Dict, List, Optional
from dataclasses import dataclass, asdict
from enum import Enum
from pathlib import Path

logger = logging.getLogger('AlertSystem')


class AlertSeverity(Enum):
    """مستويات خطورة التنبيهات"""
    CRITICAL = "critical"  # 🔴 حرج
    WARNING = "warning"    # 🟡 تحذير
    INFO = "info"          # 🟢 معلومات


class AlertChannel(Enum):
    """قنوات التنبيه"""
    LOG = "log"            # السجل
    FILE = "file"          # ملف
    CONSOLE = "console"    # الطرفية
    EMAIL = "email"        # البريد الإلكتروني (مستقبلاً)
    SLACK = "slack"        # Slack (مستقبلاً)


@dataclass
class Alert:
    """تنبيه"""
    id: str
    severity: AlertSeverity
    type: str
    message: str
    timestamp: datetime
    data: Dict = None
    acknowledged: bool = False
    resolved: bool = False
    
    def to_dict(self) -> Dict:
        data = asdict(self)
        data['severity'] = self.severity.value
        data['timestamp'] = self.timestamp.isoformat()
        return data


class AlertSystem:
    """نظام التنبيهات الذكي"""
    
    def __init__(self, config: Dict = None):
        """تهيئة النظام"""
        self.config = config or self._default_config()
        self.alerts: List[Alert] = []
        self.alert_history: List[Alert] = []
        self.alert_rules: Dict[str, Dict] = {}
        
        # إنشاء مجلد التنبيهات
        self.alerts_dir = Path('logs/alerts')
        self.alerts_dir.mkdir(parents=True, exist_ok=True)
        
        # تحميل قواعد التنبيه
        self._load_alert_rules()
        
        logger.info("🔔 Alert System initialized")
    
    def _default_config(self) -> Dict:
        """التكوينات الافتراضية"""
        return {
            'channels': {
                'log': True,
                'file': True,
                'console': True,
                'email': False,
                'slack': False
            },
            'severity_channels': {
                'critical': ['log', 'file', 'console'],
                'warning': ['log', 'file'],
                'info': ['log']
            },
            'retention': {
                'critical': 30,  # أيام
                'warning': 14,
                'info': 7
            }
        }
    
    def _load_alert_rules(self):
        """تحميل قواعد التنبيه"""
        self.alert_rules = {
            # تنبيهات حرجة
            'high_cpu_usage': {
                'severity': AlertSeverity.CRITICAL,
                'threshold': 90,
                'message_template': 'استهلاك CPU عالي جداً: {value}%'
            },
            'high_disk_usage': {
                'severity': AlertSeverity.CRITICAL,
                'threshold': 90,
                'message_template': 'مساحة القرص منخفضة: {value}%'
            },
            'build_failure': {
                'severity': AlertSeverity.CRITICAL,
                'message_template': 'فشل البناء: {error}'
            },
            'security_vulnerability': {
                'severity': AlertSeverity.CRITICAL,
                'message_template': 'ثغرة أمنية مكتشفة: {details}'
            },
            
            # تنبيهات تحذيرية
            'high_memory_usage': {
                'severity': AlertSeverity.WARNING,
                'threshold': 85,
                'message_template': 'استهلاك الذاكرة عالي: {value}%'
            },
            'low_test_coverage': {
                'severity': AlertSeverity.WARNING,
                'threshold': 70,
                'message_template': 'تغطية الاختبارات منخفضة: {value}%'
            },
            'low_code_quality': {
                'severity': AlertSeverity.WARNING,
                'threshold': 70,
                'message_template': 'جودة الكود منخفضة: {value}/100'
            },
            'large_project_size': {
                'severity': AlertSeverity.WARNING,
                'threshold': 500,
                'message_template': 'حجم المشروع كبير: {value}MB'
            },
            
            # تنبيهات معلوماتية
            'optimization_completed': {
                'severity': AlertSeverity.INFO,
                'message_template': 'اكتمل التحسين: {details}'
            },
            'tests_passed': {
                'severity': AlertSeverity.INFO,
                'message_template': 'نجحت جميع الاختبارات: {count} اختبار'
            },
            'deployment_successful': {
                'severity': AlertSeverity.INFO,
                'message_template': 'نجح النشر: {version}'
            }
        }
        
        logger.info(f"✅ Loaded {len(self.alert_rules)} alert rules")
    
    def create_alert(
        self,
        alert_type: str,
        data: Dict = None,
        custom_message: str = None
    ) -> Alert:
        """إنشاء تنبيه"""
        
        # الحصول على قاعدة التنبيه
        rule = self.alert_rules.get(alert_type)
        if not rule:
            logger.warning(f"⚠️  Unknown alert type: {alert_type}")
            rule = {
                'severity': AlertSeverity.INFO,
                'message_template': custom_message or 'تنبيه: {alert_type}'
            }
        
        # إنشاء الرسالة
        if custom_message:
            message = custom_message
        else:
            message = rule['message_template'].format(**(data or {}))
        
        # إنشاء التنبيه
        alert = Alert(
            id=f"{alert_type}_{int(datetime.now().timestamp())}",
            severity=rule['severity'],
            type=alert_type,
            message=message,
            timestamp=datetime.now(),
            data=data
        )
        
        # حفظ التنبيه
        self.alerts.append(alert)
        
        # إرسال التنبيه
        self._send_alert(alert)
        
        # حفظ في ملف
        self._save_alert_to_file(alert)
        
        logger.info(f"🔔 Alert created: {alert.type} - {alert.message}")
        return alert
    
    def _send_alert(self, alert: Alert):
        """إرسال التنبيه عبر القنوات المناسبة"""
        channels = self.config['severity_channels'].get(
            alert.severity.value,
            ['log']
        )
        
        for channel in channels:
            if channel == 'log':
                self._send_to_log(alert)
            elif channel == 'file':
                self._send_to_file(alert)
            elif channel == 'console':
                self._send_to_console(alert)
    
    def _send_to_log(self, alert: Alert):
        """إرسال إلى السجل"""
        if alert.severity == AlertSeverity.CRITICAL:
            logger.error(f"🔴 CRITICAL: {alert.message}")
        elif alert.severity == AlertSeverity.WARNING:
            logger.warning(f"🟡 WARNING: {alert.message}")
        else:
            logger.info(f"🟢 INFO: {alert.message}")
    
    def _send_to_file(self, alert: Alert):
        """إرسال إلى ملف"""
        # تم التعامل معه في _save_alert_to_file
        pass
    
    def _send_to_console(self, alert: Alert):
        """إرسال إلى الطرفية"""
        icon = {
            AlertSeverity.CRITICAL: "🔴",
            AlertSeverity.WARNING: "🟡",
            AlertSeverity.INFO: "🟢"
        }.get(alert.severity, "ℹ️")
        
        print(f"\n{icon} [{alert.severity.value.upper()}] {alert.message}")
        if alert.data:
            print(f"   Data: {json.dumps(alert.data, ensure_ascii=False)}")
    
    def _save_alert_to_file(self, alert: Alert):
        """حفظ التنبيه في ملف"""
        try:
            # ملف اليوم
            date_str = datetime.now().strftime('%Y-%m-%d')
            alert_file = self.alerts_dir / f"alerts_{date_str}.json"
            
            # قراءة التنبيهات الموجودة
            alerts_data = []
            if alert_file.exists():
                with open(alert_file, 'r', encoding='utf-8') as f:
                    alerts_data = json.load(f)
            
            # إضافة التنبيه الجديد
            alerts_data.append(alert.to_dict())
            
            # حفظ
            with open(alert_file, 'w', encoding='utf-8') as f:
                json.dump(alerts_data, f, indent=2, ensure_ascii=False)
            
        except Exception as e:
            logger.error(f"❌ Error saving alert to file: {e}")
    
    def acknowledge_alert(self, alert_id: str) -> bool:
        """الإقرار بالتنبيه"""
        for alert in self.alerts:
            if alert.id == alert_id:
                alert.acknowledged = True
                logger.info(f"✅ Alert {alert_id} acknowledged")
                return True
        
        logger.warning(f"⚠️  Alert {alert_id} not found")
        return False
    
    def resolve_alert(self, alert_id: str) -> bool:
        """حل التنبيه"""
        for alert in self.alerts:
            if alert.id == alert_id:
                alert.resolved = True
                alert.acknowledged = True
                
                # نقل إلى السجل
                self.alert_history.append(alert)
                self.alerts.remove(alert)
                
                logger.info(f"✅ Alert {alert_id} resolved")
                return True
        
        logger.warning(f"⚠️  Alert {alert_id} not found")
        return False
    
    def get_active_alerts(
        self,
        severity: Optional[AlertSeverity] = None
    ) -> List[Alert]:
        """الحصول على التنبيهات النشطة"""
        if severity:
            return [a for a in self.alerts if a.severity == severity]
        return self.alerts.copy()
    
    def get_critical_alerts(self) -> List[Alert]:
        """الحصول على التنبيهات الحرجة"""
        return self.get_active_alerts(AlertSeverity.CRITICAL)
    
    def get_warning_alerts(self) -> List[Alert]:
        """الحصول على التنبيهات التحذيرية"""
        return self.get_active_alerts(AlertSeverity.WARNING)
    
    def get_info_alerts(self) -> List[Alert]:
        """الحصول على التنبيهات المعلوماتية"""
        return self.get_active_alerts(AlertSeverity.INFO)
    
    def cleanup_old_alerts(self):
        """تنظيف التنبيهات القديمة"""
        retention = self.config['retention']
        now = datetime.now()
        
        for alert in self.alert_history[:]:
            days_old = (now - alert.timestamp).days
            max_days = retention.get(alert.severity.value, 7)
            
            if days_old > max_days:
                self.alert_history.remove(alert)
                logger.debug(f"🗑️  Removed old alert: {alert.id}")
    
    def get_summary(self) -> Dict:
        """الحصول على ملخص التنبيهات"""
        return {
            'timestamp': datetime.now().isoformat(),
            'active_alerts': len(self.alerts),
            'critical_alerts': len(self.get_critical_alerts()),
            'warning_alerts': len(self.get_warning_alerts()),
            'info_alerts': len(self.get_info_alerts()),
            'unacknowledged_alerts': len([a for a in self.alerts if not a.acknowledged]),
            'resolved_alerts': len(self.alert_history)
        }
    
    def get_dashboard_data(self) -> Dict:
        """الحصول على بيانات لوحة التحكم"""
        return {
            'summary': self.get_summary(),
            'recent_alerts': [a.to_dict() for a in self.alerts[-10:]],
            'critical_alerts': [a.to_dict() for a in self.get_critical_alerts()],
            'warning_alerts': [a.to_dict() for a in self.get_warning_alerts()[:5]]
        }


def main():
    """نقطة الدخول الرئيسية"""
    print("🔔 Alert System - نظام التنبيهات الذكي")
    print("=" * 60)
    
    alert_system = AlertSystem()
    
    # أمثلة على التنبيهات
    print("\n📋 Creating sample alerts...")
    
    alert_system.create_alert('high_cpu_usage', {'value': 95})
    alert_system.create_alert('low_test_coverage', {'value': 65})
    alert_system.create_alert('tests_passed', {'count': 156})
    alert_system.create_alert('optimization_completed', {'details': 'تم توفير 2GB'})
    
    # عرض الملخص
    summary = alert_system.get_summary()
    print(f"\n📊 Summary:")
    print(f"  Active Alerts: {summary['active_alerts']}")
    print(f"  Critical: {summary['critical_alerts']}")
    print(f"  Warning: {summary['warning_alerts']}")
    print(f"  Info: {summary['info_alerts']}")
    print(f"  Unacknowledged: {summary['unacknowledged_alerts']}")
    
    # عرض التنبيهات الحرجة
    critical = alert_system.get_critical_alerts()
    if critical:
        print(f"\n🔴 Critical Alerts:")
        for alert in critical:
            print(f"  - {alert.message}")


if __name__ == "__main__":
    main()
