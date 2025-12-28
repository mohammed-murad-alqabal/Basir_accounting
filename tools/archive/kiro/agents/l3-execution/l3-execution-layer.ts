/**
 * L3 Execution Layer - Main Controller
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 11 ديسمبر 2025
 */

import { EventEmitter } from 'events';
import { ExecutionCoordinator } from './coordinator/execution-coordinator';
import { MonitoringDashboard } from './dashboard/monitoring-dashboard';
import { ResourceManager } from './resources/resource-manager';
import { TaskScheduler } from './scheduler/task-scheduler';
import { WorkflowEngine } from './workflow/workflow-engine';

export interface L3ExecutionConfig {
  project: string;
  
  // Execution Coordinator Configuration
  coordinator: {
    maxConcurrentExecutions: number;
    executionTimeout: number;
    healthCheckInterval: number;
  };
  
  // Workflow Engine Configuration
  workflow: {
    workflowsPath: string;
    templatesPath: string;
    maxConcurrentWorkflows: number;
    defaultTimeout: number;
  };
  
  // Task Scheduler Configuration
  scheduler: {
    maxConcurrentTasks: number;
    queueProcessingInterval: number;
    taskTimeout: number;
    maxRetries: number;
  };
  
  // Resource Manager Configuration
  resources: {
    monitoringInterval: number;
    allocationTimeout: number;
    thresholds: ResourceThresholds;
  };
  
  // Monitoring Dashboard Configuration
  dashboard: {
    dashboardsPath: string;
    refreshInterval: number;
    dataRetention: number;
    alertsEnabled: boolean;
  };
  
  // Integration Configuration
  integration: {
    l1AnalysisLayer: {
      enabled: boolean;
      endpoint?: string;
    };
    
    l2DecisionLayer: {
      enabled: boolean;
      endpoint?: string;
    };
    
    notifications: {
      enabled: boolean;
      channels: string[];
    };
  };
}

export interface L3ExecutionResult {
  timestamp: Date;
  executionPlans: ExecutionPlan[];
  workflowExecutions: WorkflowExecution[];
  taskResults: TaskResult[];
  resourceUsage: ResourceUsage;
  systemHealth: HealthReport;
  summary: {
    totalExecutions: number;
    successfulExecutions: number;
    failedExecutions: number;
    averageExecutionTime: number;
    resourceEfficiency: number;
  };
}

export class L3ExecutionLayer extends EventEmitter {
  private config: L3ExecutionConfig;
  private executionCoordinator: ExecutionCoordinator;
  private workflowEngine: WorkflowEngine;
  private taskScheduler: TaskScheduler;
  private resourceManager: ResourceManager;
  private monitoringDashboard: MonitoringDashboard;
  
  private isRunning = false;
  private startTime?: Date;

  constructor(config?: Partial<L3ExecutionConfig>) {
    super();
    
    this.config = {
      ...this.getDefaultConfig(),
      ...config
    };
    
    this.initializeComponents();
    this.setupEventHandlers();
  }

  /**
   * بدء طبقة التنفيذ
   */
  async start(): Promise<void> {
    if (this.isRunning) {
      console.log('⚠️ L3 Execution Layer is already running');
      return;
    }

    console.log('🚀 Starting L3 Execution Layer...');
    this.startTime = new Date();
    
    try {
      // بدء المكونات بالترتيب الصحيح
      await this.resourceManager.start();
      await this.taskScheduler.start();
      await this.workflowEngine.start();
      await this.monitoringDashboard.start();
      await this.executionCoordinator.start();
      
      this.isRunning = true;
      console.log('✅ L3 Execution Layer started successfully');
      this.emit('layerStarted', this.config);
      
    } catch (error) {
      console.error('❌ Failed to start L3 Execution Layer:', error);
      throw error;
    }
  }

  /**
   * إيقاف طبقة التنفيذ
   */
  async stop(): Promise<void> {
    if (!this.isRunning) {
      return;
    }

    console.log('🛑 Stopping L3 Execution Layer...');
    
    try {
      // إيقاف المكونات بالترتيب العكسي
      await this.executionCoordinator.stop();
      await this.monitoringDashboard.stop();
      await this.workflowEngine.stop();
      await this.taskScheduler.stop();
      await this.resourceManager.stop();
      
      this.isRunning = false;
      console.log('✅ L3 Execution Layer stopped');
      this.emit('layerStopped');
      
    } catch (error) {
      console.error('❌ Error stopping L3 Execution Layer:', error);
    }
  }

  /**
   * معالجة قرارات L2 وتنفيذها
   */
  async processL2Decisions(decisions: any[]): Promise<L3ExecutionResult> {
    if (!this.isRunning) {
      throw new Error('L3 Execution Layer is not running');
    }

    console.log(`🧠 Processing ${decisions.length} decisions from L2...`);
    
    try {
      // إنشاء خطة التنفيذ
      const executionPlan = await this.executionCoordinator.processL2Decisions(decisions);
      
      // تنفيذ الخطة
      const executionResult = await this.executionCoordinator.executePlan(executionPlan.id);
      
      // جمع النتائج الشاملة
      const result = await this.generateExecutionResult([executionPlan], executionResult);
      
      console.log(`✅ L2 decisions processed successfully`);
      this.emit('decisionsProcessed', result);
      
      return result;
      
    } catch (error) {
      console.error('❌ Error processing L2 decisions:', error);
      this.emit('processingError', error);
      throw error;
    }
  }