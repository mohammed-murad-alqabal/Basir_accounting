/**
 * Decision Engine - Core Component of L2 Decision Layer
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 11 ديسمبر 2025
 */

import { EventEmitter } from 'events';
import { ActionExecutor } from '../actions/action-executor';
import { ContextManager } from '../context/context-manager';
import { MLModelsManager } from '../ml/ml-models-manager';
import { RuleProcessor } from '../rules/rule-processor';

export enum DecisionType {
  // Flutter Performance
  OPTIMIZE_WIDGET = 'optimize_widget',
  REDUCE_REBUILDS = 'reduce_rebuilds',
  IMPROVE_RENDERING = 'improve_rendering',
  
  // State Management (Riverpod)
  OPTIMIZE_PROVIDERS = 'optimize_providers',
  REFACTOR_STATE = 'refactor_state',
  ADD_CACHING = 'add_caching',
  
  // Database (Isar)
  OPTIMIZE_QUERIES = 'optimize_queries',
  ADD_INDEXES = 'add_indexes',
  CLEANUP_DATA = 'cleanup_data',
  
  // Code Quality
  REFACTOR_CODE = 'refactor_code',
  ADD_TESTS = 'add_tests',
  UPDATE_DEPENDENCIES = 'update_dependencies',
  
  // System Health
  SCALE_RESOURCES = 'scale_resources',
  RESTART_SERVICES = 'restart_services',
  ALERT_TEAM = 'alert_team'
}

export enum Priority {
  CRITICAL = 10,
  HIGH = 8,
  MEDIUM = 5,
  LOW = 3,
  INFO = 1
}

export interface Decision {
  id: string;
  timestamp: Date;
  type: DecisionType;
  priority: Priority;
  rationale: string; // Arabic explanation
  actions: Action[];
  confidence: number;
  source: 'rule' | 'ml' | 'hybrid';
  context: DecisionContext;
  status: 'pending' | 'executing' | 'completed' | 'failed' | 'rolled_back';
  executionResults?: ExecutionResult[];
}

export interface Action {
  id: string;
  type: string;
  description: string; // Arabic
  parameters: Record<string, any>;
  timeout: number;
  retries: number;
  rollbackable: boolean;
  dependencies: string[];
}

export interface DecisionContext {
  systemState: Record<string, any>;
  activeDecisions: string[];
  dependencies: Dependency[];
  constraints: Constraint[];
  metadata: Record<string, any>;
}

export interface Dependency {
  from: string;
  to: string;
  type: 'blocks' | 'requires' | 'conflicts';
  description: string;
}

export interface Constraint {
  id: string;
  type: string;
  condition: string;
  message: string; // Arabic
}

export interface ExecutionResult {
  actionId: string;
  success: boolean;
  message: string; // Arabic
  data?: any;
  duration: number;
  timestamp: Date;
}

export interface AnalysisData {
  source: 'workspace' | 'flutter' | 'system';
  timestamp: Date;
  metrics: Record<string, any>;
  patterns?: any[];
  insights?: any[];
  alerts?: any[];
}

export class DecisionEngine extends EventEmitter {
  private contextManager: ContextManager;
  private ruleProcessor: RuleProcessor;
  private mlManager: MLModelsManager;
  private actionExecutor: ActionExecutor;
  
  private decisions: Map<string, Decision> = new Map();
  private isProcessing = false;
  private processingQueue: AnalysisData[] = [];

  constructor(
    contextManager: ContextManager,
    ruleProcessor: RuleProcessor,
    mlManager: MLModelsManager,
    actionExecutor: ActionExecutor
  ) {
    super();
    this.contextManager = contextManager;
    this.ruleProcessor = ruleProcessor;
    this.mlManager = mlManager;
    this.actionExecutor = actionExecutor;
    
    // ربط الأحداث
    this.setupEventHandlers();
  }

  /**
   * معالجة بيانات التحليل واتخاذ القرارات
   */
  async processAnalysisData(data: AnalysisData): Promise<Decision[]> {
    console.log(`🧠 Processing analysis data from ${data.source}...`);
    
    try {
      // إضافة إلى قائمة الانتظار إذا كان النظام مشغولاً
      if (this.isProcessing) {
        this.processingQueue.push(data);
        console.log('📋 Added to processing queue');
        return [];
      }
      
      this.isProcessing = true;
      
      // تحديث السياق
      await this.contextManager.updateContext({
        lastAnalysis: data,
        timestamp: new Date()
      });
      
      // تقييم القواعد
      const ruleDecisions = await this.evaluateRules(data);
      
      // الحصول على توقعات التعلم الآلي
      const mlDecisions = await this.getMlPredictions(data);
      
      // دمج القرارات
      const allDecisions = [...ruleDecisions, ...mlDecisions];
      
      // ترتيب القرارات حسب الأولوية
      const prioritizedDecisions = this.prioritizeDecisions(allDecisions);
      
      // التحقق من التعارضات والتبعيات
      const validatedDecisions = await this.validateDecisions(prioritizedDecisions);
      
      // حفظ القرارات
      for (const decision of validatedDecisions) {
        this.decisions.set(decision.id, decision);
        this.emit('decisionMade', decision);
      }
      
      console.log(`✅ Generated ${validatedDecisions.length} decisions`);
      
      // معالجة قائمة الانتظار
      await this.processQueue();
      
      return validatedDecisions;
      
    } catch (error) {
      console.error('❌ Error processing analysis data:', error);
      this.emit('error', error);
      throw error;
    } finally {
      this.isProcessing = false;
    }
  }

  /**
   * تقييم القواعد
   */
  private async evaluateRules(data: AnalysisData): Promise<Decision[]> {
    console.log('📏 Evaluating rules...');
    
    try {
      const ruleResults = await this.ruleProcessor.evaluateAllRules(data);
      const decisions: Decision[] = [];
      
      for (const result of ruleResults) {
        if (result.triggered) {
          const decision: Decision = {
            id: this.generateDecisionId(),
            timestamp: new Date(),
            type: result.rule.decisionType,
            priority: result.rule.priority,
            rationale: result.rule.rationale || `تم تطبيق القاعدة: ${result.rule.name}`,
            actions: result.actions,
            confidence: result.confidence,
            source: 'rule',
            context: await this.contextManager.getCurrentContext(),
            status: 'pending'
          };
          
          decisions.push(decision);
        }
      }
      
      console.log(`📏 Rules generated ${decisions.length} decisions`);
      return decisions;
      
    } catch (error) {
      console.error('❌ Error evaluating rules:', error);
      return [];
    }
  }

  /**
   * الحصول على توقعات التعلم الآلي
   */
  private async getMlPredictions(data: AnalysisData): Promise<Decision[]> {
    console.log('🤖 Getting ML predictions...');
    
    try {
      const predictions = await this.mlManager.predictDecisions(data);
      const decisions: Decision[] = [];
      
      for (const prediction of predictions) {
        if (prediction.confidence > 0.7) { // عتبة الثقة
          const decision: Decision = {
            id: this.generateDecisionId(),
            timestamp: new Date(),
            type: prediction.decisionType,
            priority: prediction.priority,
            rationale: prediction.rationale || `توقع التعلم الآلي بثقة ${(prediction.confidence * 100).toFixed(1)}%`,
            actions: prediction.actions,
            confidence: prediction.confidence,
            source: 'ml',
            context: await this.contextManager.getCurrentContext(),
            status: 'pending'
          };
          
          decisions.push(decision);
        }
      }
      
      console.log(`🤖 ML generated ${decisions.length} decisions`);
      return decisions;
      
    } catch (error) {
      console.error('❌ Error getting ML predictions:', error);
      return [];
    }
  }

  /**
   * ترتيب القرارات حسب الأولوية
   */
  private prioritizeDecisions(decisions: Decision[]): Decision[] {
    return decisions.sort((a, b) => {
      // الأولوية أولاً
      if (a.priority !== b.priority) {
        return b.priority - a.priority;
      }
      
      // الثقة ثانياً
      if (a.confidence !== b.confidence) {
        return b.confidence - a.confidence;
      }
      
      // الوقت ثالثاً (الأحدث أولاً)
      return b.timestamp.getTime() - a.timestamp.getTime();
    });
  }

  /**
   * التحقق من صحة القرارات
   */
  private async validateDecisions(decisions: Decision[]): Promise<Decision[]> {
    console.log('✅ Validating decisions...');
    
    const validDecisions: Decision[] = [];
    const context = await this.contextManager.getCurrentContext();
    
    for (const decision of decisions) {
      // التحقق من التعارضات
      const conflicts = await this.contextManager.checkConflicts(decision);
      
      if (conflicts.length === 0) {
        validDecisions.push(decision);
      } else {
        console.log(`⚠️ Decision ${decision.id} has conflicts:`, conflicts);
        // يمكن إضافة منطق لحل التعارضات هنا
      }
    }
    
    console.log(`✅ Validated ${validDecisions.length}/${decisions.length} decisions`);
    return validDecisions;
  }

  /**
   * تنفيذ قرار
   */
  async executeDecision(decisionId: string): Promise<ExecutionResult[]> {
    const decision = this.decisions.get(decisionId);
    if (!decision) {
      throw new Error(`Decision ${decisionId} not found`);
    }
    
    console.log(`🚀 Executing decision: ${decision.type}`);
    
    try {
      decision.status = 'executing';
      this.emit('decisionExecuting', decision);
      
      const results = await this.actionExecutor.executeActions(decision.actions);
      
      decision.executionResults = results;
      decision.status = results.every(r => r.success) ? 'completed' : 'failed';
      
      this.emit('decisionCompleted', decision);
      
      console.log(`✅ Decision execution completed: ${decision.status}`);
      return results;
      
    } catch (error) {
      decision.status = 'failed';
      console.error(`❌ Decision execution failed:`, error);
      this.emit('decisionFailed', decision, error);
      throw error;
    }
  }

  /**
   * التراجع عن قرار
   */
  async rollbackDecision(decisionId: string): Promise<boolean> {
    const decision = this.decisions.get(decisionId);
    if (!decision) {
      throw new Error(`Decision ${decisionId} not found`);
    }
    
    console.log(`🔄 Rolling back decision: ${decision.type}`);
    
    try {
      const rollbackResults = await this.actionExecutor.rollbackActions(decision.actions);
      
      decision.status = 'rolled_back';
      this.emit('decisionRolledBack', decision);
      
      console.log(`✅ Decision rollback completed`);
      return rollbackResults.every(r => r.success);
      
    } catch (error) {
      console.error(`❌ Decision rollback failed:`, error);
      throw error;
    }
  }

  /**
   * الحصول على تاريخ القرارات
   */
  getDecisionHistory(filters?: {
    type?: DecisionType;
    status?: string;
    source?: string;
    limit?: number;
  }): Decision[] {
    let decisions = Array.from(this.decisions.values());
    
    if (filters) {
      if (filters.type) {
        decisions = decisions.filter(d => d.type === filters.type);
      }
      if (filters.status) {
        decisions = decisions.filter(d => d.status === filters.status);
      }
      if (filters.source) {
        decisions = decisions.filter(d => d.source === filters.source);
      }
      if (filters.limit) {
        decisions = decisions.slice(0, filters.limit);
      }
    }
    
    return decisions.sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime());
  }

  /**
   * إعداد معالجات الأحداث
   */
  private setupEventHandlers(): void {
    this.contextManager.on('contextUpdated', (context) => {
      this.emit('contextChanged', context);
    });
    
    this.actionExecutor.on('actionCompleted', (result) => {
      this.emit('actionCompleted', result);
    });
    
    this.actionExecutor.on('actionFailed', (error) => {
      this.emit('actionFailed', error);
    });
  }

  /**
   * معالجة قائمة الانتظار
   */
  private async processQueue(): Promise<void> {
    if (this.processingQueue.length > 0) {
      const nextData = this.processingQueue.shift()!;
      console.log(`📋 Processing queued data from ${nextData.source}`);
      await this.processAnalysisData(nextData);
    }
  }

  /**
   * توليد معرف قرار فريد
   */
  private generateDecisionId(): string {
    return `decision_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  /**
   * الحصول على إحصائيات القرارات
   */
  getDecisionStats(): {
    total: number;
    byStatus: Record<string, number>;
    byType: Record<string, number>;
    bySource: Record<string, number>;
    averageConfidence: number;
  } {
    const decisions = Array.from(this.decisions.values());
    
    const stats = {
      total: decisions.length,
      byStatus: {} as Record<string, number>,
      byType: {} as Record<string, number>,
      bySource: {} as Record<string, number>,
      averageConfidence: 0
    };
    
    let totalConfidence = 0;
    
    for (const decision of decisions) {
      // حسب الحالة
      stats.byStatus[decision.status] = (stats.byStatus[decision.status] || 0) + 1;
      
      // حسب النوع
      stats.byType[decision.type] = (stats.byType[decision.type] || 0) + 1;
      
      // حسب المصدر
      stats.bySource[decision.source] = (stats.bySource[decision.source] || 0) + 1;
      
      totalConfidence += decision.confidence;
    }
    
    stats.averageConfidence = decisions.length > 0 ? totalConfidence / decisions.length : 0;
    
    return stats;
  }
}