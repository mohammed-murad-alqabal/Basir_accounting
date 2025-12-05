#!/usr/bin/env python3
"""
Agent Orchestrator - منسق الوكلاء الذكي
المشروع: بصير MVP
المؤلف: فريق وكلاء تطوير مشروع بصير
التاريخ: 5 ديسمبر 2025
"""

import os
import sys
import time
import yaml
import json
import logging
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional
from dataclasses import dataclass, asdict
from enum import Enum

# إعداد Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/orchestrator.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger('Orchestrator')


class AgentStatus(Enum):
    """حالات الوكيل"""
    IDLE = "idle"
    ACTIVE = "active"
    BUSY = "busy"
    ERROR = "error"
    DISABLED = "disabled"


class TaskPriority(Enum):
    """أولويات المهام"""
    CRITICAL = 1
    HIGH = 2
    MEDIUM = 3
    LOW = 4


@dataclass
class AgentMetrics:
    """مقاييس أداء الوكيل"""
    name: str
    status: AgentStatus
    tasks_completed: int = 0
    tasks_failed: int = 0
    average_response_time: float = 0.0
    last_run: Optional[datetime] = None
    success_rate: float = 100.0
    
    def to_dict(self) -> Dict:
        """تحويل إلى قاموس"""
        data = asdict(self)
        data['status'] = self.status.value
        data['last_run'] = self.last_run.isoformat() if self.last_run else None
        return data


@dataclass
class Task:
    """مهمة للوكيل"""
    id: str
    agent: str
    action: str
    priority: TaskPriority
    created_at: datetime
    data: Dict = None
    
    def to_dict(self) -> Dict:
        """تحويل إلى قاموس"""
        return {
            'id': self.id,
            'agent': self.agent,
            'action': self.action,
            'priority': self.priority.value,
            'created_at': self.created_at.isoformat(),
            'data': self.data or {}
        }


class AgentOrchestrator:
    """منسق الوكلاء الرئيسي"""
    
    def __init__(self, config_path: str = '.kiro/automation/config.yaml'):
        """تهيئة المنسق"""
        self.config_path = config_path
        self.config = self._load_config()
        self.agents: Dict[str, AgentMetrics] = {}
        self.task_queue: List[Task] = []
        self.running = False
        
        # تهيئة الوكلاء
        self._initialize_agents()
        
        logger.info("🚀 Agent Orchestrator initialized")
    
    def _load_config(self) -> Dict:
        """تحميل التكوينات"""
        try:
            with open(self.config_path, 'r', encoding='utf-8') as f:
                config = yaml.safe_load(f)
            logger.info(f"✅ Configuration loaded from {self.config_path}")
            return config
        except FileNotFoundError:
            logger.warning(f"⚠️  Config file not found, using defaults")
            return self._default_config()
        except Exception as e:
            logger.error(f"❌ Error loading config: {e}")
            return self._default_config()
    
    def _default_config(self) -> Dict:
        """التكوينات الافتراضية"""
        return {
            'agents': {
                'analysis': {'enabled': True, 'interval': 300},
                'testing': {'enabled': True, 'on_commit': True},
                'security': {'enabled': True, 'on_pr': True},
                'performance': {'enabled': True, 'interval': 300},
                'development': {'enabled': True},
                'documentation': {'enabled': True},
                'review': {'enabled': True, 'on_pr': True},
                'management': {'enabled': True}
            },
            'monitoring': {
                'interval': 60,
                'metrics_retention': 7
            },
            'alerts': {
                'enabled': True,
                'channels': ['log', 'file']
            }
        }
    
    def _initialize_agents(self):
        """تهيئة جميع الوكلاء"""
        for agent_name, agent_config in self.config['agents'].items():
            if agent_config.get('enabled', True):
                self.agents[agent_name] = AgentMetrics(
                    name=agent_name,
                    status=AgentStatus.IDLE
                )
                logger.info(f"✅ Agent '{agent_name}' initialized")
    
    def start(self):
        """بدء المنسق"""
        logger.info("🚀 Starting Agent Orchestrator...")
        self.running = True
        
        try:
            while self.running:
                self._orchestration_cycle()
                time.sleep(self.config['monitoring']['interval'])
        except KeyboardInterrupt:
            logger.info("⏹️  Orchestrator stopped by user")
        except Exception as e:
            logger.error(f"❌ Orchestrator error: {e}")
        finally:
            self.stop()
    
    def stop(self):
        """إيقاف المنسق"""
        logger.info("⏹️  Stopping Agent Orchestrator...")
        self.running = False
        self._save_state()
        logger.info("✅ Orchestrator stopped successfully")
    
    def _orchestration_cycle(self):
        """دورة تنسيق واحدة"""
        logger.debug("🔄 Running orchestration cycle...")
        
        # 1. جمع المقاييس
        self._collect_metrics()
        
        # 2. معالجة قائمة المهام
        self._process_task_queue()
        
        # 3. تشغيل المهام المجدولة
        self._run_scheduled_tasks()
        
        # 4. التحقق من الصحة
        self._health_check()
        
        # 5. تحديث لوحة التحكم
        self._update_dashboard()
    
    def _collect_metrics(self):
        """جمع مقاييس الأداء"""
        for agent_name, agent in self.agents.items():
            # هنا يمكن جمع مقاييس حقيقية
            pass
    
    def _process_task_queue(self):
        """معالجة قائمة المهام"""
        if not self.task_queue:
            return
        
        # ترتيب حسب الأولوية
        self.task_queue.sort(key=lambda t: t.priority.value)
        
        # معالجة المهام
        for task in self.task_queue[:]:
            if self._execute_task(task):
                self.task_queue.remove(task)
    
    def _execute_task(self, task: Task) -> bool:
        """تنفيذ مهمة"""
        agent = self.agents.get(task.agent)
        if not agent:
            logger.error(f"❌ Agent '{task.agent}' not found")
            return False
        
        if agent.status == AgentStatus.BUSY:
            logger.debug(f"⏳ Agent '{task.agent}' is busy, queuing task")
            return False
        
        try:
            logger.info(f"▶️  Executing task {task.id} on agent '{task.agent}'")
            agent.status = AgentStatus.ACTIVE
            
            # هنا يتم تنفيذ المهمة الفعلية
            # يمكن استدعاء السكريبتات أو الوكلاء الفعليين
            
            agent.tasks_completed += 1
            agent.last_run = datetime.now()
            agent.status = AgentStatus.IDLE
            
            logger.info(f"✅ Task {task.id} completed successfully")
            return True
            
        except Exception as e:
            logger.error(f"❌ Task {task.id} failed: {e}")
            agent.tasks_failed += 1
            agent.status = AgentStatus.ERROR
            return False
    
    def _run_scheduled_tasks(self):
        """تشغيل المهام المجدولة"""
        current_time = datetime.now()
        
        for agent_name, agent_config in self.config['agents'].items():
            interval = agent_config.get('interval')
            if not interval:
                continue
            
            agent = self.agents.get(agent_name)
            if not agent or agent.status == AgentStatus.BUSY:
                continue
            
            # التحقق من الوقت
            if agent.last_run:
                elapsed = (current_time - agent.last_run).total_seconds()
                if elapsed < interval:
                    continue
            
            # إنشاء مهمة مجدولة
            task = Task(
                id=f"{agent_name}_{int(time.time())}",
                agent=agent_name,
                action="scheduled_run",
                priority=TaskPriority.MEDIUM,
                created_at=current_time
            )
            self.add_task(task)
    
    def _health_check(self):
        """فحص صحة النظام"""
        unhealthy_agents = []
        
        for agent_name, agent in self.agents.items():
            if agent.status == AgentStatus.ERROR:
                unhealthy_agents.append(agent_name)
            
            # حساب معدل النجاح
            total_tasks = agent.tasks_completed + agent.tasks_failed
            if total_tasks > 0:
                agent.success_rate = (agent.tasks_completed / total_tasks) * 100
        
        if unhealthy_agents:
            logger.warning(f"⚠️  Unhealthy agents: {', '.join(unhealthy_agents)}")
    
    def _update_dashboard(self):
        """تحديث لوحة التحكم"""
        dashboard_data = {
            'timestamp': datetime.now().isoformat(),
            'agents': {name: agent.to_dict() for name, agent in self.agents.items()},
            'task_queue_size': len(self.task_queue),
            'system_health': self._calculate_system_health()
        }
        
        # حفظ البيانات
        dashboard_file = Path('logs/dashboard.json')
        dashboard_file.parent.mkdir(parents=True, exist_ok=True)
        
        with open(dashboard_file, 'w', encoding='utf-8') as f:
            json.dump(dashboard_data, f, indent=2, ensure_ascii=False)
    
    def _calculate_system_health(self) -> float:
        """حساب صحة النظام"""
        if not self.agents:
            return 0.0
        
        total_health = 0.0
        for agent in self.agents.values():
            if agent.status == AgentStatus.ERROR:
                agent_health = 0.0
            elif agent.status == AgentStatus.DISABLED:
                continue
            else:
                agent_health = agent.success_rate
            
            total_health += agent_health
        
        return total_health / len(self.agents)
    
    def _save_state(self):
        """حفظ حالة النظام"""
        state = {
            'timestamp': datetime.now().isoformat(),
            'agents': {name: agent.to_dict() for name, agent in self.agents.items()},
            'task_queue': [task.to_dict() for task in self.task_queue]
        }
        
        state_file = Path('logs/orchestrator_state.json')
        state_file.parent.mkdir(parents=True, exist_ok=True)
        
        with open(state_file, 'w', encoding='utf-8') as f:
            json.dump(state, f, indent=2, ensure_ascii=False)
        
        logger.info("💾 State saved successfully")
    
    def add_task(self, task: Task):
        """إضافة مهمة إلى القائمة"""
        self.task_queue.append(task)
        logger.info(f"➕ Task {task.id} added to queue (priority: {task.priority.name})")
    
    def get_agent_status(self, agent_name: str) -> Optional[AgentMetrics]:
        """الحصول على حالة وكيل"""
        return self.agents.get(agent_name)
    
    def get_system_status(self) -> Dict:
        """الحصول على حالة النظام"""
        return {
            'running': self.running,
            'agents_count': len(self.agents),
            'active_agents': sum(1 for a in self.agents.values() if a.status == AgentStatus.ACTIVE),
            'task_queue_size': len(self.task_queue),
            'system_health': self._calculate_system_health()
        }


def main():
    """نقطة الدخول الرئيسية"""
    print("🤖 Agent Orchestrator - منسق الوكلاء الذكي")
    print("=" * 60)
    
    if len(sys.argv) > 1:
        command = sys.argv[1]
        
        if command == "start":
            orchestrator = AgentOrchestrator()
            orchestrator.start()
        
        elif command == "status":
            # عرض الحالة من الملف المحفوظ
            try:
                with open('logs/orchestrator_state.json', 'r') as f:
                    state = json.load(f)
                print(json.dumps(state, indent=2, ensure_ascii=False))
            except FileNotFoundError:
                print("❌ No saved state found")
        
        elif command == "dashboard":
            # عرض لوحة التحكم
            try:
                with open('logs/dashboard.json', 'r') as f:
                    dashboard = json.load(f)
                print(json.dumps(dashboard, indent=2, ensure_ascii=False))
            except FileNotFoundError:
                print("❌ No dashboard data found")
        
        else:
            print(f"❌ Unknown command: {command}")
            print("Available commands: start, status, dashboard")
    
    else:
        print("Usage: python orchestrator.py [start|status|dashboard]")


if __name__ == "__main__":
    main()
