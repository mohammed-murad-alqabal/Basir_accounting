#!/usr/bin/env python3
"""
Intelligent Agents Automation System - Main Entry Point
نظام الأتمتة الذكي للوكلاء - نقطة الدخول الرئيسية

المشروع: بصير MVP
المؤلف: فريق وكلاء تطوير مشروع بصير
التاريخ: 5 ديسمبر 2025
"""

import os
import sys
import time
import signal
import logging
from pathlib import Path
from datetime import datetime
from typing import Optional

# إضافة المسار الحالي
sys.path.insert(0, str(Path(__file__).parent))

from orchestrator import AgentOrchestrator, Task, TaskPriority
from performance_monitor import PerformanceMonitor
from decision_engine import DecisionEngine, DecisionType
from alert_system import AlertSystem, AlertSeverity
from auto_healing import AutoHealing

# إعداد Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/main.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger('Main')


class IntelligentAgentsSystem:
    """النظام الذكي المتكامل للوكلاء"""
    
    def __init__(self):
        """تهيئة النظام"""
        logger.info("=" * 60)
        logger.info("🤖 Intelligent Agents Automation System")
        logger.info("   نظام الأتمتة الذكي للوكلاء")
        logger.info("=" * 60)
        
        # إنشاء المجلدات المطلوبة
        self._create_directories()
        
        # تهيئة المكونات
        logger.info("🔧 Initializing components...")
        self.orchestrator = AgentOrchestrator()
        self.performance_monitor = PerformanceMonitor()
        self.decision_engine = DecisionEngine()
        self.alert_system = AlertSystem()
        self.auto_healing = AutoHealing()
        
        self.running = False
        self.cycle_count = 0
        
        logger.info("✅ All components initialized successfully")
    
    def _create_directories(self):
        """إنشاء المجلدات المطلوبة"""
        directories = [
            'logs',
            'logs/alerts',
            'logs/reports',
            'logs/metrics'
        ]
        
        for directory in directories:
            Path(directory).mkdir(parents=True, exist_ok=True)
    
    def start(self):
        """بدء النظام"""
        logger.info("🚀 Starting Intelligent Agents System...")
        self.running = True
        
        # تسجيل معالج الإيقاف
        signal.signal(signal.SIGINT, self._signal_handler)
        signal.signal(signal.SIGTERM, self._signal_handler)
        
        try:
            # عرض معلومات البدء
            self._print_startup_info()
            
            # الحلقة الرئيسية
            while self.running:
                self._main_cycle()
                time.sleep(60)  # دورة كل دقيقة
                
        except Exception as e:
            logger.error(f"❌ System error: {e}", exc_info=True)
        finally:
            self.stop()
    
    def _main_cycle(self):
        """دورة رئيسية واحدة"""
        self.cycle_count += 1
        logger.info(f"🔄 Cycle #{self.cycle_count} started")
        
        try:
            # 1. جمع مقاييس الأداء
            system_metrics = self.performance_monitor.collect_system_metrics()
            project_metrics = self.performance_monitor.collect_project_metrics()
            
            if not system_metrics or not project_metrics:
                logger.warning("⚠️  Could not collect metrics")
                return
            
            # 2. إنشاء سياق للقرارات
            context = {
                'cpu_percent': system_metrics.cpu_percent,
                'memory_percent': system_metrics.memory_percent,
                'disk_percent': system_metrics.disk_percent,
                'load_average': system_metrics.load_average,
                'project_size_mb': project_metrics.project_size_mb,
                'build_folder_size_mb': project_metrics.build_folder_size_mb,
                'test_coverage': project_metrics.test_coverage,
                'code_quality_score': project_metrics.code_quality_score,
                'analyze_issues': project_metrics.analyze_issues,
                'performance_score': self.performance_monitor.get_performance_score(),
                'critical_alerts_count': len(self.alert_system.get_critical_alerts())
            }
            
            # 3. تقييم القواعد واتخاذ القرارات
            decisions = self.decision_engine.evaluate(context)
            
            # 4. معالجة القرارات الفورية
            immediate_decisions = self.decision_engine.get_immediate_decisions()
            for decision in immediate_decisions:
                logger.info(f"⚡ Executing immediate decision: {decision.action}")
                
                # محاولة الإصلاح الذاتي
                healing_result = self.auto_healing.heal(
                    decision.condition,
                    context
                )
                
                # تحديث حالة القرار
                self.decision_engine.mark_executed(
                    decision.id,
                    "success" if healing_result.success else "failed"
                )
                
                # إنشاء تنبيه
                if healing_result.success:
                    self.alert_system.create_alert(
                        'optimization_completed',
                        {'details': healing_result.message}
                    )
                else:
                    self.alert_system.create_alert(
                        decision.condition,
                        context
                    )
            
            # 5. جدولة القرارات المجدولة
            scheduled_decisions = self.decision_engine.get_scheduled_decisions()
            for decision in scheduled_decisions:
                logger.info(f"📅 Scheduling decision: {decision.action}")
                
                # إنشاء مهمة للمنسق
                task = Task(
                    id=decision.id,
                    agent=self._get_agent_for_action(decision.action),
                    action=decision.action,
                    priority=TaskPriority(decision.priority.value),
                    created_at=datetime.now(),
                    data={'decision_id': decision.id}
                )
                self.orchestrator.add_task(task)
                
                # تعليم كمنفذ
                self.decision_engine.mark_executed(decision.id, "scheduled")
            
            # 6. معالجة القرارات الاستراتيجية
            strategic_decisions = self.decision_engine.get_strategic_decisions()
            for decision in strategic_decisions:
                logger.info(f"🎯 Strategic decision: {decision.action}")
                
                # إنشاء تنبيه للمراجعة اليدوية
                self.alert_system.create_alert(
                    decision.condition,
                    context,
                    custom_message=f"قرار استراتيجي: {decision.description}"
                )
                
                self.decision_engine.mark_executed(decision.id, "notified")
            
            # 7. عرض ملخص الدورة
            self._print_cycle_summary(context)
            
        except Exception as e:
            logger.error(f"❌ Error in main cycle: {e}", exc_info=True)
    
    def _get_agent_for_action(self, action: str) -> str:
        """تحديد الوكيل المناسب للإجراء"""
        action_to_agent = {
            'schedule_testing_sprint': 'testing',
            'schedule_refactoring': 'development',
            'fix_analyze_issues': 'analysis',
            'cleanup_project': 'performance',
            'initiate_performance_audit': 'performance',
            'emergency_review': 'management'
        }
        return action_to_agent.get(action, 'management')
    
    def _print_startup_info(self):
        """عرض معلومات البدء"""
        print("\n" + "=" * 60)
        print("🤖 نظام الأتمتة الذكي للوكلاء")
        print("   Intelligent Agents Automation System")
        print("=" * 60)
        print(f"📅 التاريخ: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"💻 النظام: {os.uname().sysname} {os.uname().release}")
        print(f"🐍 Python: {sys.version.split()[0]}")
        print("=" * 60)
        print("\n✅ النظام يعمل الآن...")
        print("   اضغط Ctrl+C للإيقاف\n")
    
    def _print_cycle_summary(self, context: dict):
        """عرض ملخص الدورة"""
        performance_score = context.get('performance_score', 0)
        
        # رمز الحالة
        if performance_score >= 90:
            status_icon = "🟢"
            status_text = "ممتاز"
        elif performance_score >= 70:
            status_icon = "🟡"
            status_text = "جيد"
        else:
            status_icon = "🔴"
            status_text = "يحتاج تحسين"
        
        print(f"\n{status_icon} Cycle #{self.cycle_count} - {status_text}")
        print(f"   Performance: {performance_score}/100")
        print(f"   CPU: {context.get('cpu_percent', 0):.1f}%")
        print(f"   Memory: {context.get('memory_percent', 0):.1f}%")
        print(f"   Disk: {context.get('disk_percent', 0):.1f}%")
        
        # التنبيهات
        critical_count = len(self.alert_system.get_critical_alerts())
        warning_count = len(self.alert_system.get_warning_alerts())
        
        if critical_count > 0:
            print(f"   🔴 Critical Alerts: {critical_count}")
        if warning_count > 0:
            print(f"   🟡 Warnings: {warning_count}")
        
        # القرارات
        pending_decisions = len(self.decision_engine.decisions)
        if pending_decisions > 0:
            print(f"   📋 Pending Decisions: {pending_decisions}")
    
    def _signal_handler(self, signum, frame):
        """معالج إشارات الإيقاف"""
        logger.info(f"⏹️  Received signal {signum}, stopping...")
        self.running = False
    
    def stop(self):
        """إيقاف النظام"""
        logger.info("⏹️  Stopping Intelligent Agents System...")
        
        # إيقاف المكونات
        if hasattr(self, 'orchestrator'):
            self.orchestrator.stop()
        
        # حفظ التقارير النهائية
        self._save_final_reports()
        
        logger.info("✅ System stopped successfully")
        print("\n👋 وداعاً! تم إيقاف النظام بنجاح.\n")
    
    def _save_final_reports(self):
        """حفظ التقارير النهائية"""
        try:
            import json
            
            report = {
                'timestamp': datetime.now().isoformat(),
                'total_cycles': self.cycle_count,
                'performance': self.performance_monitor.get_summary(),
                'decisions': self.decision_engine.get_summary(),
                'alerts': self.alert_system.get_summary(),
                'healing': self.auto_healing.get_summary(),
                'agents': self.orchestrator.get_system_status()
            }
            
            report_file = Path('logs/reports/final_report.json')
            report_file.parent.mkdir(parents=True, exist_ok=True)
            
            with open(report_file, 'w', encoding='utf-8') as f:
                json.dump(report, f, indent=2, ensure_ascii=False)
            
            logger.info(f"📄 Final report saved to {report_file}")
            
        except Exception as e:
            logger.error(f"❌ Error saving final report: {e}")


def main():
    """نقطة الدخول الرئيسية"""
    try:
        system = IntelligentAgentsSystem()
        system.start()
    except KeyboardInterrupt:
        logger.info("⏹️  Interrupted by user")
    except Exception as e:
        logger.error(f"❌ Fatal error: {e}", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
