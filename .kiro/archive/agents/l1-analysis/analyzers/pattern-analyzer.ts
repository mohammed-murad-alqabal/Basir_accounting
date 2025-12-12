/**
 * Pattern Analyzer - L1 Analysis Layer
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 10 ديسمبر 2025
 */

import { promises as fs } from 'fs';
import * as path from 'path';

export interface Pattern {
  id: string;
  name: string;
  description: string;
  frequency: number;
  confidence: number;
  firstSeen: Date;
  lastSeen: Date;
  examples: string[];
  metadata: Record<string, any>;
}

export interface PatternAnalysis {
  timestamp: Date;
  totalPatterns: number;
  newPatterns: Pattern[];
  trendingPatterns: Pattern[];
  anomalies: Pattern[];
  insights: string[];
  recommendations: string[];
}

export interface TimeSeriesData {
  timestamp: Date;
  value: number;
  metadata?: Record<string, any>;
}

export class PatternAnalyzer {
  private patterns: Map<string, Pattern> = new Map();
  private timeSeriesData: Map<string, TimeSeriesData[]> = new Map();
  private minConfidence = 0.7;
  private minFrequency = 3;

  /**
   * تحليل الأنماط في البيانات
   */
  async analyzePatterns(data: any[], dataType: string): Promise<PatternAnalysis> {
    const timestamp = new Date();
    const existingPatternCount = this.patterns.size;
    
    // تحليل أنماط مختلفة حسب نوع البيانات
    switch (dataType) {
      case 'workspace':
        await this.analyzeWorkspacePatterns(data);
        break;
      case 'flutter':
        await this.analyzeFlutterPatterns(data);
        break;
      case 'system':
        await this.analyzeSystemPatterns(data);
        break;
      case 'git':
        await this.analyzeGitPatterns(data);
        break;
      default:
        await this.analyzeGenericPatterns(data);
    }

    // تحديد الأنماط الجديدة والشائعة
    const newPatterns = Array.from(this.patterns.values())
      .filter(p => p.firstSeen >= new Date(Date.now() - 24 * 60 * 60 * 1000));
    
    const trendingPatterns = Array.from(this.patterns.values())
      .filter(p => p.frequency >= this.minFrequency && p.confidence >= this.minConfidence)
      .sort((a, b) => b.frequency - a.frequency)
      .slice(0, 10);

    // كشف الشذوذ
    const anomalies = await this.detectAnomalies();

    // إنتاج الرؤى والتوصيات
    const insights = this.generateInsights(trendingPatterns, anomalies);
    const recommendations = this.generateRecommendations(trendingPatterns, anomalies);

    return {
      timestamp,
      totalPatterns: this.patterns.size,
      newPatterns,
      trendingPatterns,
      anomalies,
      insights,
      recommendations
    };
  }

  /**
   * تحليل أنماط workspace
   */
  private async analyzeWorkspacePatterns(data: any[]): Promise<void> {
    for (const item of data) {
      // نمط نمو الملفات
      if (item.structure) {
        await this.recordPattern(
          'file-growth',
          'نمو عدد الملفات',
          'تتبع نمو عدد الملفات في المشروع',
          item.structure.totalFiles,
          { dartFiles: item.structure.dartFiles, testFiles: item.structure.testFiles }
        );
      }

      // نمط جودة الكود
      if (item.quality) {
        await this.recordPattern(
          'code-quality',
          'جودة الكود',
          'تتبع مؤشرات جودة الكود',
          item.quality.codeQualityScore,
          { testCoverage: item.quality.testCoverage, technicalDebt: item.quality.technicalDebt }
        );
      }

      // نمط التبعيات
      if (item.dependencies) {
        await this.recordPattern(
          'dependencies',
          'إدارة التبعيات',
          'تتبع عدد وحالة التبعيات',
          item.dependencies.totalDependencies,
          { outdated: item.dependencies.outdatedDependencies, vulnerabilities: item.dependencies.vulnerabilities }
        );
      }
    }
  }

  /**
   * تحليل أنماط Flutter
   */
  private async analyzeFlutterPatterns(data: any[]): Promise<void> {
    for (const item of data) {
      // نمط استخدام الويدجت
      if (item.widgets) {
        await this.recordPattern(
          'widget-usage',
          'استخدام الويدجت',
          'تتبع أنماط استخدام الويدجت في Flutter',
          item.widgets.totalWidgets,
          { 
            stateful: item.widgets.statefulWidgets, 
            stateless: item.widgets.statelessWidgets,
            ratio: item.widgets.statefulWidgets / (item.widgets.totalWidgets || 1)
          }
        );
      }

      // نمط إدارة الحالة
      if (item.stateManagement) {
        await this.recordPattern(
          'state-management',
          'إدارة الحالة',
          'تتبع استخدام Riverpod وإدارة الحالة',
          item.stateManagement.riverpodProviders,
          { 
            providers: item.stateManagement.riverpodProviders,
            consumers: item.stateManagement.consumerWidgets,
            notifiers: item.stateManagement.stateNotifiers
          }
        );
      }

      // نمط قاعدة البيانات
      if (item.database) {
        await this.recordPattern(
          'database-usage',
          'استخدام قاعدة البيانات',
          'تتبع استخدام Isar وقاعدة البيانات',
          item.database.collections,
          { 
            schemas: item.database.isarSchemas,
            queries: item.database.queries,
            indexes: item.database.indexes
          }
        );
      }

      // نمط الأداء
      if (item.performance) {
        await this.recordPattern(
          'performance-issues',
          'مشاكل الأداء',
          'تتبع مشاكل الأداء المحتملة',
          item.performance.expensiveOperations,
          { 
            builds: item.performance.buildMethods,
            memoryLeaks: item.performance.memoryLeaks,
            renders: item.performance.renderIssues
          }
        );
      }
    }
  }

  /**
   * تحليل أنماط النظام
   */
  private async analyzeSystemPatterns(data: any[]): Promise<void> {
    for (const item of data) {
      // نمط استخدام المعالج
      if (item.cpu) {
        await this.recordPattern(
          'cpu-usage',
          'استخدام المعالج',
          'تتبع أنماط استخدام المعالج',
          item.cpu.usage,
          { cores: item.cpu.cores, temperature: item.cpu.temperature }
        );
      }

      // نمط استخدام الذاكرة
      if (item.memory) {
        await this.recordPattern(
          'memory-usage',
          'استخدام الذاكرة',
          'تتبع أنماط استخدام الذاكرة',
          item.memory.usagePercent,
          { total: item.memory.total, swap: item.memory.swapUsed }
        );
      }

      // نمط حمولة النظام
      if (item.system && item.system.loadAverage) {
        await this.recordPattern(
          'system-load',
          'حمولة النظام',
          'تتبع حمولة النظام',
          item.system.loadAverage[0],
          { 
            load1: item.system.loadAverage[0],
            load5: item.system.loadAverage[1],
            load15: item.system.loadAverage[2]
          }
        );
      }
    }
  }

  /**
   * تحليل أنماط Git
   */
  private async analyzeGitPatterns(data: any[]): Promise<void> {
    for (const item of data) {
      // نمط الكوميت
      if (item.commits) {
        await this.recordPattern(
          'commit-frequency',
          'تكرار الكوميت',
          'تتبع تكرار الكوميت',
          item.commits.length,
          { authors: <credential-fixture>?.length || 0 }
        );
      }

      // نمط الفروع
      if (item.branches) {
        await this.recordPattern(
          'branch-usage',
          'استخدام الفروع',
          'تتبع استخدام الفروع',
          item.branches.length,
          { active: item.activeBranches || 0 }
        );
      }
    }
  }

  /**
   * تحليل أنماط عامة
   */
  private async analyzeGenericPatterns(data: any[]): Promise<void> {
    // تحليل أنماط عامة للبيانات غير المصنفة
    const values = data.map(item => typeof item === 'number' ? item : Object.keys(item).length);
    
    if (values.length > 0) {
      const avg = values.reduce((a, b) => a + b, 0) / values.length;
      const variance = values.reduce((acc, val) => acc + Math.pow(val - avg, 2), 0) / values.length;
      
      await this.recordPattern(
        'generic-trend',
        'اتجاه عام',
        'تحليل الاتجاه العام للبيانات',
        avg,
        { variance, count: values.length, min: Math.min(...values), max: Math.max(...values) }
      );
    }
  }

  /**
   * تسجيل نمط
   */
  private async recordPattern(
    id: string,
    name: string,
    description: string,
    value: number,
    metadata: Record<string, any> = {}
  ): Promise<void> {
    const now = new Date();
    
    // إضافة البيانات الزمنية
    if (!this.timeSeriesData.has(id)) {
      this.timeSeriesData.set(id, []);
    }
    
    const timeSeries = this.timeSeriesData.get(id)!;
    timeSeries.push({ timestamp: now, value, metadata });
    
    // الاحتفاظ بآخر 1000 نقطة فقط
    if (timeSeries.length > 1000) {
      timeSeries.splice(0, timeSeries.length - 1000);
    }

    // تحديث أو إنشاء النمط
    if (this.patterns.has(id)) {
      const pattern = this.patterns.get(id)!;
      pattern.frequency++;
      pattern.lastSeen = now;
      pattern.confidence = this.calculateConfidence(timeSeries);
      pattern.metadata = { ...pattern.metadata, ...metadata };
      
      // إضافة مثال جديد
      if (pattern.examples.length < 5) {
        pattern.examples.push(JSON.stringify({ value, metadata, timestamp: now }));
      }
    } else {
      const pattern: Pattern = {
        id,
        name,
        description,
        frequency: 1,
        confidence: 0.5,
        firstSeen: now,
        lastSeen: now,
        examples: [JSON.stringify({ value, metadata, timestamp: now })],
        metadata
      };
      
      this.patterns.set(id, pattern);
    }
  }

  /**
   * حساب الثقة في النمط
   */
  private calculateConfidence(timeSeries: TimeSeriesData[]): number {
    if (timeSeries.length < 3) return 0.3;
    
    // حساب الاستقرار في البيانات
    const values = timeSeries.slice(-10).map(d => d.value);
    const mean = values.reduce((a, b) => a + b, 0) / values.length;
    const variance = values.reduce((acc, val) => acc + Math.pow(val - mean, 2), 0) / values.length;
    const stability = 1 / (1 + variance);
    
    // حساب الاتساق الزمني
    const timeConsistency = Math.min(1, timeSeries.length / 10);
    
    return Math.min(0.95, (stability * 0.7 + timeConsistency * 0.3));
  }

  /**
   * كشف الشذوذ
   */
  private async detectAnomalies(): Promise<Pattern[]> {
    const anomalies: Pattern[] = [];
    
    for (const [id, pattern] of this.patterns) {
      const timeSeries = this.timeSeriesData.get(id);
      if (!timeSeries || timeSeries.length < 10) continue;
      
      // كشف الشذوذ الإحصائي
      const recentValues = timeSeries.slice(-20).map(d => d.value);
      const mean = recentValues.reduce((a, b) => a + b, 0) / recentValues.length;
      const stdDev = Math.sqrt(
        recentValues.reduce((acc, val) => acc + Math.pow(val - mean, 2), 0) / recentValues.length
      );
      
      const latestValue = recentValues[recentValues.length - 1];
      const zScore = Math.abs((latestValue - mean) / stdDev);
      
      // إذا كان Z-score > 2، فهو شذوذ
      if (zScore > 2) {
        anomalies.push({
          ...pattern,
          id: `${id}-anomaly`,
          name: `شذوذ في ${pattern.name}`,
          description: `قيمة غير طبيعية في ${pattern.description}`,
          metadata: {
            ...pattern.metadata,
            zScore,
            expectedValue: mean,
            actualValue: latestValue,
            deviation: Math.abs(latestValue - mean)
          }
        });
      }
    }
    
    return anomalies;
  }

  /**
   * إنتاج الرؤى
   */
  private generateInsights(trendingPatterns: Pattern[], anomalies: Pattern[]): string[] {
    const insights: string[] = [];
    
    // رؤى من الأنماط الشائعة
    for (const pattern of trendingPatterns.slice(0, 5)) {
      if (pattern.confidence > 0.8) {
        insights.push(`نمط مستقر: ${pattern.name} يظهر اتساقاً عالياً (${Math.round(pattern.confidence * 100)}%)`);
      }
      
      if (pattern.frequency > 10) {
        insights.push(`نمط متكرر: ${pattern.name} يحدث بانتظام (${pattern.frequency} مرة)`);
      }
    }
    
    // رؤى من الشذوذ
    for (const anomaly of anomalies.slice(0, 3)) {
      insights.push(`شذوذ مكتشف: ${anomaly.name} - قيمة غير متوقعة`);
    }
    
    // رؤى عامة
    if (trendingPatterns.length > 20) {
      insights.push('النظام يظهر أنماطاً متعددة ومعقدة، مما يشير إلى نشاط مكثف');
    }
    
    if (anomalies.length > 5) {
      insights.push('عدد كبير من الشذوذ مكتشف، قد يتطلب مراجعة شاملة');
    }
    
    return insights;
  }

  /**
   * إنتاج التوصيات
   */
  private generateRecommendations(trendingPatterns: Pattern[], anomalies: Pattern[]): string[] {
    const recommendations: string[] = [];
    
    // توصيات بناءً على الأنماط
    const lowConfidencePatterns = trendingPatterns.filter(p => p.confidence < 0.6);
    if (lowConfidencePatterns.length > 0) {
      recommendations.push('مراجعة الأنماط ذات الثقة المنخفضة لتحسين الاستقرار');
    }
    
    // توصيات بناءً على الشذوذ
    if (anomalies.length > 0) {
      recommendations.push('التحقق من الشذوذ المكتشف وتحديد أسبابه');
    }
    
    // توصيات خاصة بـ Flutter
    const flutterPatterns = trendingPatterns.filter(p => p.id.includes('widget') || p.id.includes('state'));
    if (flutterPatterns.length > 0) {
      recommendations.push('مراجعة أنماط استخدام Flutter لتحسين الأداء');
    }
    
    // توصيات عامة
    if (trendingPatterns.length < 5) {
      recommendations.push('زيادة جمع البيانات لتحسين تحليل الأنماط');
    }
    
    return recommendations;
  }

  /**
   * الحصول على تقرير الأنماط
   */
  async getPatternReport(): Promise<{
    summary: {
      totalPatterns: number;
      highConfidencePatterns: number;
      recentPatterns: number;
      anomaliesDetected: number;
    };
    topPatterns: Pattern[];
    recentAnomalies: Pattern[];
    trends: {
      increasing: string[];
      decreasing: string[];
      stable: string[];
    };
  }> {
    const allPatterns = Array.from(this.patterns.values());
    const highConfidencePatterns = allPatterns.filter(p => p.confidence > 0.8);
    const recentPatterns = allPatterns.filter(p => 
      p.lastSeen >= new Date(Date.now() - 24 * 60 * 60 * 1000)
    );
    
    const anomalies = await this.detectAnomalies();
    const topPatterns = allPatterns
      .sort((a, b) => (b.confidence * b.frequency) - (a.confidence * a.frequency))
      .slice(0, 10);
    
    // تحليل الاتجاهات
    const trends = { increasing: [], decreasing: [], stable: [] };
    
    for (const pattern of allPatterns) {
      const timeSeries = this.timeSeriesData.get(pattern.id);
      if (timeSeries && timeSeries.length >= 5) {
        const recent = timeSeries.slice(-5).map(d => d.value);
        const older = timeSeries.slice(-10, -5).map(d => d.value);
        
        if (recent.length > 0 && older.length > 0) {
          const recentAvg = recent.reduce((a, b) => a + b, 0) / recent.length;
          const olderAvg = older.reduce((a, b) => a + b, 0) / older.length;
          
          const change = (recentAvg - olderAvg) / olderAvg;
          
          if (change > 0.1) {
            (trends.increasing as string[]).push(pattern.name);
          } else if (change < -0.1) {
            (trends.decreasing as string[]).push(pattern.name);
          } else {
            (trends.stable as string[]).push(pattern.name);
          }
        }
      }
    }
    
    return {
      summary: {
        totalPatterns: allPatterns.length,
        highConfidencePatterns: highConfidencePatterns.length,
        recentPatterns: recentPatterns.length,
        anomaliesDetected: anomalies.length
      },
      topPatterns,
      recentAnomalies: anomalies.slice(0, 5),
      trends
    };
  }

  /**
   * حفظ تحليل الأنماط
   */
  async saveAnalysis(analysis: PatternAnalysis, outputPath: string = '.kiro/data/pattern-analysis.json'): Promise<void> {
    const dir = path.dirname(outputPath);
    await fs.mkdir(dir, { recursive: true });
    
    // قراءة التحليلات الموجودة
    let existingData: PatternAnalysis[] = [];
    try {
      const existing = await fs.readFile(outputPath, 'utf-8');
      existingData = JSON.parse(existing);
    } catch {
      // الملف غير موجود
    }
    
    // إضافة التحليل الجديد
    existingData.push(analysis);
    
    // الاحتفاظ بآخر 100 تحليل فقط
    if (existingData.length > 100) {
      existingData = existingData.slice(-100);
    }
    
    await fs.writeFile(outputPath, JSON.stringify(existingData, null, 2));
  }

  /**
   * حفظ الأنماط
   */
  async savePatterns(outputPath: string = '.kiro/data/patterns.json'): Promise<void> {
    const dir = path.dirname(outputPath);
    await fs.mkdir(dir, { recursive: true });
    
    const patternsData = {
      patterns: Array.from(this.patterns.entries()),
      timeSeries: Array.from(this.timeSeriesData.entries()),
      lastUpdated: new Date()
    };
    
    await fs.writeFile(outputPath, JSON.stringify(patternsData, null, 2));
  }

  /**
   * تحميل الأنماط
   */
  async loadPatterns(inputPath: string = '.kiro/data/patterns.json'): Promise<void> {
    try {
      const data = await fs.readFile(inputPath, 'utf-8');
      const patternsData = JSON.parse(data);
      
      this.patterns = new Map(patternsData.patterns);
      this.timeSeriesData = new Map(patternsData.timeSeries);
    } catch {
      // الملف غير موجود أو تالف، البدء بأنماط فارغة
    }
  }
}

// مثال على الاستخدام
if (require.main === module) {
  const analyzer = new PatternAnalyzer();
  
  // تحميل الأنماط الموجودة
  analyzer.loadPatterns()
    .then(() => {
      // بيانات تجريبية
      const testData = [
        { structure: { totalFiles: 150, dartFiles: 120 }, quality: { codeQualityScore: 85 } },
        { structure: { totalFiles: 155, dartFiles: 125 }, quality: { codeQualityScore: 87 } },
        { structure: { totalFiles: 160, dartFiles: 130 }, quality: { codeQualityScore: 86 } }
      ];
      
      return analyzer.analyzePatterns(testData, 'workspace');
    })
    .then(analysis => {
      console.log('🔍 Pattern Analysis:', analysis);
      return analyzer.saveAnalysis(analysis);
    })
    .then(() => analyzer.getPatternReport())
    .then(report => {
      console.log('📊 Pattern Report:', report);
      return analyzer.savePatterns();
    })
    .then(() => console.log('✅ Pattern analysis completed'))
    .catch(error => console.error('❌ Error in pattern analysis:', error));
}