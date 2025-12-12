/**
 * L2 Decision Layer - Main Controller
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 11 ديسمبر 2025
 */

import { EventEmitter } from 'events';
import { promises as fs } from 'fs';
import * as path from 'path';

import { ActionExecutor, ExecutionContext } from './actions/action-executor';
import { L2DecisionConfig, getBasserMVPConfig } from './config/l2-config';
import { ContextManager } from './context/context-manager';
import { AnalysisData, Decision, DecisionEngine } from './engine/decision-engine';
import { MLModelsManager } from './ml/ml-models-manager';
import { RuleProcessor } from './rules/rule-processor';

export interface L2DecisionResult {
  timestamp: Date;
  decisions: Decision[];
  executionResults: any[];
  summary: {
    totalDecisions: number;
    successfulDecisions: number;
    failedDecisions: number;
    averageConfidence: number;
    executionTime: number;
  };
  metrics: L2Metrics;
}

export interface L2Metrics {
  performance: {
    decisionsPerMinute: number;
    averageDecisionTime: number;
    ruleEvaluationTime: number;
    mlPredictionTime: number;
    actionExecutionTime: number;
  };
  
  quality: {
    decisionAccuracy: number;
    ruleEffectiveness: number;
    mlModelAccuracy: number;
    actionSuccessRate: number;
  };
  
  system: {
    memoryUsage: number;
    cpuUsage: number;
    activeDecisions: number;
    queuedDecisions: number;
  };
}

export class L2DecisionLayer extends EventEmitter {
  private config: L2DecisionConfig;
  private decisionEngine: DecisionEngine;
  private ruleProcessor: RuleProcessor;
  private mlManager: MLModelsManager;
  private contextManager: ContextManager;
  private actionExecutor: ActionExecutor;
  
  private isRunning = false;
  private startTime?: Date;
  private metrics: L2Metrics;
  private metricsInterval?: NodeJS.Timeout;

  constructor(config?: Partial<L2DecisionConfig>) {
    super();
    
    // استخدام تكوين بصير MVP كافتراضي
    this.config = config ? 
      { ...getBasserMVPConfig(), ...config } : 
      getBasserMVPConfig();
    
    this.initializeMetrics();
    this.initializeComponents();
    this.setupEventHandlers();
  }

  /**
   * بدء طبقة القرار
   */
  async start(): Promise<void> {
    if (this.isRunning) {
      console.log('⚠️ L2 Decision Layer is already running');
      return;
    }

    console.log('🚀 Starting L2 Decision Layer...');
    this.startTime = new Date();
    
    try {
      // إنشاء المجلدات المطلوبة
      await this.ensureDirectories();
      
      // تحميل القواعد
      await this.ruleProcessor.loadRules();
      
      // تحميل السياق
      await this.contextManager.loadContext();
      
      // بدء مراقبة المقاييس
      if (this.config.integration.monitoring.enabled) {
        this.startMetricsMonitoring();
      }
      
      this.isRunning = true;
      console.log('✅ L2 Decision Layer started successfully');
      this.emit('layerStarted', this.config);
      
    } catch (error) {
      console.error('❌ Failed to start L2 Decision Layer:', error);
      throw error;
    }
  }

  /**
   * إيقاف طبقة القرار
   */
  async stop(): Promise<void> {
    if (!this.isRunning) {
      return;
    }

    console.log('🛑 Stopping L2 Decision Layer...');
    
    try {
      // إيقاف مراقبة المقاييس
      if (this.metricsInterval) {
        clearInterval(this.metricsInterval);
        this.metricsInterval = undefined;
      }
      
      // حفظ الحالة النهائية
      await this.contextManager.saveContext();
      
      // إنهاء المكونات
      this.isRunning = false;
      
      console.log('✅ L2 Decision Layer stopped');
      this.emit('layerStopped');
      
    } catch (error) {
      console.error('❌ Error stopping L2 Decision Layer:', error);
    }
  }

  /**
   * معالجة بيانات التحليل من L1
   */
  async processAnalysisData(data: AnalysisData): Promise<L2DecisionResult> {
    if (!this.isRunning) {
      throw new Error('L2 Decision Layer is not running');
    }

    const startTime = Date.now();
    console.log(`🧠 Processing analysis data from ${data.source}...`);
    
    try {
      // معالجة البيانات واتخاذ القرارات
      const decisions = await this.decisionEngine.processAnalysisData(data);
      
      // تنفيذ القرارات عالية الأولوية
      const executionResults = [];
      const highPriorityDecisions = decisions.filter(d => d.priority >= 8);
      
      for (const decision of highPriorityDecisions) {
        if (decision.confidence >= this.config.engine.confidenceThreshold) {
          const results = await this.decisionEngine.executeDecision(decision.id);
          executionResults.push(...results);
        }
      }
      
      // حساب الملخص
      const executionTime = Date.now() - startTime;
      const summary = {
        totalDecisions: decisions.length,
        successfulDecisions: decisions.filter(d => d.status === 'completed').length,
        failedDecisions: decisions.filter(d => d.status === 'failed').length,
        averageConfidence: decisions.reduce((sum, d) => sum + d.confidence, 0) / decisions.length || 0,
        executionTime
      };
      
      // تحديث المقاييس
      this.updateMetrics(decisions, executionResults, executionTime);
      
      const result: L2DecisionResult = {
        timestamp: new Date(),
        decisions,
        executionResults,
        summary,
        metrics: this.metrics
      };
      
      // حفظ النتيجة
      await this.saveResult(result);
      
      console.log(`✅ Processed ${decisions.length} decisions in ${executionTime}ms`);
      this.emit('analysisProcessed', result);
      
      return result;
      
    } catch (error) {
      console.error('❌ Error processing analysis data:', error);
      this.emit('processingError', error);
      throw error;
    }
  }

  /**
   * تنفيذ قرار يدوياً
   */
  async executeDecision(decisionId: string): Promise<any[]> {
    console.log(`🚀 Manually executing decision: ${decisionId}`);
    
    try {
      const results = await this.decisionEngine.executeDecision(decisionId);
      this.emit('decisionExecuted', decisionId, results);
      return results;
      
    } catch (error) {
      console.error(`❌ Error executing decision ${decisionId}:`, error);
      this.emit('executionError', decisionId, error);
      throw error;
    }
  }

  /**
   * التراجع عن قرار
   */
  async rollbackDecision(decisionId: string): Promise<boolean> {
    console.log(`🔄 Rolling back decision: ${decisionId}`);
    
    try {
      const success = await this.decisionEngine.rollbackDecision(decisionId);
      this.emit('decisionRolledBack', decisionId, success);
      return success;
      
    } catch (error) {
      console.error(`❌ Error rolling back decision ${decisionId}:`, error);
      this.emit('rollbackError', decisionId, error);
      throw error;
    }
  }

  /**
   * الحصول على تقرير الحالة
   */
  async getStatusReport(): Promise<{
    isRunning: boolean;
    uptime: number;
    config: L2DecisionConfig;
    metrics: L2Metrics;
    components: {
      decisionEngine: any;
      ruleProcessor: any;
      mlManager: any;
      contextManager: any;
      actionExecutor: any;
    };
  }> {
    const uptime = this.startTime ? Date.now() - this.startTime.getTime() : 0;
    
    return {
      isRunning: this.isRunning,
      uptime,
      config: this.config,
      metrics: this.metrics,
      components: {
        decisionEngine: this.decisionEngine.getDecisionStats(),
        ruleProcessor: this.ruleProcessor.getRuleStats(),
        mlManager: this.mlManager.getModelStats(),
        contextManager: await this.contextManager.getCurrentContext(),
        actionExecutor: this.actionExecutor.getExecutionHistory(10)
      }
    };
  }

  /**
   * تحديث التكوين
   */
  async updateConfig(newConfig: Partial<L2DecisionConfig>): Promise<void> {
    console.log('⚙️ Updating L2 Decision Layer configuration...');
    
    this.config = { ...this.config, ...newConfig };
    
    // إعادة تهيئة المكونات إذا لزم الأمر
    if (newConfig.rules) {
      await this.ruleProcessor.loadRules();
    }
    
    console.log('✅ Configuration updated');
    this.emit('configUpdated', this.config);
  }

  /**
   * الحصول على تاريخ القرارات
   */
  getDecisionHistory(filters?: any): Decision[] {
    return this.decisionEngine.getDecisionHistory(filters);
  }

  /**
   * الحصول على المقاييس الحالية
   */
  getCurrentMetrics(): L2Metrics {
    return { ...this.metrics };
  }

  // Private methods
  private initializeMetrics(): void {
    this.metrics = {
      performance: {
        decisionsPerMinute: 0,
        averageDecisionTime: 0,
        ruleEvaluationTime: 0,
        mlPredictionTime: 0,
        actionExecutionTime: 0
      },
      quality: {
        decisionAccuracy: 0,
        ruleEffectiveness: 0,
        mlModelAccuracy: 0,
        actionSuccessRate: 0
      },
      system: {
        memoryUsage: 0,
        cpuUsage: 0,
        activeDecisions: 0,
        queuedDecisions: 0
      }
    };
  }

  private initializeComponents(): void {
    // إنشاء مدير السياق
    this.contextManager = new ContextManager(this.config.context.dataPath);
    
    // إنشاء معالج القواعد
    this.ruleProcessor = new RuleProcessor(path.dirname(this.config.rules.rulesPath));
    
    // إنشاء مدير نماذج التعلم الآلي
    this.mlManager = new MLModelsManager(this.config.ml.modelsPath);
    
    // إنشاء منفذ الإجراءات
    const executionContext: ExecutionContext = {
      workspacePath: process.cwd(),
      projectType: 'flutter',
      environment: 'development',
      constraints: {}
    };
    this.actionExecutor = new ActionExecutor(executionContext);
    
    // إنشاء محرك القرارات
    this.decisionEngine = new DecisionEngine(
      this.contextManager,
      this.ruleProcessor,
      this.mlManager,
      this.actionExecutor
    );
  }

  private setupEventHandlers(): void {
    // أحداث محرك القرارات
    this.decisionEngine.on('decisionMade', (decision: Decision) => {
      console.log(`📋 Decision made: ${decision.type} (confidence: ${(decision.confidence * 100).toFixed(1)}%)`);
      this.emit('decisionMade', decision);
    });

    this.decisionEngine.on('decisionCompleted', (decision: Decision) => {
      console.log(`✅ Decision completed: ${decision.type}`);
      this.emit('decisionCompleted', decision);
    });

    this.decisionEngine.on('decisionFailed', (decision: Decision, error: any) => {
      console.log(`❌ Decision failed: ${decision.type} - ${error}`);
      this.emit('decisionFailed', decision, error);
    });

    // أحداث معالج القواعد
    this.ruleProcessor.on('ruleTriggered', (result: any) => {
      console.log(`📏 Rule triggered: ${result.rule.name}`);
      this.emit('ruleTriggered', result);
    });

    // أحداث مدير التعلم الآلي
    this.mlManager.on('predictionMade', (prediction: any) => {
      console.log(`🤖 ML prediction: ${prediction.decisionType} (confidence: ${(prediction.confidence * 100).toFixed(1)}%)`);
      this.emit('mlPrediction', prediction);
    });

    // أحداث مدير السياق
    this.contextManager.on('conflictsDetected', (conflicts: any[]) => {
      console.log(`⚠️ Conflicts detected: ${conflicts.length}`);
      this.emit('conflictsDetected', conflicts);
    });

    // أحداث منفذ الإجراءات
    this.actionExecutor.on('actionCompleted', (result: any) => {
      console.log(`✅ Action completed: ${result.actionId}`);
      this.emit('actionCompleted', result);
    });
  }

  private async ensureDirectories(): Promise<void> {
    const directories = [
      this.config.context.dataPath,
      this.config.ml.modelsPath,
      path.dirname(this.config.rules.rulesPath),
      path.dirname(this.config.security.auditLogPath)
    ];

    for (const dir of directories) {
      await fs.mkdir(dir, { recursive: true });
    }
  }

  private startMetricsMonitoring(): void {
    const interval = this.config.integration.monitoring.metricsInterval;
    
    this.metricsInterval = setInterval(() => {
      this.collectMetrics();
    }, interval);
    
    console.log(`📊 Metrics monitoring started (interval: ${interval}ms)`);
  }

  private collectMetrics(): void {
    // جمع مقاييس الأداء
    const decisions = this.decisionEngine.getDecisionHistory({ limit: 100 });
    const recentDecisions = decisions.filter(d => 
      Date.now() - d.timestamp.getTime() < 60000 // آخر دقيقة
    );
    
    this.metrics.performance.decisionsPerMinute = recentDecisions.length;
    
    if (decisions.length > 0) {
      this.metrics.quality.decisionAccuracy = 
        decisions.filter(d => d.status === 'completed').length / decisions.length;
    }
    
    // مقاييس النظام
    const memUsage = process.memoryUsage();
    this.metrics.system.memoryUsage = memUsage.heapUsed / 1024 / 1024; // MB
    this.metrics.system.activeDecisions = decisions.filter(d => d.status === 'executing').length;
    
    this.emit('metricsUpdated', this.metrics);
  }

  private updateMetrics(decisions: Decision[], executionResults: any[], executionTime: number): void {
    // تحديث مقاييس الأداء
    this.metrics.performance.averageDecisionTime = executionTime / decisions.length || 0;
    
    // تحديث مقاييس الجودة
    if (executionResults.length > 0) {
      this.metrics.quality.actionSuccessRate = 
        executionResults.filter(r => r.success).length / executionResults.length;
    }
  }

  private async saveResult(result: L2DecisionResult): Promise<void> {
    try {
      const timestamp = result.timestamp.toISOString().replace(/[:.]/g, '-');
      const resultPath = path.join(this.config.context.dataPath, `l2-result-${timestamp}.json`);
      
      await fs.writeFile(resultPath, JSON.stringify(result, null, 2));
      
    } catch (error) {
      console.error('❌ Error saving L2 result:', error);
    }
  }
}

// مثال على الاستخدام
if (require.main === module) {
  const l2Layer = new L2DecisionLayer();

  // تشغيل الطبقة
  l2Layer.start()
    .then(() => {
      console.log('🎯 L2 Decision Layer is ready');
      
      // محاكاة بيانات تحليل من L1
      const mockAnalysisData: AnalysisData = {
        source: 'flutter',
        timestamp: new Date(),
        metrics: {
          performance: { cpu: 85, memory: 70 },
          flutter: { buildTime: 12000, widgetCount: 150 },
          riverpod: { rebuildsPerMinute: 120 },
          isar: { queryTime: 800 }
        },
        patterns: [],
        insights: [],
        alerts: []
      };
      
      // معالجة البيانات
      return l2Layer.processAnalysisData(mockAnalysisData);
    })
    .then(result => {
      console.log('📊 L2 Decision Result:', result.summary);
      
      // الحصول على تقرير الحالة
      return l2Layer.getStatusReport();
    })
    .then(status => {
      console.log('📋 L2 Status Report:', {
        isRunning: status.isRunning,
        uptime: Math.round(status.uptime / 1000) + 's',
        decisions: status.components.decisionEngine.total,
        rules: status.components.ruleProcessor.total
      });
      
      // إيقاف الطبقة
      return l2Layer.stop();
    })
    .catch(error => {
      console.error('❌ Error:', error);
      l2Layer.stop();
    });
}