/**
 * Context Manager - Decision Context and State Management
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 11 ديسمبر 2025
 */

import { EventEmitter } from 'events';
import { promises as fs } from 'fs';
import * as path from 'path';
import { Constraint, Decision, DecisionContext, Dependency } from '../engine/decision-engine';

export interface SystemState {
  timestamp: Date;
  performance: {
    cpu: number;
    memory: number;
    disk: number;
  };
  flutter: {
    buildTime: number;
    widgetCount: number;
    stateComplexity: number;
  };
  riverpod: {
    providerCount: number;
    rebuildsPerMinute: number;
    stateNotifierCount: number;
  };
  isar: {
    queryTime: number;
    collectionCount: number;
    indexUsage: number;
  };
  codeQuality: {
    testCoverage: number;
    complexity: number;
    duplication: number;
  };
}

export interface ContextHistory {
  timestamp: Date;
  event: string;
  description: string; // Arabic
  data: any;
  impact: 'low' | 'medium' | 'high' | 'critical';
}

export interface Conflict {
  id: string;
  type: 'resource' | 'timing' | 'dependency' | 'constraint';
  description: string; // Arabic
  decisions: string[];
  severity: 'low' | 'medium' | 'high' | 'critical';
  resolution?: ConflictResolution;
}

export interface ConflictResolution {
  strategy: 'delay' | 'merge' | 'prioritize' | 'cancel';
  description: string; // Arabic
  parameters: Record<string, any>;
}

export class ContextManager extends EventEmitter {
  private context: DecisionContext;
  private systemState: SystemState;
  private history: ContextHistory[] = [];
  private conflicts: Map<string, Conflict> = new Map();
  private dependencies: Map<string, Dependency[]> = new Map();
  
  private readonly maxHistorySize = 1000;
  private readonly contextPath: string;

  constructor(dataPath: string = '.kiro/data/context') {
    super();
    
    this.contextPath = dataPath;
    this.initializeContext();
  }

  /**
   * تهيئة السياق الأولي
   */
  private initializeContext(): void {
    this.systemState = {
      timestamp: new Date(),
      performance: { cpu: 0, memory: 0, disk: 0 },
      flutter: { buildTime: 0, widgetCount: 0, stateComplexity: 0 },
      riverpod: { providerCount: 0, rebuildsPerMinute: 0, stateNotifierCount: 0 },
      isar: { queryTime: 0, collectionCount: 0, indexUsage: 0 },
      codeQuality: { testCoverage: 0, complexity: 0, duplication: 0 }
    };

    this.context = {
      systemState: this.systemState,
      activeDecisions: [],
      dependencies: [],
      constraints: [],
      metadata: {
        project: 'بصير MVP',
        initialized: new Date(),
        version: '1.0.0'
      }
    };
  }

  /**
   * تحديث السياق
   */
  async updateContext(updates: Partial<DecisionContext>): Promise<void> {
    console.log('🔄 Updating decision context...');
    
    try {
      // دمج التحديثات
      this.context = {
        ...this.context,
        ...updates,
        metadata: {
          ...this.context.metadata,
          ...updates.metadata,
          lastUpdated: new Date()
        }
      };

      // تسجيل في التاريخ
      this.addToHistory('context_updated', 'تم تحديث سياق القرارات', updates, 'medium');

      // حفظ السياق
      await this.saveContext();

      // إشعار المستمعين
      this.emit('contextUpdated', this.context);
      
      console.log('✅ Context updated successfully');
      
    } catch (error) {
      console.error('❌ Error updating context:', error);
      throw error;
    }
  }

  /**
   * تحديث حالة النظام
   */
  async updateSystemState(newState: Partial<SystemState>): Promise<void> {
    console.log('📊 Updating system state...');
    
    const previousState = { ...this.systemState };
    
    this.systemState = {
      ...this.systemState,
      ...newState,
      timestamp: new Date()
    };

    // تحديث السياق
    await this.updateContext({
      systemState: this.systemState
    });

    // تحليل التغييرات المهمة
    await this.analyzeStateChanges(previousState, this.systemState);
    
    console.log('✅ System state updated');
  }

  /**
   * الحصول على السياق الحالي
   */
  async getCurrentContext(): Promise<DecisionContext> {
    return { ...this.context };
  }

  /**
   * إضافة قرار نشط
   */
  async addActiveDecision(decisionId: string): Promise<void> {
    if (!this.context.activeDecisions.includes(decisionId)) {
      this.context.activeDecisions.push(decisionId);
      
      await this.updateContext({
        activeDecisions: this.context.activeDecisions
      });
      
      this.addToHistory('decision_activated', `تم تفعيل القرار: ${decisionId}`, { decisionId }, 'medium');
    }
  }

  /**
   * إزالة قرار نشط
   */
  async removeActiveDecision(decisionId: string): Promise<void> {
    const index = this.context.activeDecisions.indexOf(decisionId);
    
    if (index >= 0) {
      this.context.activeDecisions.splice(index, 1);
      
      await this.updateContext({
        activeDecisions: this.context.activeDecisions
      });
      
      this.addToHistory('decision_completed', `تم إكمال القرار: ${decisionId}`, { decisionId }, 'medium');
    }
  }

  /**
   * إضافة تبعية
   */
  async addDependency(dependency: Dependency): Promise<void> {
    console.log(`🔗 Adding dependency: ${dependency.from} -> ${dependency.to}`);
    
    // إضافة إلى السياق
    this.context.dependencies.push(dependency);
    
    // إضافة إلى فهرس التبعيات
    const fromDeps = this.dependencies.get(dependency.from) || [];
    fromDeps.push(dependency);
    this.dependencies.set(dependency.from, fromDeps);
    
    await this.updateContext({
      dependencies: this.context.dependencies
    });
    
    this.addToHistory('dependency_added', `تم إضافة تبعية: ${dependency.description}`, dependency, 'low');
  }

  /**
   * إزالة تبعية
   */
  async removeDependency(from: string, to: string): Promise<void> {
    // إزالة من السياق
    this.context.dependencies = this.context.dependencies.filter(
      dep => !(dep.from === from && dep.to === to)
    );
    
    // إزالة من الفهرس
    const fromDeps = this.dependencies.get(from) || [];
    const updatedDeps = fromDeps.filter(dep => dep.to !== to);
    
    if (updatedDeps.length > 0) {
      this.dependencies.set(from, updatedDeps);
    } else {
      this.dependencies.delete(from);
    }
    
    await this.updateContext({
      dependencies: this.context.dependencies
    });
    
    this.addToHistory('dependency_removed', `تم إزالة تبعية: ${from} -> ${to}`, { from, to }, 'low');
  }

  /**
   * إضافة قيد
   */
  async addConstraint(constraint: Constraint): Promise<void> {
    console.log(`⚠️ Adding constraint: ${constraint.type}`);
    
    this.context.constraints.push(constraint);
    
    await this.updateContext({
      constraints: this.context.constraints
    });
    
    this.addToHistory('constraint_added', `تم إضافة قيد: ${constraint.message}`, constraint, 'medium');
  }

  /**
   * إزالة قيد
   */
  async removeConstraint(constraintId: string): Promise<void> {
    this.context.constraints = this.context.constraints.filter(
      constraint => constraint.id !== constraintId
    );
    
    await this.updateContext({
      constraints: this.context.constraints
    });
    
    this.addToHistory('constraint_removed', `تم إزالة قيد: ${constraintId}`, { constraintId }, 'medium');
  }

  /**
   * التحقق من التعارضات
   */
  async checkConflicts(decision: Decision): Promise<Conflict[]> {
    console.log(`🔍 Checking conflicts for decision: ${decision.type}`);
    
    const conflicts: Conflict[] = [];
    
    // التحقق من تعارضات الموارد
    const resourceConflicts = await this.checkResourceConflicts(decision);
    conflicts.push(...resourceConflicts);
    
    // التحقق من تعارضات التوقيت
    const timingConflicts = await this.checkTimingConflicts(decision);
    conflicts.push(...timingConflicts);
    
    // التحقق من تعارضات التبعيات
    const dependencyConflicts = await this.checkDependencyConflicts(decision);
    conflicts.push(...dependencyConflicts);
    
    // التحقق من تعارضات القيود
    const constraintConflicts = await this.checkConstraintConflicts(decision);
    conflicts.push(...constraintConflicts);
    
    // حفظ التعارضات المكتشفة
    for (const conflict of conflicts) {
      this.conflicts.set(conflict.id, conflict);
    }
    
    if (conflicts.length > 0) {
      console.log(`⚠️ Found ${conflicts.length} conflicts`);
      this.emit('conflictsDetected', conflicts);
    }
    
    return conflicts;
  }

  /**
   * حل تعارض
   */
  async resolveConflict(conflictId: string, resolution: ConflictResolution): Promise<boolean> {
    const conflict = this.conflicts.get(conflictId);
    
    if (!conflict) {
      console.error(`❌ Conflict not found: ${conflictId}`);
      return false;
    }
    
    console.log(`🔧 Resolving conflict: ${conflict.type} with strategy: ${resolution.strategy}`);
    
    try {
      conflict.resolution = resolution;
      
      // تطبيق استراتيجية الحل
      const success = await this.applyResolutionStrategy(conflict, resolution);
      
      if (success) {
        this.conflicts.delete(conflictId);
        this.addToHistory('conflict_resolved', `تم حل التعارض: ${conflict.description}`, { conflictId, resolution }, 'high');
        this.emit('conflictResolved', conflict);
      }
      
      return success;
      
    } catch (error) {
      console.error(`❌ Error resolving conflict:`, error);
      return false;
    }
  }

  /**
   * الحصول على التاريخ
   */
  getHistory(limit?: number): ContextHistory[] {
    const history = [...this.history].reverse(); // الأحدث أولاً
    return limit ? history.slice(0, limit) : history;
  }

  /**
   * الحصول على التبعيات
   */
  getDependencies(decisionId?: string): Dependency[] {
    if (decisionId) {
      return this.dependencies.get(decisionId) || [];
    }
    
    return this.context.dependencies;
  }

  /**
   * الحصول على التعارضات النشطة
   */
  getActiveConflicts(): Conflict[] {
    return Array.from(this.conflicts.values());
  }

  /**
   * حفظ السياق
   */
  async saveContext(): Promise<void> {
    try {
      await fs.mkdir(this.contextPath, { recursive: true });
      
      const contextFile = path.join(this.contextPath, 'current-context.json');
      await fs.writeFile(contextFile, JSON.stringify(this.context, null, 2));
      
      const historyFile = path.join(this.contextPath, 'context-history.json');
      await fs.writeFile(historyFile, JSON.stringify(this.history, null, 2));
      
    } catch (error) {
      console.error('❌ Error saving context:', error);
    }
  }

  /**
   * تحميل السياق
   */
  async loadContext(): Promise<void> {
    try {
      const contextFile = path.join(this.contextPath, 'current-context.json');
      const historyFile = path.join(this.contextPath, 'context-history.json');
      
      // تحميل السياق
      try {
        const contextData = await fs.readFile(contextFile, 'utf-8');
        this.context = JSON.parse(contextData);
        console.log('📂 Context loaded from file');
      } catch {
        console.log('📂 No existing context found, using default');
      }
      
      // تحميل التاريخ
      try {
        const historyData = await fs.readFile(historyFile, 'utf-8');
        this.history = JSON.parse(historyData);
        console.log('📂 History loaded from file');
      } catch {
        console.log('📂 No existing history found, starting fresh');
      }
      
    } catch (error) {
      console.error('❌ Error loading context:', error);
    }
  }

  // Helper methods
  private addToHistory(event: string, description: string, data: any, impact: 'low' | 'medium' | 'high' | 'critical'): void {
    const entry: ContextHistory = {
      timestamp: new Date(),
      event,
      description,
      data,
      impact
    };
    
    this.history.push(entry);
    
    // الحفاظ على حجم التاريخ
    if (this.history.length > this.maxHistorySize) {
      this.history = this.history.slice(-this.maxHistorySize);
    }
    
    this.emit('historyUpdated', entry);
  }

  private async analyzeStateChanges(previous: SystemState, current: SystemState): Promise<void> {
    // تحليل تغييرات الأداء
    if (current.performance.cpu > previous.performance.cpu + 20) {
      this.addToHistory('performance_degradation', 'ارتفاع استخدام المعالج', {
        previous: previous.performance.cpu,
        current: current.performance.cpu
      }, 'high');
    }
    
    // تحليل تغييرات Flutter
    if (current.flutter.buildTime > previous.flutter.buildTime * 1.5) {
      this.addToHistory('build_time_increase', 'زيادة وقت البناء', {
        previous: previous.flutter.buildTime,
        current: current.flutter.buildTime
      }, 'medium');
    }
    
    // تحليل تغييرات Riverpod
    if (current.riverpod.rebuildsPerMinute > previous.riverpod.rebuildsPerMinute * 2) {
      this.addToHistory('excessive_rebuilds', 'زيادة مفرطة في إعادة البناء', {
        previous: previous.riverpod.rebuildsPerMinute,
        current: current.riverpod.rebuildsPerMinute
      }, 'high');
    }
  }

  private async checkResourceConflicts(decision: Decision): Promise<Conflict[]> {
    const conflicts: Conflict[] = [];
    
    // التحقق من تعارضات الذاكرة والمعالج
    if (decision.type.includes('OPTIMIZE') && this.systemState.performance.cpu > 80) {
      conflicts.push({
        id: `resource_conflict_${Date.now()}`,
        type: 'resource',
        description: 'استخدام عالي للمعالج قد يتعارض مع عملية التحسين',
        decisions: [decision.id],
        severity: 'medium'
      });
    }
    
    return conflicts;
  }

  private async checkTimingConflicts(decision: Decision): Promise<Conflict[]> {
    const conflicts: Conflict[] = [];
    
    // التحقق من القرارات المتزامنة
    const activeOptimizations = this.context.activeDecisions.filter(id => 
      id.includes('optimize') || id.includes('refactor')
    );
    
    if (activeOptimizations.length > 0 && decision.type.includes('OPTIMIZE')) {
      conflicts.push({
        id: `timing_conflict_${Date.now()}`,
        type: 'timing',
        description: 'يوجد عمليات تحسين أخرى قيد التنفيذ',
        decisions: [decision.id, ...activeOptimizations],
        severity: 'low'
      });
    }
    
    return conflicts;
  }

  private async checkDependencyConflicts(decision: Decision): Promise<Conflict[]> {
    const conflicts: Conflict[] = [];
    
    // التحقق من التبعيات الدائرية
    const dependencies = this.getDependencies(decision.id);
    
    for (const dep of dependencies) {
      const reverseDeps = this.getDependencies(dep.to);
      const hasCircular = reverseDeps.some(rdep => rdep.to === decision.id);
      
      if (hasCircular) {
        conflicts.push({
          id: `dependency_conflict_${Date.now()}`,
          type: 'dependency',
          description: `تبعية دائرية مكتشفة: ${decision.id} ↔ ${dep.to}`,
          decisions: [decision.id, dep.to],
          severity: 'high'
        });
      }
    }
    
    return conflicts;
  }

  private async checkConstraintConflicts(decision: Decision): Promise<Conflict[]> {
    const conflicts: Conflict[] = [];
    
    // التحقق من انتهاك القيود
    for (const constraint of this.context.constraints) {
      if (this.violatesConstraint(decision, constraint)) {
        conflicts.push({
          id: `constraint_conflict_${Date.now()}`,
          type: 'constraint',
          description: `انتهاك القيد: ${constraint.message}`,
          decisions: [decision.id],
          severity: 'high'
        });
      }
    }
    
    return conflicts;
  }

  private violatesConstraint(decision: Decision, constraint: Constraint): boolean {
    // منطق فحص انتهاك القيود
    // يمكن تخصيصه حسب نوع القيد
    return false; // مؤقت
  }

  private async applyResolutionStrategy(conflict: Conflict, resolution: ConflictResolution): Promise<boolean> {
    switch (resolution.strategy) {
      case 'delay':
        // تأخير أحد القرارات
        console.log('⏰ Applying delay strategy');
        return true;
        
      case 'merge':
        // دمج القرارات المتعارضة
        console.log('🔀 Applying merge strategy');
        return true;
        
      case 'prioritize':
        // إعطاء أولوية لقرار معين
        console.log('⬆️ Applying prioritize strategy');
        return true;
        
      case 'cancel':
        // إلغاء أحد القرارات
        console.log('❌ Applying cancel strategy');
        return true;
        
      default:
        console.warn(`⚠️ Unknown resolution strategy: ${resolution.strategy}`);
        return false;
    }
  }
}