/**
 * Rule Processor - Rules Management and Evaluation
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 11 ديسمبر 2025
 */

import { EventEmitter } from 'events';
import { promises as fs } from 'fs';
import * as yaml from 'js-yaml';
import * as path from 'path';
import { Action, DecisionType, Priority } from '../engine/decision-engine';

export interface Rule {
  id: string;
  name: string;
  description: string; // Arabic
  category: RuleCategory;
  conditions: Condition[];
  actions: ActionTemplate[];
  decisionType: DecisionType;
  priority: Priority;
  enabled: boolean;
  rationale?: string; // Arabic explanation
  metadata: RuleMetadata;
}

export interface Condition {
  field: string;
  operator: ConditionOperator;
  value: any;
  type: 'number' | 'string' | 'boolean' | 'array';
  description?: string; // Arabic
}

export enum ConditionOperator {
  EQUALS = '==',
  NOT_EQUALS = '!=',
  GREATER_THAN = '>',
  GREATER_THAN_OR_EQUAL = '>=',
  LESS_THAN = '<',
  LESS_THAN_OR_EQUAL = '<=',
  CONTAINS = 'contains',
  NOT_CONTAINS = 'not_contains',
  IN = 'in',
  NOT_IN = 'not_in',
  REGEX = 'regex',
  EXISTS = 'exists',
  NOT_EXISTS = 'not_exists'
}

export interface ActionTemplate {
  type: string;
  description: string; // Arabic
  parameters: Record<string, any>;
  timeout?: number;
  retries?: number;
  rollbackable?: boolean;
  dependencies?: string[];
}

export enum RuleCategory {
  FLUTTER_PERFORMANCE = 'flutter_performance',
  RIVERPOD_OPTIMIZATION = 'riverpod_optimization',
  ISAR_DATABASE = 'isar_database',
  CODE_QUALITY = 'code_quality',
  SYSTEM_HEALTH = 'system_health',
  SECURITY = 'security',
  MAINTENANCE = 'maintenance'
}

export interface RuleMetadata {
  author: string;
  version: string;
  created: Date;
  updated: Date;
  tags: string[];
  documentation?: string;
}

export interface RuleResult {
  rule: Rule;
  triggered: boolean;
  confidence: number;
  actions: Action[];
  evaluationTime: number;
  matchedConditions: Condition[];
  failedConditions: Condition[];
  context: Record<string, any>;
}

export interface RuleEvaluationContext {
  data: any;
  timestamp: Date;
  source: string;
  metadata: Record<string, any>;
}

export class RuleProcessor extends EventEmitter {
  private rules: Map<string, Rule> = new Map();
  private rulesByCategory: Map<RuleCategory, Rule[]> = new Map();
  private evaluationCache: Map<string, RuleResult> = new Map();
  private cacheTimeout = 60000; // 1 minute

  constructor(private configPath: string = '.kiro/config') {
    super();
    this.initializeCategories();
  }

  /**
   * تحميل القواعد من الملفات
   */
  async loadRules(rulesPath?: string): Promise<void> {
    const loadPath = rulesPath || path.join(this.configPath, 'l2-rules.yml');
    
    console.log(`📋 Loading rules from: ${loadPath}`);
    
    try {
      const content = await fs.readFile(loadPath, 'utf-8');
      const rulesConfig = yaml.load(content) as any;
      
      let loadedCount = 0;
      
      for (const [category, categoryRules] of Object.entries(rulesConfig.rules)) {
        const ruleCategory = category as RuleCategory;
        
        for (const ruleData of categoryRules as any[]) {
          const rule = this.parseRule(ruleData, ruleCategory);
          
          if (this.validateRule(rule).isValid) {
            this.rules.set(rule.id, rule);
            this.addToCategory(rule);
            loadedCount++;
          } else {
            console.warn(`⚠️ Invalid rule skipped: ${rule.id}`);
          }
        }
      }
      
      console.log(`✅ Loaded ${loadedCount} rules`);
      this.emit('rulesLoaded', loadedCount);
      
    } catch (error) {
      console.error('❌ Error loading rules:', error);
      throw error;
    }
  }

  /**
   * تقييم جميع القواعد
   */
  async evaluateAllRules(data: any): Promise<RuleResult[]> {
    console.log('📏 Evaluating all rules...');
    
    const context: RuleEvaluationContext = {
      data,
      timestamp: new Date(),
      source: data.source || 'unknown',
      metadata: data.metadata || {}
    };
    
    const results: RuleResult[] = [];
    const enabledRules = Array.from(this.rules.values()).filter(r => r.enabled);
    
    for (const rule of enabledRules) {
      try {
        const result = await this.evaluateRule(rule, context);
        results.push(result);
        
        if (result.triggered) {
          console.log(`✅ Rule triggered: ${rule.name}`);
          this.emit('ruleTriggered', result);
        }
        
      } catch (error) {
        console.error(`❌ Error evaluating rule ${rule.id}:`, error);
        this.emit('ruleError', rule, error);
      }
    }
    
    const triggeredCount = results.filter(r => r.triggered).length;
    console.log(`📏 Evaluated ${results.length} rules, ${triggeredCount} triggered`);
    
    return results;
  }

  /**
   * تقييم قاعدة واحدة
   */
  async evaluateRule(rule: Rule, context: RuleEvaluationContext): Promise<RuleResult> {
    const startTime = Date.now();
    
    // التحقق من الكاش
    const cacheKey = <credential-fixture>(rule, context);
    const cached = this.evaluationCache.get(cacheKey);
    
    if (cached && (Date.now() - cached.evaluationTime) < this.cacheTimeout) {
      return cached;
    }
    
    const result: RuleResult = {
      rule,
      triggered: false,
      confidence: 0,
      actions: [],
      evaluationTime: 0,
      matchedConditions: [],
      failedConditions: [],
      context: context.metadata
    };
    
    try {
      // تقييم الشروط
      const conditionResults = await this.evaluateConditions(rule.conditions, context.data);
      
      result.matchedConditions = conditionResults.matched;
      result.failedConditions = conditionResults.failed;
      
      // تحديد ما إذا كانت القاعدة مُطبقة
      const allConditionsMet = conditionResults.failed.length === 0;
      result.triggered = allConditionsMet;
      
      if (result.triggered) {
        // حساب الثقة
        result.confidence = this.calculateConfidence(rule, conditionResults);
        
        // إنشاء الإجراءات
        result.actions = await this.generateActions(rule.actions, context);
      }
      
      result.evaluationTime = Date.now() - startTime;
      
      // حفظ في الكاش
      this.evaluationCache.set(cacheKey, result);
      
      return result;
      
    } catch (error) {
      console.error(`❌ Error in rule evaluation:`, error);
      result.evaluationTime = Date.now() - startTime;
      return result;
    }
  }

  /**
   * تقييم الشروط
   */
  private async evaluateConditions(conditions: Condition[], data: any): Promise<{
    matched: Condition[];
    failed: Condition[];
  }> {
    const matched: Condition[] = [];
    const failed: Condition[] = [];
    
    for (const condition of conditions) {
      try {
        const fieldValue = this.getFieldValue(data, condition.field);
        const conditionMet = this.evaluateCondition(condition, fieldValue);
        
        if (conditionMet) {
          matched.push(condition);
        } else {
          failed.push(condition);
        }
        
      } catch (error) {
        console.error(`❌ Error evaluating condition ${condition.field}:`, error);
        failed.push(condition);
      }
    }
    
    return { matched, failed };
  }

  /**
   * تقييم شرط واحد
   */
  private evaluateCondition(condition: Condition, fieldValue: any): boolean {
    const { operator, value, type } = condition;
    
    // التحقق من وجود القيمة
    if (operator === ConditionOperator.EXISTS) {
      return fieldValue !== undefined && fieldValue !== null;
    }
    
    if (operator === ConditionOperator.NOT_EXISTS) {
      return fieldValue === undefined || fieldValue === null;
    }
    
    // إذا كانت القيمة غير موجودة
    if (fieldValue === undefined || fieldValue === null) {
      return false;
    }
    
    // تحويل النوع إذا لزم الأمر
    const convertedValue = this.convertValue(fieldValue, type);
    const expectedValue = this.convertValue(value, type);
    
    switch (operator) {
      case ConditionOperator.EQUALS:
        return convertedValue === expectedValue;
        
      case ConditionOperator.NOT_EQUALS:
        return convertedValue !== expectedValue;
        
      case ConditionOperator.GREATER_THAN:
        return convertedValue > expectedValue;
        
      case ConditionOperator.GREATER_THAN_OR_EQUAL:
        return convertedValue >= expectedValue;
        
      case ConditionOperator.LESS_THAN:
        return convertedValue < expectedValue;
        
      case ConditionOperator.LESS_THAN_OR_EQUAL:
        return convertedValue <= expectedValue;
        
      case ConditionOperator.CONTAINS:
        return String(convertedValue).includes(String(expectedValue));
        
      case ConditionOperator.NOT_CONTAINS:
        return !String(convertedValue).includes(String(expectedValue));
        
      case ConditionOperator.IN:
        return Array.isArray(expectedValue) && expectedValue.includes(convertedValue);
        
      case ConditionOperator.NOT_IN:
        return Array.isArray(expectedValue) && !expectedValue.includes(convertedValue);
        
      case ConditionOperator.REGEX:
        const regex = new RegExp(String(expectedValue));
        return regex.test(String(convertedValue));
        
      default:
        console.warn(`⚠️ Unknown operator: ${operator}`);
        return false;
    }
  }

  /**
   * إنشاء الإجراءات من القوالب
   */
  private async generateActions(templates: ActionTemplate[], context: RuleEvaluationContext): Promise<Action[]> {
    const actions: Action[] = [];
    
    for (const template of templates) {
      const action: Action = {
        id: this.generateActionId(),
        type: template.type,
        description: template.description,
        parameters: { ...template.parameters },
        timeout: template.timeout || 30000,
        retries: template.retries || 3,
        rollbackable: template.rollbackable || false,
        dependencies: template.dependencies || []
      };
      
      // تخصيص المعاملات بناءً على السياق
      action.parameters = this.customizeParameters(action.parameters, context);
      
      actions.push(action);
    }
    
    return actions;
  }

  /**
   * حساب الثقة
   */
  private calculateConfidence(rule: Rule, conditionResults: { matched: Condition[]; failed: Condition[] }): number {
    const totalConditions = rule.conditions.length;
    const matchedConditions = conditionResults.matched.length;
    
    if (totalConditions === 0) return 1.0;
    
    const baseConfidence = matchedConditions / totalConditions;
    
    // تعديل الثقة بناءً على أولوية القاعدة
    const priorityBonus = rule.priority / 10 * 0.1;
    
    return Math.min(1.0, baseConfidence + priorityBonus);
  }

  /**
   * التحقق من صحة القاعدة
   */
  validateRule(rule: Rule): { isValid: boolean; errors: string[] } {
    const errors: string[] = [];
    
    if (!rule.id || rule.id.trim() === '') {
      errors.push('Rule ID is required');
    }
    
    if (!rule.name || rule.name.trim() === '') {
      errors.push('Rule name is required');
    }
    
    if (!rule.conditions || rule.conditions.length === 0) {
      errors.push('Rule must have at least one condition');
    }
    
    if (!rule.actions || rule.actions.length === 0) {
      errors.push('Rule must have at least one action');
    }
    
    // التحقق من الشروط
    for (const condition of rule.conditions || []) {
      if (!condition.field) {
        errors.push(`Condition missing field`);
      }
      
      if (!Object.values(ConditionOperator).includes(condition.operator)) {
        errors.push(`Invalid operator: ${condition.operator}`);
      }
    }
    
    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * إضافة قاعدة جديدة
   */
  async addRule(rule: Rule): Promise<boolean> {
    const validation = this.validateRule(rule);
    
    if (!validation.isValid) {
      console.error('❌ Invalid rule:', validation.errors);
      return false;
    }
    
    this.rules.set(rule.id, rule);
    this.addToCategory(rule);
    
    console.log(`✅ Added rule: ${rule.name}`);
    this.emit('ruleAdded', rule);
    
    return true;
  }

  /**
   * تحديث قاعدة
   */
  async updateRule(ruleId: string, updates: Partial<Rule>): Promise<boolean> {
    const existingRule = this.rules.get(ruleId);
    
    if (!existingRule) {
      console.error(`❌ Rule not found: ${ruleId}`);
      return false;
    }
    
    const updatedRule = { ...existingRule, ...updates };
    const validation = this.validateRule(updatedRule);
    
    if (!validation.isValid) {
      console.error('❌ Invalid rule update:', validation.errors);
      return false;
    }
    
    this.rules.set(ruleId, updatedRule);
    this.updateCategory(existingRule, updatedRule);
    
    console.log(`✅ Updated rule: ${updatedRule.name}`);
    this.emit('ruleUpdated', updatedRule);
    
    return true;
  }

  /**
   * حذف قاعدة
   */
  async deleteRule(ruleId: string): Promise<boolean> {
    const rule = this.rules.get(ruleId);
    
    if (!rule) {
      console.error(`❌ Rule not found: ${ruleId}`);
      return false;
    }
    
    this.rules.delete(ruleId);
    this.removeFromCategory(rule);
    
    console.log(`✅ Deleted rule: ${rule.name}`);
    this.emit('ruleDeleted', rule);
    
    return true;
  }

  /**
   * الحصول على القواعد حسب الفئة
   */
  getRulesByCategory(category: RuleCategory): Rule[] {
    return this.rulesByCategory.get(category) || [];
  }

  /**
   * الحصول على جميع القواعد
   */
  getAllRules(): Rule[] {
    return Array.from(this.rules.values());
  }

  /**
   * الحصول على إحصائيات القواعد
   */
  getRuleStats(): {
    total: number;
    enabled: number;
    byCategory: Record<string, number>;
    byPriority: Record<string, number>;
  } {
    const rules = Array.from(this.rules.values());
    
    const stats = {
      total: rules.length,
      enabled: rules.filter(r => r.enabled).length,
      byCategory: {} as Record<string, number>,
      byPriority: {} as Record<string, number>
    };
    
    for (const rule of rules) {
      stats.byCategory[rule.category] = (stats.byCategory[rule.category] || 0) + 1;
      stats.byPriority[rule.priority.toString()] = (stats.byPriority[rule.priority.toString()] || 0) + 1;
    }
    
    return stats;
  }

  // Helper methods
  private initializeCategories(): void {
    for (const category of Object.values(RuleCategory)) {
      this.rulesByCategory.set(category, []);
    }
  }

  private parseRule(ruleData: any, category: RuleCategory): Rule {
    return {
      id: ruleData.id,
      name: ruleData.name,
      description: ruleData.description,
      category,
      conditions: ruleData.conditions || [],
      actions: ruleData.actions || [],
      decisionType: ruleData.decisionType || DecisionType.REFACTOR_CODE,
      priority: ruleData.priority || Priority.MEDIUM,
      enabled: ruleData.enabled !== false,
      rationale: ruleData.rationale,
      metadata: {
        author: <credential-fixture> || 'فريق وكلاء تطوير مشروع بصير',
        version: ruleData.version || '1.0.0',
        created: new Date(ruleData.created || Date.now()),
        updated: new Date(ruleData.updated || Date.now()),
        tags: ruleData.tags || [],
        documentation: ruleData.documentation
      }
    };
  }

  private addToCategory(rule: Rule): void {
    const categoryRules = this.rulesByCategory.get(rule.category) || [];
    categoryRules.push(rule);
    this.rulesByCategory.set(rule.category, categoryRules);
  }

  private updateCategory(oldRule: Rule, newRule: Rule): void {
    if (oldRule.category !== newRule.category) {
      this.removeFromCategory(oldRule);
      this.addToCategory(newRule);
    }
  }

  private removeFromCategory(rule: Rule): void {
    const categoryRules = this.rulesByCategory.get(rule.category) || [];
    const index = categoryRules.findIndex(r => r.id === rule.id);
    if (index >= 0) {
      categoryRules.splice(index, 1);
    }
  }

  private getFieldValue(data: any, field: string): any {
    const parts = field.split('.');
    let value = data;
    
    for (const part of parts) {
      if (value && typeof value === 'object') {
        value = value[part];
      } else {
        return undefined;
      }
    }
    
    return value;
  }

  private convertValue(value: any, type: string): any {
    switch (type) {
      case 'number':
        return Number(value);
      case 'string':
        return String(value);
      case 'boolean':
        return Boolean(value);
      case 'array':
        return Array.isArray(value) ? value : [value];
      default:
        return value;
    }
  }

  private customizeParameters(parameters: Record<string, any>, context: RuleEvaluationContext): Record<string, any> {
    const customized = { ...parameters };
    
    // استبدال المتغيرات في المعاملات
    for (const [key, value] of Object.entries(customized)) {
      if (typeof value === 'string' && value.includes('${')) {
        customized[key] = this.replaceVariables(value, context);
      }
    }
    
    return customized;
  }

  private replaceVariables(template: string, context: RuleEvaluationContext): string {
    return template.replace(/\$\{([^}]+)\}/g, (match, variable) => {
      const value = this.getFieldValue(context.data, variable);
      return value !== undefined ? String(value) : match;
    });
  }

  private getCacheKey(rule: Rule, context: RuleEvaluationContext): string {
    return `${rule.id}_${JSON.stringify(context.data)}_${context.timestamp.getTime()}`;
  }

  private generateActionId(): string {
    return `action_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }
}