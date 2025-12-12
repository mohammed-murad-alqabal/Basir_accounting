/**
 * L1 Analysis Layer - Main Controller
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 10 ديسمبر 2025
 */

import { promises as fs } from 'fs';
import * as path from 'path';
import { PatternAnalysis, PatternAnalyzer } from './analyzers/pattern-analyzer';
import { FlutterCollector, FlutterMetrics } from './collectors/flutter-collector';
import { WorkspaceCollector, WorkspaceMetrics } from './collectors/workspace-collector';
import { SystemAlert, SystemMetrics, SystemMonitor } from './monitors/system-monitor';
import { InsightReport, InsightsReporter } from './reporters/insights-reporter';

export interface L1AnalysisConfig {
  project: string;
  collectors: {
    workspace: boolean;
    flutter: boolean;
    system: boolean;
  };
  monitoring: {
    enabled: boolean;
    interval: number; // milliseconds
  };
  analysis: {
    patterns: boolean;
    insights: boolean;
  };
  output: {
    dataPath: string;
    reportsPath: string;
    htmlReports: boolean;
  };
}

export interface L1AnalysisResult {
  timestamp: Date;
  workspace?: WorkspaceMetrics;
  flutter?: FlutterMetrics;
  system?: SystemMetrics;
  patterns?: PatternAnalysis;
  insights?: InsightReport;
  alerts: SystemAlert[];
  summary: {
    dataCollected: number;
    patternsFound: number;
    insightsGenerated: number;
    alertsRaised: number;
  };
}

export class L1AnalysisLayer {
  private config: L1AnalysisConfig;
  private workspaceCollector: WorkspaceCollector;
  private flutterCollector: FlutterCollector;
  private systemMonitor: SystemMonitor;
  private patternAnalyzer: PatternAnalyzer;
  private insightsReporter: InsightsReporter;
  
  private isRunning = false;
  private analysisInterval?: NodeJS.Timeout;

  constructor(config: Partial<L1AnalysisConfig> = {}) {
    this.config = {
      project: 'بصير MVP',
      collectors: {
        workspace: true,
        flutter: true,
        system: true,
        ...config.collectors
      },
      monitoring: {
        enabled: true,
        interval: 300000, // 5 minutes
        ...config.monitoring
      },
      analysis: {
        patterns: true,
        insights: true,
        ...config.analysis
      },
      output: {
        dataPath: '.kiro/data',
        reportsPath: '.kiro/reports',
        htmlReports: true,
        ...config.output
      }
    };

    // تهيئة المكونات
    this.workspaceCollector = new WorkspaceCollector();
    this.flutterCollector = new FlutterCollector();
    this.systemMonitor = new SystemMonitor();
    this.patternAnalyzer = new PatternAnalyzer();
    this.insightsReporter = new InsightsReporter();
  }

  /**
   * بدء طبقة التحليل
   */
  async start(): Promise<void> {
    if (this.isRunning) {
      console.log('⚠️ L1 Analysis Layer is already running');
      return;
    }

    console.log('🚀 Starting L1 Analysis Layer...');
    
    try {
      // إنشاء المجلدات المطلوبة
      await this.ensureDirectories();
      
      // تحميل البيانات الموجودة
      await this.loadExistingData();
      
      // تشغيل التحليل الأولي
      await this.runAnalysis();
      
      // بدء المراقبة المستمرة إذا كانت مفعلة
      if (this.config.monitoring.enabled) {
        this.startContinuousMonitoring();
      }
      
      this.isRunning = true;
      console.log('✅ L1 Analysis Layer started successfully');
      
    } catch (error) {
      console.error('❌ Failed to start L1 Analysis Layer:', error);
      throw error;
    }
  }

  /**
   * إيقاف طبقة التحليل
   */
  async stop(): Promise<void> {
    if (!this.isRunning) {
      return;
    }

    console.log('🛑 Stopping L1 Analysis Layer...');
    
    // إيقاف المراقبة المستمرة
    if (this.analysisInterval) {
      clearInterval(this.analysisInterval);
      this.analysisInterval = undefined;
    }
    
    // إيقاف مراقبة النظام
    this.systemMonitor.stopMonitoring();
    
    // حفظ البيانات النهائية
    await this.saveCurrentState();
    
    this.isRunning = false;
    console.log('✅ L1 Analysis Layer stopped');
  }

  /**
   * تشغيل تحليل شامل
   */
  async runAnalysis(): Promise<L1AnalysisResult> {
    const timestamp = new Date();
    console.log('🔍 Running comprehensive analysis...');
    
    const result: L1AnalysisResult = {
      timestamp,
      alerts: [],
      summary: {
        dataCollected: 0,
        patternsFound: 0,
        insightsGenerated: 0,
        alertsRaised: 0
      }
    };

    try {
      // جمع البيانات من المصادر المختلفة
      const dataPromises: Promise<any>[] = [];
      
      if (this.config.collectors.workspace) {
        dataPromises.push(this.workspaceCollector.collectMetrics());
      }
      
      if (this.config.collectors.flutter) {
        dataPromises.push(this.flutterCollector.collectMetrics());
      }
      
      if (this.config.collectors.system) {
        dataPromises.push(this.systemMonitor.collectMetrics());
      }

      const [workspaceData, flutterData, systemData] = await Promise.all(dataPromises);
      
      // تخزين البيانات في النتيجة
      if (workspaceData) {
        result.workspace = workspaceData;
        result.summary.dataCollected++;
      }
      
      if (flutterData) {
        result.flutter = flutterData;
        result.summary.dataCollected++;
      }
      
      if (systemData) {
        result.system = systemData;
        result.summary.dataCollected++;
        
        // تحليل تنبيهات النظام
        const systemAlerts = await this.systemMonitor.analyzeMetrics(systemData);
        result.alerts.push(...systemAlerts);
        result.summary.alertsRaised += systemAlerts.length;
      }

      // تحليل الأنماط إذا كان مفعلاً
      if (this.config.analysis.patterns) {
        const allData = [workspaceData, flutterData, systemData].filter(Boolean);
        if (allData.length > 0) {
          result.patterns = await this.patternAnalyzer.analyzePatterns(allData, 'mixed');
          result.summary.patternsFound = result.patterns.totalPatterns;
        }
      }

      // إنتاج الرؤى إذا كان مفعلاً
      if (this.config.analysis.insights) {
        result.insights = await this.insightsReporter.generateReport(
          workspaceData ? [workspaceData] : undefined,
          flutterData ? [flutterData] : undefined,
          systemData ? [systemData] : undefined,
          result.patterns ? result.patterns.trendingPatterns : undefined
        );
        result.summary.insightsGenerated = result.insights.summary.totalInsights;
      }

      // حفظ النتائج
      await this.saveAnalysisResult(result);
      
      console.log(`✅ Analysis completed: ${result.summary.dataCollected} datasets, ${result.summary.patternsFound} patterns, ${result.summary.insightsGenerated} insights`);
      
      return result;
      
    } catch (error) {
      console.error('❌ Error during analysis:', error);
      throw error;
    }
  }

  /**
   * بدء المراقبة المستمرة
   */
  private startContinuousMonitoring(): void {
    console.log(`🔄 Starting continuous monitoring (interval: ${this.config.monitoring.interval}ms)`);
    
    this.analysisInterval = setInterval(async () => {
      try {
        await this.runAnalysis();
      } catch (error) {
        console.error('❌ Error in continuous monitoring:', error);
      }
    }, this.config.monitoring.interval);
  }

  /**
   * ضمان وجود المجلدات المطلوبة
   */
  private async ensureDirectories(): Promise<void> {
    const directories = [
      this.config.output.dataPath,
      this.config.output.reportsPath,
      path.join(this.config.output.dataPath, 'collectors'),
      path.join(this.config.output.dataPath, 'monitors'),
      path.join(this.config.output.dataPath, 'analyzers'),
      path.join(this.config.output.dataPath, 'reporters')
    ];

    for (const dir of directories) {
      await fs.mkdir(dir, { recursive: true });
    }
  }

  /**
   * تحميل البيانات الموجودة
   */
  private async loadExistingData(): Promise<void> {
    try {
      // تحميل الأنماط الموجودة
      await this.patternAnalyzer.loadPatterns();
      console.log('📂 Loaded existing patterns');
    } catch (error) {
      console.log('📂 No existing patterns found, starting fresh');
    }
  }

  /**
   * حفظ نتيجة التحليل
   */
  private async saveAnalysisResult(result: L1AnalysisResult): Promise<void> {
    const timestamp = result.timestamp.toISOString().replace(/[:.]/g, '-');
    
    // حفظ النتيجة الكاملة
    const resultPath = path.join(this.config.output.dataPath, `analysis-${timestamp}.json`);
    await fs.writeFile(resultPath, JSON.stringify(result, null, 2));
    
    // حفظ البيانات المنفصلة
    if (result.workspace) {
      await this.workspaceCollector.saveMetrics(result.workspace);
    }
    
    if (result.flutter) {
      await this.flutterCollector.saveMetrics(result.flutter);
    }
    
    if (result.system) {
      await this.systemMonitor.saveMetrics(result.system);
    }
    
    if (result.patterns) {
      await this.patternAnalyzer.saveAnalysis(result.patterns);
      await this.patternAnalyzer.savePatterns();
    }
    
    if (result.insights) {
      const reportsPath = path.join(this.config.output.reportsPath, `insights-${timestamp}.json`);
      await this.insightsReporter.saveReport(result.insights, reportsPath);
      
      // إنتاج تقرير HTML إذا كان مفعلاً
      if (this.config.output.htmlReports) {
        const htmlPath = path.join(this.config.output.reportsPath, `insights-${timestamp}.html`);
        await this.insightsReporter.generateHtmlReport(result.insights, htmlPath);
      }
    }
    
    // حفظ التنبيهات إذا وجدت
    if (result.alerts.length > 0) {
      await this.systemMonitor.saveAlerts(result.alerts);
    }
  }

  /**
   * حفظ الحالة الحالية
   */
  private async saveCurrentState(): Promise<void> {
    try {
      await this.patternAnalyzer.savePatterns();
      console.log('💾 Current state saved');
    } catch (error) {
      console.error('❌ Error saving current state:', error);
    }
  }

  /**
   * الحصول على تقرير الحالة
   */
  async getStatusReport(): Promise<{
    isRunning: boolean;
    config: L1AnalysisConfig;
    lastAnalysis?: Date;
    totalAnalyses: number;
    systemHealth: any;
  }> {
    // البحث عن آخر تحليل
    let lastAnalysis: Date | undefined;
    let totalAnalyses = 0;
    
    try {
      const files = await fs.readdir(this.config.output.dataPath);
      const analysisFiles = files.filter(f => f.startsWith('analysis-') && f.endsWith('.json'));
      totalAnalyses = analysisFiles.length;
      
      if (analysisFiles.length > 0) {
        const latestFile = analysisFiles.sort().pop()!;
        const content = await fs.readFile(path.join(this.config.output.dataPath, latestFile), 'utf-8');
        const data = JSON.parse(content);
        lastAnalysis = new Date(data.timestamp);
      }
    } catch (error) {
      // تجاهل الأخطاء
    }
    
    // الحصول على تقرير صحة النظام
    const systemHealth = await this.systemMonitor.getHealthReport();
    
    return {
      isRunning: this.isRunning,
      config: this.config,
      lastAnalysis,
      totalAnalyses,
      systemHealth
    };
  }

  /**
   * تحديث التكوين
   */
  updateConfig(newConfig: Partial<L1AnalysisConfig>): void {
    this.config = { ...this.config, ...newConfig };
    console.log('⚙️ Configuration updated');
  }
}

// مثال على الاستخدام
if (require.main === module) {
  const analysisLayer = new L1AnalysisLayer({
    monitoring: {
      enabled: false, // تعطيل المراقبة المستمرة للاختبار
      interval: 60000 // دقيقة واحدة
    },
    output: {
      htmlReports: true
    }
  });

  // تشغيل تحليل واحد
  analysisLayer.start()
    .then(() => analysisLayer.runAnalysis())
    .then(result => {
      console.log('📊 Analysis Result Summary:', result.summary);
      return analysisLayer.getStatusReport();
    })
    .then(status => {
      console.log('📋 Status Report:', status);
      return analysisLayer.stop();
    })
    .catch(error => {
      console.error('❌ Error:', error);
      analysisLayer.stop();
    });
}