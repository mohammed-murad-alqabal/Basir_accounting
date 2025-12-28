/**
 * Workspace Data Collector - L1 Analysis Layer
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 10 ديسمبر 2025
 */

import { promises as fs } from 'fs';
import { glob } from 'glob';
import * as path from 'path';

export interface WorkspaceMetrics {
  timestamp: Date;
  project: string;
  structure: {
    totalFiles: number;
    dartFiles: number;
    testFiles: number;
    assetFiles: number;
    configFiles: number;
  };
  codebase: {
    linesOfCode: number;
    linesOfComments: number;
    linesOfTests: number;
    complexity: number;
  };
  dependencies: {
    totalDependencies: number;
    devDependencies: number;
    outdatedDependencies: number;
    vulnerabilities: number;
  };
  quality: {
    testCoverage: number;
    codeQualityScore: number;
    maintainabilityIndex: number;
    technicalDebt: number;
  };
}

export class WorkspaceCollector {
  private projectRoot: string;
  private excludePatterns: string[];

  constructor(projectRoot: string = '.') {
    this.projectRoot = projectRoot;
    this.excludePatterns = [
      'node_modules/**',
      '.git/**',
      'build/**',
      '.dart_tool/**',
      'coverage/**',
      '**/*.g.dart',
      '**/*.freezed.dart'
    ];
  }

  /**
   * جمع جميع مقاييس workspace
   */
  async collectMetrics(): Promise<WorkspaceMetrics> {
    const timestamp = new Date();
    
    const [structure, codebase, dependencies, quality] = await Promise.all([
      this.collectStructureMetrics(),
      this.collectCodebaseMetrics(),
      this.collectDependencyMetrics(),
      this.collectQualityMetrics()
    ]);

    return {
      timestamp,
      project: 'بصير MVP',
      structure,
      codebase,
      dependencies,
      quality
    };
  }

  /**
   * جمع مقاييس بنية المشروع
   */
  private async collectStructureMetrics() {
    const allFiles = await this.getAllFiles();
    
    return {
      totalFiles: allFiles.length,
      dartFiles: allFiles.filter(f => f.endsWith('.dart')).length,
      testFiles: allFiles.filter(f => f.includes('test') && f.endsWith('.dart')).length,
      assetFiles: allFiles.filter(f => this.isAssetFile(f)).length,
      configFiles: allFiles.filter(f => this.isConfigFile(f)).length
    };
  }

  /**
   * جمع مقاييس قاعدة الكود
   */
  private async collectCodebaseMetrics() {
    const dartFiles = await glob('**/*.dart', {
      ignore: this.excludePatterns,
      cwd: this.projectRoot
    });

    let totalLines = 0;
    let commentLines = 0;
    let testLines = 0;
    let complexity = 0;

    for (const file of dartFiles) {
      const filePath = path.join(this.projectRoot, file);
      const content = await fs.readFile(filePath, 'utf-8');
      const lines = content.split('\n');
      
      totalLines += lines.length;
      commentLines += this.countCommentLines(lines);
      
      if (file.includes('test')) {
        testLines += lines.length;
      }
      
      complexity += this.calculateComplexity(content);
    }

    return {
      linesOfCode: totalLines - commentLines,
      linesOfComments: commentLines,
      linesOfTests: testLines,
      complexity
    };
  }

  /**
   * جمع مقاييس التبعيات
   */
  private async collectDependencyMetrics() {
    try {
      const pubspecPath = path.join(this.projectRoot, 'pubspec.yaml');
      const pubspecContent = await fs.readFile(pubspecPath, 'utf-8');
      
      // تحليل pubspec.yaml للحصول على التبعيات
      const dependencyMatches = pubspecContent.match(/^\s+\w+:/gm) || [];
      const devDependencyMatches = pubspecContent.match(/dev_dependencies:\s*\n((?:\s+\w+:.*\n)*)/m);
      
      return {
        totalDependencies: dependencyMatches.length,
        devDependencies: devDependencyMatches ? devDependencyMatches[1].split('\n').filter(l => l.trim()).length : 0,
        outdatedDependencies: await this.checkOutdatedDependencies(),
        vulnerabilities: await this.checkVulnerabilities()
      };
    } catch (error) {
      return {
        totalDependencies: 0,
        devDependencies: 0,
        outdatedDependencies: 0,
        vulnerabilities: 0
      };
    }
  }

  /**
   * جمع مقاييس الجودة
   */
  private async collectQualityMetrics() {
    return {
      testCoverage: await this.calculateTestCoverage(),
      codeQualityScore: await this.calculateCodeQuality(),
      maintainabilityIndex: await this.calculateMaintainability(),
      technicalDebt: await this.calculateTechnicalDebt()
    };
  }

  /**
   * الحصول على جميع الملفات
   */
  private async getAllFiles(): Promise<string[]> {
    return await glob('**/*', {
      ignore: this.excludePatterns,
      cwd: this.projectRoot,
      nodir: true
    });
  }

  /**
   * فحص إذا كان الملف asset
   */
  private isAssetFile(filename: string): boolean {
    const assetExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.svg', '.json', '.yaml', '.yml'];
    return assetExtensions.some(ext => filename.endsWith(ext));
  }

  /**
   * فحص إذا كان الملف config
   */
  private isConfigFile(filename: string): boolean {
    const configFiles = ['pubspec.yaml', 'analysis_options.yaml', '.gitignore', 'README.md'];
    return configFiles.some(config => filename.endsWith(config));
  }

  /**
   * عد أسطر التعليقات
   */
  private countCommentLines(lines: string[]): number {
    return lines.filter(line => {
      const trimmed = line.trim();
      return trimmed.startsWith('//') || trimmed.startsWith('/*') || trimmed.startsWith('*');
    }).length;
  }

  /**
   * حساب التعقيد
   */
  private calculateComplexity(content: string): number {
    // حساب بسيط للتعقيد بناءً على الكلمات المفتاحية
    const complexityKeywords = ['if', 'else', 'for', 'while', 'switch', 'case', 'catch', 'try'];
    let complexity = 1; // base complexity
    
    for (const keyword of complexityKeywords) {
      const matches = content.match(new RegExp(`\\b${keyword}\\b`, 'g'));
      if (matches) {
        complexity += matches.length;
      }
    }
    
    return complexity;
  }

  /**
   * فحص التبعيات القديمة
   */
  private async checkOutdatedDependencies(): Promise<number> {
    // TODO: تنفيذ فحص التبعيات القديمة
    return 0;
  }

  /**
   * فحص الثغرات الأمنية
   */
  private async checkVulnerabilities(): Promise<number> {
    // TODO: تنفيذ فحص الثغرات الأمنية
    return 0;
  }

  /**
   * حساب تغطية الاختبارات
   */
  private async calculateTestCoverage(): Promise<number> {
    // TODO: تنفيذ حساب تغطية الاختبارات
    return 0;
  }

  /**
   * حساب جودة الكود
   */
  private async calculateCodeQuality(): Promise<number> {
    // TODO: تنفيذ حساب جودة الكود
    return 85; // قيمة افتراضية
  }

  /**
   * حساب مؤشر القابلية للصيانة
   */
  private async calculateMaintainability(): Promise<number> {
    // TODO: تنفيذ حساب القابلية للصيانة
    return 75; // قيمة افتراضية
  }

  /**
   * حساب الدين التقني
   */
  private async calculateTechnicalDebt(): Promise<number> {
    // TODO: تنفيذ حساب الدين التقني
    return 15; // قيمة افتراضية بالساعات
  }

  /**
   * حفظ المقاييس في ملف
   */
  async saveMetrics(metrics: WorkspaceMetrics, outputPath: string = '.kiro/data/workspace-metrics.json'): Promise<void> {
    const dir = path.dirname(outputPath);
    await fs.mkdir(dir, { recursive: true });
    
    // قراءة البيانات الموجودة
    let existingData: WorkspaceMetrics[] = [];
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
}

// مثال على الاستخدام
if (require.main === module) {
  const collector = new WorkspaceCollector();
  
  collector.collectMetrics()
    .then(metrics => {
      console.log('📊 Workspace Metrics:', metrics);
      return collector.saveMetrics(metrics);
    })
    .then(() => console.log('✅ Metrics saved successfully'))
    .catch(error => console.error('❌ Error collecting metrics:', error));
}