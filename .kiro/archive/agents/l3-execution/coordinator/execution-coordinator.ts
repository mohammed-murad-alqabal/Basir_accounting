/**
 * Execution Coordinator - Main Controller of L3 Execution Layer
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 11 ديسمبر 2025
 */

import { EventEmitter } from 'events';
import { TaskScheduler } from '../scheduler/task-scheduler';
import { WorkflowEngine } from '../workflow/workflow-engine';

export interface ExecutionPlan {
  id: string;
  timestamp: Date;
  decisions: any[];
  workflows: WorkflowExecution[];
  tasks: ScheduledTask[];
  resourceRequirements: ResourceRequirement[];
  estimatedDuration: number;
  priority: Priority;
}

export interface ExecutionResult {
  planId: string;
  timestamp: Date;
  success: boolean;
  completedWorkflows: number;
  failedWorkflows: number;
  completedTasks: number;
  failedTasks: number;
  resourcesUsed: ResourceUsage;
  duration: number;
  errors: ExecutionError[];
}

export interface SystemEvent {
  id: string;
  type: SystemEventType;
  timestamp: Date;
  source: string;
  data: any;
  severity: 'info' | 'warning' | 'error' | 'critical';
}

export enum SystemEventType {
  LAYER_STARTED = 'layer_started',
  LAYER_STOPPED = 'layer_stopped',
  WORKFLOW_CREATED = 'workflow_created',
  WORKFLOW_COMPLETED = 'workflow_completed',
  TASK_SCHEDULED = 'task_scheduled',
  TASK_EXECUTED = 'task_executed',
  RESOURCE_ALLOCATED = 'resource_allocated',
  RESOURCE_RELEASED = 'resource_released',
  SYSTEM_OVERLOAD = 'system_overload',
  ERROR_OCCURRED = 'error_occurred'
}

export class ExecutionCoordinator extends EventEmitter {
  private workflowEngine: WorkflowEngine;
  private taskScheduler: TaskScheduler;
  private resourceManager: ResourceManager;
  private monitoringDashboard: MonitoringDashboard;
  
  private isRunning = false;
  private executionPlans: Map<string, ExecutionPlan> = new Map();
  private activeExecutions: Map<string, Promise<ExecutionResult>> = new Map();
  private systemEvents: SystemEvent[] = [];
  private healthStatus: HealthStatus = 'healthy';

  constructor(
    workflowEngine: WorkflowEngine,
    taskScheduler: TaskScheduler,
    resourceManager: ResourceManager,
    monitoringDashboard: MonitoringDashboard
  ) {
    super();
    this.workflowEngine = workflowEngine;
    this.taskScheduler = taskScheduler;
    this.resourceManager = resourceManager;
    this.monitoringDashboard = monitoringDashboard;
    
    this.setupEventHandlers();
  }

  /**
   * بدء منسق التنفيذ
   */
  async start(): Promise<void> {
    if (this.isRunning) {
      console.log('⚠️ Execution Coordinator is already running');
      return;
    }

    console.log('🚀 Starting L3 Execution Coordinator...');
    
    try {
      // بدء المكونات الفرعية
      await this.workflowEngine.start();
      await this.taskScheduler.start();
      await this.resourceManager.start();
      await this.monitoringDashboard.start();
      
      // بدء المراقبة المستمرة
      this.startContinuousMonitoring();
      
      this.isRunning = true;
      this.healthStatus = 'healthy';
      
      this.publishSystemEvent({
        type: SystemEventType.LAYER_STARTED,
        source: 'execution_coordinator',
        data: { timestamp: new Date() },
        severity: 'info'
      });
      
      console.log('✅ L3 Execution Coordinator started successfully');
      this.emit('coordinatorStarted');
      
    } catch (error) {
      console.error('❌ Failed to start Execution Coordinator:', error);
      this.healthStatus = 'unhealthy';
      throw error;
    }
  }
  /**
   * إيقاف منسق التنفيذ
   */
  async stop(): Promise<void> {
    if (!this.isRunning) {
      return;
    }

    console.log('🛑 Stopping L3 Execution Coordinator...');
    
    try {
      // إيقاف المكونات الفرعية
      await this.workflowEngine.stop();
      await this.taskScheduler.stop();
      await this.resourceManager.stop();
      await this.monitoringDashboard.stop();
      
      this.isRunning = false;
      this.healthStatus = 'stopped';
      
      this.publishSystemEvent({
        type: SystemEventType.LAYER_STOPPED,
        source: 'execution_coordinator',
        data: { timestamp: new Date() },
        severity: 'info'
      });
      
      console.log('✅ L3 Execution Coordinator stopped');
      this.emit('coordinatorStopped');
      
    } catch (error) {
      console.error('❌ Error stopping Execution Coordinator:', error);
    }
  }

  /**
   * معالجة قرارات L2 وإنشاء خطة تنفيذ
   */
  async processL2Decisions(decisions: any[]): Promise<ExecutionPlan> {
    console.log(`🧠 Processing ${decisions.length} decisions from L2...`);
    
    try {
      const plan: ExecutionPlan = {
        id: this.generatePlanId(),
        timestamp: new Date(),
        decisions,
        workflows: [],
        tasks: [],
        resourceRequirements: [],
        estimatedDuration: 0,
        priority: this.calculatePlanPriority(decisions)
      };

      // تحويل القرارات إلى مهام وسير عمل
      for (const decision of decisions) {
        const workflowTasks = await this.convertDecisionToTasks(decision);
        plan.tasks.push(...workflowTasks);
        
        // إنشاء سير عمل إذا كان القرار معقداً
        if (this.requiresWorkflow(decision)) {
          const workflow = await this.createWorkflowForDecision(decision);
          plan.workflows.push(workflow);
        }
      }

      // حساب متطلبات الموارد
      plan.resourceRequirements = await this.calculateResourceRequirements(plan.tasks);
      plan.estimatedDuration = await this.estimateExecutionDuration(plan);

      // حفظ الخطة
      this.executionPlans.set(plan.id, plan);
      
      console.log(`✅ Created execution plan: ${plan.id} with ${plan.tasks.length} tasks`);
      this.emit('executionPlanCreated', plan);
      
      return plan;
      
    } catch (error) {
      console.error('❌ Error processing L2 decisions:', error);
      throw error;
    }
  }
  /**
   * تنفيذ خطة التنفيذ
   */
  async executePlan(planId: string): Promise<ExecutionResult> {
    const plan = this.executionPlans.get(planId);
    if (!plan) {
      throw new Error(`Execution plan not found: ${planId}`);
    }

    console.log(`🚀 Executing plan: ${planId}`);
    
    // التحقق من وجود تنفيذ نشط
    if (this.activeExecutions.has(planId)) {
      console.log(`⏳ Plan ${planId} is already executing`);
      return await this.activeExecutions.get(planId)!;
    }

    // بدء التنفيذ
    const executionPromise = this.performExecution(plan);
    this.activeExecutions.set(planId, executionPromise);

    try {
      const result = await executionPromise;
      this.emit('executionCompleted', result);
      return result;
    } finally {
      this.activeExecutions.delete(planId);
    }
  }

  /**
   * تنفيذ الخطة الفعلي
   */
  private async performExecution(plan: ExecutionPlan): Promise<ExecutionResult> {
    const startTime = Date.now();
    
    const result: ExecutionResult = {
      planId: plan.id,
      timestamp: new Date(),
      success: false,
      completedWorkflows: 0,
      failedWorkflows: 0,
      completedTasks: 0,
      failedTasks: 0,
      resourcesUsed: await this.resourceManager.getResourceUsage(),
      duration: 0,
      errors: []
    };

    try {
      // تخصيص الموارد
      const resourceAllocation = await this.resourceManager.allocateResources(plan.resourceRequirements);
      
      // تنفيذ سير العمل
      for (const workflow of plan.workflows) {
        try {
          await this.workflowEngine.executeWorkflow(workflow.id);
          result.completedWorkflows++;
        } catch (error) {
          result.failedWorkflows++;
          result.errors.push({
            type: 'workflow_error',
            workflowId: workflow.id,
            message: error.message,
            timestamp: new Date()
          });
        }
      }

      // جدولة وتنفيذ المهام
      for (const task of plan.tasks) {
        try {
          await this.taskScheduler.scheduleTask(task);
          result.completedTasks++;
        } catch (error) {
          result.failedTasks++;
          result.errors.push({
            type: 'task_error',
            taskId: task.id,
            message: error.message,
            timestamp: new Date()
          });
        }
      }

      // تحرير الموارد
      await this.resourceManager.releaseResources(resourceAllocation.id);
      
      result.success = result.errors.length === 0;
      result.duration = Date.now() - startTime;
      
      console.log(`✅ Plan execution completed: ${plan.id} (${result.duration}ms)`);
      
    } catch (error) {
      result.errors.push({
        type: 'execution_error',
        message: error.message,
        timestamp: new Date()
      });
      
      console.error(`❌ Plan execution failed: ${plan.id}`, error);
    }

    return result;
  }
  /**
   * إعداد معالجات الأحداث
   */
  private setupEventHandlers(): void {
    // أحداث محرك سير العمل
    this.workflowEngine.on('workflowCompleted', (workflow) => {
      this.publishSystemEvent({
        type: SystemEventType.WORKFLOW_COMPLETED,
        source: 'workflow_engine',
        data: workflow,
        severity: 'info'
      });
    });

    // أحداث جدولة المهام
    this.taskScheduler.on('taskScheduled', (task) => {
      this.publishSystemEvent({
        type: SystemEventType.TASK_SCHEDULED,
        source: 'task_scheduler',
        data: task,
        severity: 'info'
      });
    });

    // أحداث إدارة الموارد
    this.resourceManager.on('resourceAllocated', (allocation) => {
      this.publishSystemEvent({
        type: SystemEventType.RESOURCE_ALLOCATED,
        source: 'resource_manager',
        data: allocation,
        severity: 'info'
      });
    });
  }

  /**
   * بدء المراقبة المستمرة
   */
  private startContinuousMonitoring(): void {
    setInterval(async () => {
      try {
        await this.maintainSystemHealth();
      } catch (error) {
        console.error('❌ Error in continuous monitoring:', error);
      }
    }, 30000); // كل 30 ثانية
  }

  /**
   * صيانة صحة النظام
   */
  async maintainSystemHealth(): Promise<HealthReport> {
    const healthReport: HealthReport = {
      timestamp: new Date(),
      overall: 'healthy',
      components: {
        workflowEngine: await this.workflowEngine.getHealthStatus(),
        taskScheduler: await this.taskScheduler.getHealthStatus(),
        resourceManager: await this.resourceManager.getHealthStatus(),
        monitoringDashboard: await this.monitoringDashboard.getHealthStatus()
      },
      metrics: {
        activeExecutions: this.activeExecutions.size,
        queuedPlans: this.executionPlans.size,
        systemEvents: this.systemEvents.length,
        uptime: this.isRunning ? Date.now() - this.startTime : 0
      }
    };

    // تحديد الصحة العامة
    const componentStatuses = Object.values(healthReport.components);
    if (componentStatuses.some(status => status === 'critical')) {
      healthReport.overall = 'critical';
      this.healthStatus = 'critical';
    } else if (componentStatuses.some(status => status === 'unhealthy')) {
      healthReport.overall = 'unhealthy';
      this.healthStatus = 'unhealthy';
    } else {
      this.healthStatus = 'healthy';
    }

    this.emit('healthReportGenerated', healthReport);
    return healthReport;
  }

  /**
   * نشر حدث النظام
   */
  private publishSystemEvent(eventData: Partial<SystemEvent>): void {
    const event: SystemEvent = {
      id: this.generateEventId(),
      timestamp: new Date(),
      ...eventData
    } as SystemEvent;

    this.systemEvents.push(event);
    
    // الحفاظ على حجم قائمة الأحداث
    if (this.systemEvents.length > 1000) {
      this.systemEvents = this.systemEvents.slice(-1000);
    }

    this.emit('systemEvent', event);
  }

  // Helper methods
  private generatePlanId(): string {
    return `plan_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  private generateEventId(): string {
    return `event_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  private calculatePlanPriority(decisions: any[]): Priority {
    const priorities = decisions.map(d => d.priority || 5);
    const avgPriority = priorities.reduce((sum, p) => sum + p, 0) / priorities.length;
    
    if (avgPriority >= 9) return Priority.CRITICAL;
    if (avgPriority >= 7) return Priority.HIGH;
    if (avgPriority >= 5) return Priority.MEDIUM;
    if (avgPriority >= 3) return Priority.LOW;
    return Priority.BACKGROUND;
  }
}