/**
 * Flutter/Dart Specific Data Collector - L1 Analysis Layer
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 10 ديسمبر 2025
 */

import { promises as fs } from 'fs';
import { glob } from 'glob';
import * as path from 'path';

export interface FlutterMetrics {
  timestamp: Date;
  project: string;
  flutter: {
    version: string;
    dartVersion: string;
    channel: string;
    framework: string;
  };
  widgets: {
    totalWidgets: number;
    statefulWidgets: number;
    statelessWidgets: number;
    customWidgets: number;
  };
  stateManagement: {
    riverpodProviders: number;
    stateNotifiers: number;
    consumerWidgets: number;
    hooks: number;
  };
  database: {
    isarSchemas: number;
    collections: number;
    queries: number;
    indexes: number;
  };
  performance: {
    buildMethods: number;
    expensiveOperations: number;
    memoryLeaks: number;
    renderIssues: number;
  };
  testing: {
    unitTests: number;
    widgetTests: number;
    integrationTests: number;
    mockObjects: number;
  };
  architecture: {
    layers: number;
    features: number;
    repositories: number;
    services: number;
  };
}

export class FlutterCollector {
  private projectRoot: string;
  private libPath: string;
  private testPath: string;

  constructor(projectRoot: string = '.') {
    this.projectRoot = projectRoot;
    this.libPath = path.join(projectRoot, 'lib');
    this.testPath = path.join(projectRoot, 'test');
  }

  /**
   * جمع جميع مقاييس Flutter/Dart
   */
  async collectMetrics(): Promise<FlutterMetrics> {
    const timestamp = new Date();
    
    const [flutter, widgets, stateManagement, database, performance, testing, architecture] = await Promise.all([
      this.collectFlutterInfo(),
      this.collectWidgetMetrics(),
      this.collectStateManagementMetrics(),
      this.collectDatabaseMetrics(),
      this.collectPerformanceMetrics(),
      this.collectTestingMetrics(),
      this.collectArchitectureMetrics()
    ]);

    return {
      timestamp,
      project: 'بصير MVP',
      flutter,
      widgets,
      stateManagement,
      database,
      performance,
      testing,
      architecture
    };
  }

  /**
   * جمع معلومات Flutter الأساسية
   */
  private async collectFlutterInfo() {
    try {
      const pubspecPath = path.join(this.projectRoot, 'pubspec.yaml');
      const pubspecContent = await fs.readFile(pubspecPath, 'utf-8');
      
      // استخراج معلومات Flutter من pubspec.yaml
      const flutterMatch = pubspecContent.match(/flutter:\s*"([^"]+)"/);
      const dartMatch = pubspecContent.match(/sdk:\s*"([^"]+)"/);
      
      return {
        version: flutterMatch ? flutterMatch[1] : 'unknown',
        dartVersion: dartMatch ? dartMatch[1] : 'unknown',
        channel: 'stable', // افتراضي
        framework: 'Flutter'
      };
    } catch (error) {
      return {
        version: 'unknown',
        dartVersion: 'unknown',
        channel: 'unknown',
        framework: 'Flutter'
      };
    }
  }

  /**
   * جمع مقاييس الويدجت
   */
  private async collectWidgetMetrics() {
    const dartFiles = await this.getDartFiles();
    
    let totalWidgets = 0;
    let statefulWidgets = 0;
    let statelessWidgets = 0;
    let customWidgets = 0;

    for (const file of dartFiles) {
      const content = await fs.readFile(file, 'utf-8');
      
      // عد الويدجت
      const statefulMatches = content.match(/class\s+\w+\s+extends\s+StatefulWidget/g);
      const statelessMatches = content.match(/class\s+\w+\s+extends\s+StatelessWidget/g);
      const customMatches = content.match(/class\s+\w+\s+extends\s+\w*Widget/g);
      
      if (statefulMatches) {
        statefulWidgets += statefulMatches.length;
        totalWidgets += statefulMatches.length;
      }
      
      if (statelessMatches) {
        statelessWidgets += statelessMatches.length;
        totalWidgets += statelessMatches.length;
      }
      
      if (customMatches) {
        customWidgets += customMatches.length;
      }
    }

    return {
      totalWidgets,
      statefulWidgets,
      statelessWidgets,
      customWidgets
    };
  }

  /**
   * جمع مقاييس إدارة الحالة (Riverpod)
   */
  private async collectStateManagementMetrics() {
    const dartFiles = await this.getDartFiles();
    
    let riverpodProviders = 0;
    let stateNotifiers = 0;
    let consumerWidgets = 0;
    let hooks = 0;

    for (const file of dartFiles) {
      const content = await fs.readFile(file, 'utf-8');
      
      // عد مكونات Riverpod
      const providerMatches = content.match(/Provider\s*\(/g);
      const stateNotifierMatches = content.match(/StateNotifier\s*</g);
      const consumerMatches = content.match(/ConsumerWidget|Consumer\s*\(/g);
      const hookMatches = content.match(/use\w+\s*\(/g);
      
      if (providerMatches) riverpodProviders += providerMatches.length;
      if (stateNotifierMatches) stateNotifiers += stateNotifierMatches.length;
      if (consumerMatches) consumerWidgets += consumerMatches.length;
      if (hookMatches) hooks += hookMatches.length;
    }

    return {
      riverpodProviders,
      stateNotifiers,
      consumerWidgets,
      hooks
    };
  }

  /**
   * جمع مقاييس قاعدة البيانات (Isar)
   */
  private async collectDatabaseMetrics() {
    const dartFiles = await this.getDartFiles();
    
    let isarSchemas = 0;
    let collections = 0;
    let queries = 0;
    let indexes = 0;

    for (const file of dartFiles) {
      const content = await fs.readFile(file, 'utf-8');
      
      // عد مكونات Isar
      const schemaMatches = content.match(/@collection/gi);
      const collectionMatches = content.match(/IsarCollection\s*</g);
      const queryMatches = content.match(/\.where\(\)|\.filter\(\)|\.findAll\(\)/g);
      const indexMatches = content.match(/@Index\s*\(/g);
      
      if (schemaMatches) isarSchemas += schemaMatches.length;
      if (collectionMatches) collections += collectionMatches.length;
      if (queryMatches) queries += queryMatches.length;
      if (indexMatches) indexes += indexMatches.length;
    }

    return {
      isarSchemas,
      collections,
      queries,
      indexes
    };
  }

  /**
   * جمع مقاييس الأداء
   */
  private async collectPerformanceMetrics() {
    const dartFiles = await this.getDartFiles();
    
    let buildMethods = 0;
    let expensiveOperations = 0;
    let memoryLeaks = 0;
    let renderIssues = 0;

    for (const file of dartFiles) {
      const content = await fs.readFile(file, 'utf-8');
      
      // عد مشاكل الأداء المحتملة
      const buildMatches = content.match(/Widget\s+build\s*\(/g);
      const expensiveMatches = content.match(/for\s*\(.*\)\s*{|while\s*\(.*\)\s*{/g);
      const memoryMatches = content.match(/StreamController|Timer\./g);
      const renderMatches = content.match(/setState\s*\(|notifyListeners\s*\(/g);
      
      if (buildMatches) buildMethods += buildMatches.length;
      if (expensiveMatches) expensiveOperations += expensiveMatches.length;
      if (memoryMatches) memoryLeaks += memoryMatches.length;
      if (renderMatches) renderIssues += renderMatches.length;
    }

    return {
      buildMethods,
      expensiveOperations,
      memoryLeaks,
      renderIssues
    };
  }

  /**
   * جمع مقاييس الاختبارات
   */
  private async collectTestingMetrics() {
    const testFiles = await this.getTestFiles();
    
    let unitTests = 0;
    let widgetTests = 0;
    let integrationTests = 0;
    let mockObjects = 0;

    for (const file of testFiles) {
      const content = await fs.readFile(file, 'utf-8');
      
      // عد أنواع الاختبارات
      const unitMatches = content.match(/test\s*\(/g);
      const widgetMatches = content.match(/testWidgets\s*\(/g);
      const integrationMatches = content.match(/integration_test/g);
      const mockMatches = content.match(/Mock\w+|when\s*\(/g);
      
      if (unitMatches) unitTests += unitMatches.length;
      if (widgetMatches) widgetTests += widgetMatches.length;
      if (integrationMatches) integrationTests += integrationMatches.length;
      if (mockMatches) mockObjects += mockMatches.length;
    }

    return {
      unitTests,
      widgetTests,
      integrationTests,
      mockObjects
    };
  }

  /**
   * جمع مقاييس المعمارية
   */
  private async collectArchitectureMetrics() {
    const dartFiles = await this.getDartFiles();
    
    let layers = 0;
    let features = 0;
    let repositories = 0;
    let services = 0;

    // تحليل بنية المجلدات
    const directories = await this.getDirectories();
    
    layers = directories.filter(dir => 
      dir.includes('presentation') || 
      dir.includes('domain') || 
      dir.includes('data')
    ).length;
    
    features = directories.filter(dir => 
      dir.includes('features') || 
      dir.includes('modules')
    ).length;

    // تحليل الملفات
    for (const file of dartFiles) {
      const content = await fs.readFile(file, 'utf-8');
      
      const repositoryMatches = content.match(/class\s+\w*Repository/g);
      const serviceMatches = content.match(/class\s+\w*Service/g);
      
      if (repositoryMatches) repositories += repositoryMatches.length;
      if (serviceMatches) services += serviceMatches.length;
    }

    return {
      layers,
      features,
      repositories,
      services
    };
  }

  /**
   * الحصول على ملفات Dart
   */
  private async getDartFiles(): Promise<string[]> {
    const files = await glob('**/*.dart', {
      cwd: this.libPath,
      ignore: ['**/*.g.dart', '**/*.freezed.dart']
    });
    
    return files.map(file => path.join(this.libPath, file));
  }

  /**
   * الحصول على ملفات الاختبارات
   */
  private async getTestFiles(): Promise<string[]> {
    try {
      const files = await glob('**/*.dart', {
        cwd: this.testPath
      });
      
      return files.map(file => path.join(this.testPath, file));
    } catch {
      return [];
    }
  }

  /**
   * الحصول على المجلدات
   */
  private async getDirectories(): Promise<string[]> {
    try {
      const entries = await fs.readdir(this.libPath, { withFileTypes: true });
      return entries
        .filter(entry => entry.isDirectory())
        .map(entry => entry.name);
    } catch {
      return [];
    }
  }

  /**
   * حفظ المقاييس في ملف
   */
  async saveMetrics(metrics: FlutterMetrics, outputPath: string = '.kiro/data/flutter-metrics.json'): Promise<void> {
    const dir = path.dirname(outputPath);
    await fs.mkdir(dir, { recursive: true });
    
    // قراءة البيانات الموجودة
    let existingData: FlutterMetrics[] = [];
    try {
      const existing = await fs.readFile(outputPath, 'utf-8');
      existingData = JSON.parse(existing);
    } catch {
      // الملف غير موجود، سنبدأ بمصفوفة فارغة
    }
    
    // إضافة المقاييس الجديدة
    existingData.push(metrics);
    
    // الاحتفاظ بآخر 100 قياس فقط
    if (existingData.length > 100) {
      existingData = existingData.slice(-100);
    }
    
    await fs.writeFile(outputPath, JSON.stringify(existingData, null, 2));
  }

  /**
   * تحليل جودة كود Flutter
   */
  async analyzeFlutterQuality(): Promise<{
    score: number;
    issues: string[];
    recommendations: string[];
  }> {
    const metrics = await this.collectMetrics();
    const issues: string[] = [];
    const recommendations: string[] = [];
    let score = 100;

    // تحليل نسبة الاختبارات
    const testRatio = metrics.testing.unitTests / (metrics.widgets.totalWidgets || 1);
    if (testRatio < 0.7) {
      score -= 20;
      issues.push('تغطية اختبارات منخفضة');
      recommendations.push('زيادة عدد اختبارات الوحدة');
    }

    // تحليل استخدام Riverpod
    if (metrics.stateManagement.riverpodProviders === 0) {
      score -= 15;
      issues.push('عدم استخدام Riverpod لإدارة الحالة');
      recommendations.push('تطبيق Riverpod لإدارة الحالة');
    }

    // تحليل مشاكل الأداء
    if (metrics.performance.expensiveOperations > 10) {
      score -= 10;
      issues.push('عمليات مكلفة كثيرة');
      recommendations.push('تحسين العمليات المكلفة');
    }

    // تحليل المعمارية
    if (metrics.architecture.layers < 3) {
      score -= 15;
      issues.push('معمارية غير مكتملة');
      recommendations.push('تطبيق Clean Architecture');
    }

    return {
      score: Math.max(0, score),
      issues,
      recommendations
    };
  }
}

// مثال على الاستخدام
if (require.main === module) {
  const collector = new FlutterCollector();
  
  collector.collectMetrics()
    .then(metrics => {
      console.log('📱 Flutter Metrics:', metrics);
      return collector.saveMetrics(metrics);
    })
    .then(() => collector.analyzeFlutterQuality())
    .then(quality => {
      console.log('🎯 Flutter Quality Analysis:', quality);
    })
    .catch(error => console.error('❌ Error collecting Flutter metrics:', error));
}