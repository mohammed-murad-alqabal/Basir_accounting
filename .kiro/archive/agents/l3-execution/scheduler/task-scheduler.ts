/**
 * Task Scheduler - Intelligent Task Scheduling and Queue Management
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 11 ديسمبر 2025
 */

import { CronJob } from 'cron';
import { EventEmitter } from 'events';

export interface ScheduledTask {
  id: string;
  name: string;
  description: string; // Arabic
  workflowId?: string;
  action: string;
  parameters: Record<string, any>;
  priority: Priority;
  scheduledTime: Date;
  deadline?: Date;
  resourceRequirements: ResourceRequirement[];
  constraints: TaskConstraint[];
  status: TaskStatus;
  retries: number;
  maxRetries: number;
  metadata: TaskMetadata;
}

export interface RecurringTask {
  id: string;
  name: string;
  cronExpression: string;
  task: ScheduledTask;
  enabled: boolean;
  nextRun: Date;
  lastRun?: Date;
  runCount: number;
  job?: CronJob;
}

export enum Priority {
  CRITICAL = 10,
  HIGH = 8,
  MEDIUM = 5,
  LOW = 3,
  BACKGROUND = 1
}

export enum TaskStatus {
  PENDING = 'pending',
  SCHEDULED = 'scheduled',
  RUNNING = 'running',
  COMPLETED = 'completed',
  FAILED = 'failed',
  CANCELLED = 'cancelled',
  RETRYING = 'retrying'
}

export interface TaskQueue {
  priority: Priority;
  tasks: ScheduledTask[];
  maxConcurrent: number;
  currentlyRunning: number;
}

export class TaskScheduler extends EventEmitter {
  private taskQueues: Map<Priority, TaskQueue> = new Map();
  private recurringTasks: Map<string, RecurringTask> = new Map();
  private runningTasks: Map<string, Promise<TaskResult>> = new Map();
  private taskHistory: Map<string, TaskResult> = new Map();
  
  private isRunning = false;
  private processingInterval?: NodeJS.Timeout;
  private maxConcurrentTasks = 20;

  constructor() {
    super();
    this.initializeQueues();
  }

  /**
   * بدء جدولة المهام
   */
  async start(): Promise<void> {
    console.log('📅 Starting Task Scheduler...');
    
    try {
      // بدء معالجة القوائم
      this.startQueueProcessing();
      
      // بدء المهام المتكررة
      await this.startRecurringTasks();
      
      this.isRunning = true;
      console.log('✅ Task Scheduler started');
      this.emit('schedulerStarted');
      
    } catch (error) {
      console.error('❌ Failed to start Task Scheduler:', error);
      throw error;
    }
  }

  /**
   * إيقاف جدولة المهام
   */
  async stop(): Promise<void> {
    console.log('🛑 Stopping Task Scheduler...');
    
    // إيقاف معالجة القوائم
    if (this.processingInterval) {
      clearInterval(this.processingInterval);
      this.processingInterval = undefined;
    }
    
    // إيقاف المهام المتكررة
    for (const recurringTask of this.recurringTasks.values()) {
      if (recurringTask.job) {
        recurringTask.job.stop();
      }
    }
    
    // انتظار انتهاء المهام الجارية
    await this.waitForRunningTasks();
    
    this.isRunning = false;
    console.log('✅ Task Scheduler stopped');
    this.emit('schedulerStopped');
  }

  /**
   * جدولة مهمة
   */
  async scheduleTask(task: ScheduledTask): Promise<string> {
    console.log(`📋 Scheduling task: ${task.name}`);
    
    // التحقق من صحة المهمة
    const validation = this.validateTask(task);
    if (!validation.isValid) {
      throw new Error(`Invalid task: ${validation.errors.join(', ')}`);
    }

    // إضافة إلى القائمة المناسبة
    const queue = this.taskQueues.get(task.priority);
    if (!queue) {
      throw new Error(`Invalid priority: ${task.priority}`);
    }

    task.status = TaskStatus.SCHEDULED;
    queue.tasks.push(task);
    
    // ترتيب القائمة حسب الأولوية والوقت
    this.sortQueue(queue);
    
    console.log(`✅ Task scheduled: ${task.name} (Priority: ${task.priority})`);
    this.emit('taskScheduled', task);
    
    return task.id;
  }