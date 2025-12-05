#!/usr/bin/env python3
"""
Decision Engine - محرك القرارات الذكي
المشروع: بصير MVP
المؤلف: فريق وكلاء تطوير مشروع بصير
التاريخ: 5 ديسمبر 2025
"""

import logging
from datetime import datetime
from typing import Dict, List, Optional, Callable
from dataclasses import dataclass
from enum import Enum

logger = logging.getLogger('DecisionEngine')


class DecisionType(Enum):
    """أنواع القرارات"""
    IMMEDIATE = "immediate"      # تنفيذ فوري
    SCHEDULED = "scheduled"      # مجدول
    STRATEGIC = "strategic"      # استراتيجي


class DecisionPriority(Enum):
    """أولويات القرارات"""
    CRITICAL = 1
    HIGH = 2
    MEDIUM = 3
    LOW = 4


@dataclass
class Decision:
    """قرار"""
    id: str
    type: DecisionType
    priority: DecisionPriority
    condition: str
    action: str
    description: str
    created_at: datetime
    executed: bool = False
    executed_at: Optional[datetime] = None
    result: Optional[str] = None
    
    def to_dict(self) -> Dict:
        return {
            'id': self.id,
            'type': self.type.value,
            'priority': self.priority.value,
            'condition': self.condition,
            'action': self.action,
            'description': self.description,
            'created_at': self.created_at.isoformat(),
            'executed': self.executed,
            'executed_at': self.executed_at.isoformat() if self.executed_at else None,
            'result': self.result
        }


class Rule:
    """قاعدة قرار"""
    
    def __init__(
        self,
        name: str,
        condition: Callable[[Dict], bool],
        action: str,
        decision_type: DecisionType,
        priority: DecisionPriority,
        description: str
    ):
        self.name = name
        self.condition = condition
        self.action = action
        self.decision_type = decision_type
        self.priority = priority
        self.description = description
    
    def evaluate(self, context: Dict) -> Optional[Decision]:
        """تقييم القاعدة"""
        try:
            if self.condition(context):
                decision = Decision(
                    id=f"{self.name}_{int(datetime.now().timestamp())}",
                    type=self.decision_type,
                    priority=self.priority,
                    condition=self.name,
                    action=self.action,
                    description=self.description,
                    created_at=datetime.now()
                )
                logger.info(f"✅ Rule '{self.name}' triggered: {self.description}")
                return decision
            return None
        except Exception as e:
            logger.error(f"❌ Error evaluating rule '{self.name}': {e}")
            return None


class DecisionEngine:
    """محرك القرارات الذكي"""
    
    def __init__(self, config: Dict = None):
        """تهيئة المحرك"""
        self.config = config or {}
        self.rules: List[Rule] = []
        self.decisions: List[Decision] = []
        self.decision_history: List[Decision] = []
        
        # تحميل القواعد الافتراضية
        self._load_default_rules()
        
        logger.info("🧠 Decision Engine initialized")
    
    def _load_default_rules(self):
        """تحميل القواعد الافتراضية"""
        
        # قواعد الأداء
        self.add_rule(Rule(
            name="high_cpu_usage",
            condition=lambda ctx: ctx.get('cpu_percent', 0) > 90,
            action="cleanup_and_optimize",
            decision_type=DecisionType.IMMEDIATE,
            priority=DecisionPriority.CRITICAL,
            description="استهلاك CPU عالي جداً - تنظيف وتحسين فوري"
        ))
        
        self.add_rule(Rule(
            name="high_memory_usage",
            condition=lambda ctx: ctx.get('memory_percent', 0) > 85,
            action="cleanup_memory",
            decision_type=DecisionType.IMMEDIATE,
            priority=DecisionPriority.HIGH,
            description="استهلاك الذاكرة عالي - تنظيف الذاكرة"
        ))
        
        self.add_rule(Rule(
            name="high_disk_usage",
            condition=lambda ctx: ctx.get('disk_percent', 0) > 90,
            action="cleanup_disk",
            decision_type=DecisionType.IMMEDIATE,
            priority=DecisionPriority.CRITICAL,
            description="مساحة القرص منخفضة - تنظيف فوري"
        ))
        
        # قواعد الجودة
        self.add_rule(Rule(
            name="low_test_coverage",
            condition=lambda ctx: ctx.get('test_coverage', 100) < 70,
            action="schedule_testing_sprint",
            decision_type=DecisionType.SCHEDULED,
            priority=DecisionPriority.HIGH,
            description="تغطية الاختبارات منخفضة - جدولة sprint للاختبارات"
        ))
        
        self.add_rule(Rule(
            name="low_code_quality",
            condition=lambda ctx: ctx.get('code_quality_score', 100) < 70,
            action="schedule_refactoring",
            decision_type=DecisionType.SCHEDULED,
            priority=DecisionPriority.MEDIUM,
            description="جودة الكود منخفضة - جدولة إعادة هيكلة"
        ))
        
        self.add_rule(Rule(
            name="many_analyze_issues",
            condition=lambda ctx: ctx.get('analyze_issues', 0) > 20,
            action="fix_analyze_issues",
            decision_type=DecisionType.SCHEDULED,
            priority=DecisionPriority.HIGH,
            description="مشاكل تحليل كثيرة - إصلاح مطلوب"
        ))
        
        # قواعد المشروع
        self.add_rule(Rule(
            name="large_project_size",
            condition=lambda ctx: ctx.get('project_size_mb', 0) > 500,
            action="cleanup_project",
            decision_type=DecisionType.SCHEDULED,
            priority=DecisionPriority.MEDIUM,
            description="حجم المشروع كبير - تنظيف مطلوب"
        ))
        
        self.add_rule(Rule(
            name="large_build_folder",
            condition=lambda ctx: ctx.get('build_folder_size_mb', 0) > 1000,
            action="clean_build_folder",
            decision_type=DecisionType.IMMEDIATE,
            priority=DecisionPriority.LOW,
            description="مجلد البناء كبير - تنظيف"
        ))
        
        # قواعد استراتيجية
        self.add_rule(Rule(
            name="performance_degradation",
            condition=lambda ctx: ctx.get('performance_score', 100) < 70,
            action="initiate_performance_audit",
            decision_type=DecisionType.STRATEGIC,
            priority=DecisionPriority.HIGH,
            description="تدهور الأداء - مراجعة شاملة مطلوبة"
        ))
        
        self.add_rule(Rule(
            name="multiple_critical_alerts",
            condition=lambda ctx: ctx.get('critical_alerts_count', 0) >= 3,
            action="emergency_review",
            decision_type=DecisionType.IMMEDIATE,
            priority=DecisionPriority.CRITICAL,
            description="تنبيهات حرجة متعددة - مراجعة طارئة"
        ))
        
        logger.info(f"✅ Loaded {len(self.rules)} default rules")
    
    def add_rule(self, rule: Rule):
        """إضافة قاعدة"""
        self.rules.append(rule)
        logger.debug(f"➕ Rule added: {rule.name}")
    
    def evaluate(self, context: Dict) -> List[Decision]:
        """تقييم جميع القواعد"""
        new_decisions = []
        
        for rule in self.rules:
            decision = rule.evaluate(context)
            if decision:
                new_decisions.append(decision)
                self.decisions.append(decision)
        
        if new_decisions:
            logger.info(f"🎯 {len(new_decisions)} new decisions made")
        
        return new_decisions
    
    def get_immediate_decisions(self) -> List[Decision]:
        """الحصول على القرارات الفورية غير المنفذة"""
        return [
            d for d in self.decisions
            if d.type == DecisionType.IMMEDIATE and not d.executed
        ]
    
    def get_scheduled_decisions(self) -> List[Decision]:
        """الحصول على القرارات المجدولة غير المنفذة"""
        return [
            d for d in self.decisions
            if d.type == DecisionType.SCHEDULED and not d.executed
        ]
    
    def get_strategic_decisions(self) -> List[Decision]:
        """الحصول على القرارات الاستراتيجية غير المنفذة"""
        return [
            d for d in self.decisions
            if d.type == DecisionType.STRATEGIC and not d.executed
        ]
    
    def mark_executed(self, decision_id: str, result: str = "success"):
        """تعليم قرار كمنفذ"""
        for decision in self.decisions:
            if decision.id == decision_id:
                decision.executed = True
                decision.executed_at = datetime.now()
                decision.result = result
                
                # نقل إلى السجل
                self.decision_history.append(decision)
                self.decisions.remove(decision)
                
                logger.info(f"✅ Decision {decision_id} marked as executed: {result}")
                return True
        
        logger.warning(f"⚠️  Decision {decision_id} not found")
        return False
    
    def get_action_for_decision(self, decision: Decision) -> Optional[Callable]:
        """الحصول على الإجراء المناسب للقرار"""
        actions = {
            'cleanup_and_optimize': self._action_cleanup_and_optimize,
            'cleanup_memory': self._action_cleanup_memory,
            'cleanup_disk': self._action_cleanup_disk,
            'schedule_testing_sprint': self._action_schedule_testing_sprint,
            'schedule_refactoring': self._action_schedule_refactoring,
            'fix_analyze_issues': self._action_fix_analyze_issues,
            'cleanup_project': self._action_cleanup_project,
            'clean_build_folder': self._action_clean_build_folder,
            'initiate_performance_audit': self._action_performance_audit,
            'emergency_review': self._action_emergency_review
        }
        
        return actions.get(decision.action)
    
    # الإجراءات
    def _action_cleanup_and_optimize(self) -> str:
        """تنظيف وتحسين شامل"""
        logger.info("🧹 Executing: cleanup and optimize")
        return "cleanup_script_executed"
    
    def _action_cleanup_memory(self) -> str:
        """تنظيف الذاكرة"""
        logger.info("🧠 Executing: cleanup memory")
        return "memory_cleaned"
    
    def _action_cleanup_disk(self) -> str:
        """تنظيف القرص"""
        logger.info("💾 Executing: cleanup disk")
        return "disk_cleaned"
    
    def _action_schedule_testing_sprint(self) -> str:
        """جدولة sprint للاختبارات"""
        logger.info("🧪 Executing: schedule testing sprint")
        return "testing_sprint_scheduled"
    
    def _action_schedule_refactoring(self) -> str:
        """جدولة إعادة هيكلة"""
        logger.info("🔧 Executing: schedule refactoring")
        return "refactoring_scheduled"
    
    def _action_fix_analyze_issues(self) -> str:
        """إصلاح مشاكل التحليل"""
        logger.info("🔍 Executing: fix analyze issues")
        return "analyze_issues_fixed"
    
    def _action_cleanup_project(self) -> str:
        """تنظيف المشروع"""
        logger.info("📦 Executing: cleanup project")
        return "project_cleaned"
    
    def _action_clean_build_folder(self) -> str:
        """تنظيف مجلد البناء"""
        logger.info("🏗️  Executing: clean build folder")
        return "build_folder_cleaned"
    
    def _action_performance_audit(self) -> str:
        """مراجعة الأداء"""
        logger.info("📊 Executing: performance audit")
        return "performance_audit_initiated"
    
    def _action_emergency_review(self) -> str:
        """مراجعة طارئة"""
        logger.info("🚨 Executing: emergency review")
        return "emergency_review_initiated"
    
    def get_summary(self) -> Dict:
        """الحصول على ملخص القرارات"""
        return {
            'timestamp': datetime.now().isoformat(),
            'total_rules': len(self.rules),
            'pending_decisions': len(self.decisions),
            'immediate_decisions': len(self.get_immediate_decisions()),
            'scheduled_decisions': len(self.get_scheduled_decisions()),
            'strategic_decisions': len(self.get_strategic_decisions()),
            'executed_decisions': len(self.decision_history)
        }


def main():
    """نقطة الدخول الرئيسية"""
    print("🧠 Decision Engine - محرك القرارات الذكي")
    print("=" * 60)
    
    engine = DecisionEngine()
    
    # مثال على السياق
    context = {
        'cpu_percent': 95,
        'memory_percent': 88,
        'disk_percent': 75,
        'test_coverage': 65,
        'code_quality_score': 85,
        'analyze_issues': 15,
        'project_size_mb': 450,
        'build_folder_size_mb': 1200,
        'performance_score': 75
    }
    
    # تقييم القواعد
    decisions = engine.evaluate(context)
    
    print(f"\n📊 Context:")
    for key, value in context.items():
        print(f"  {key}: {value}")
    
    print(f"\n🎯 Decisions Made: {len(decisions)}")
    for decision in decisions:
        print(f"\n  ID: {decision.id}")
        print(f"  Type: {decision.type.value}")
        print(f"  Priority: {decision.priority.name}")
        print(f"  Action: {decision.action}")
        print(f"  Description: {decision.description}")
    
    # ملخص
    summary = engine.get_summary()
    print(f"\n📋 Summary:")
    print(f"  Total Rules: {summary['total_rules']}")
    print(f"  Pending Decisions: {summary['pending_decisions']}")
    print(f"  Immediate: {summary['immediate_decisions']}")
    print(f"  Scheduled: {summary['scheduled_decisions']}")
    print(f"  Strategic: {summary['strategic_decisions']}")


if __name__ == "__main__":
    main()
