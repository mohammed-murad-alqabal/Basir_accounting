/**
 * L2 Decision Layer Configuration
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 11 ديسمبر 2025
 */

export interface L2DecisionConfig {
  project: string;
  
  // Decision Engine Configuration
  engine: {
    maxConcurrentDecisions: number;
    decisionTimeout: number;
    retryAttempts: number;
    confidenceThreshold: number;
  };
  
  // Rule Processor Configuration
  rules: {
    rulesPath: string;
    autoReload: boolean;
    reloadInterval: number;
    cacheTimeout: number;
    enableConflictResolution: boolean;
  };
  
  // ML Models Configuration
  ml: {
    modelsPath: string;
    autoUpdate: boolean;
    updateInterval: number;
    minTrainingData: number;
    confidenceThreshold: number;
    enablePredictions: boolean;
  };
  
  // Context Manager Configuration
  context: {
    dataPath: string;
    maxHistorySize: number;
    autoSave: boolean;
    saveInterval: number;
    conflictDetection: boolean;
  };
  
  // Action Executor Configuration
  actions: {
    maxConcurrentActions: number;
    defaultTimeout: number;
    defaultRetries: number;
    enableRollback: boolean;
    progressMonitoring: boolean;
  };
  
  // Integration Configuration
  integration: {
    l1AnalysisLayer: {
      enabled: boolean;
      endpoint?: string;
      pollInterval: number;
    };
    
    notifications: {
      enabled: boolean;
      channels: ('console' | 'file' | 'webhook')[];
      webhookUrl?: string;
    };
    
    monitoring: {
      enabled: boolean;
      metricsInterval: number;
      healthCheckInterval: number;
    };
  };
  
  // Security Configuration
  security: {
    enableAuditLog: boolean;
    auditLogPath: string;
    encryptSensitiveData: boolean;
    accessControl: boolean;
  };
}

export const DEFAULT_L2_CONFIG: L2DecisionConfig = {
  project: 'بصير MVP',
  
  engine: {
    maxConcurrentDecisions: 10,
    decisionTimeout: 300000, // 5 minutes
    retryAttempts: 3,
    confidenceThreshold: 0.7
  },
  
  rules: {
    rulesPath: '.kiro/config/l2-rules.yml',
    autoReload: true,
    reloadInterval: 60000, // 1 minute
    cacheTimeout: 300000, // 5 minutes
    enableConflictResolution: true
  },
  
  ml: {
    modelsPath: '.kiro/data/ml-models',
    autoUpdate: true,
    updateInterval: 86400000, // 24 hours
    minTrainingData: 50,
    confidenceThreshold: 0.6,
    enablePredictions: true
  },
  
  context: {
    dataPath: '.kiro/data/context',
    maxHistorySize: 1000,
    autoSave: true,
    saveInterval: 30000, // 30 seconds
    conflictDetection: true
  },
  
  actions: {
    maxConcurrentActions: 5,
    defaultTimeout: 60000, // 1 minute
    defaultRetries: 3,
    enableRollback: true,
    progressMonitoring: true
  },
  
  integration: {
    l1AnalysisLayer: {
      enabled: true,
      pollInterval: 30000 // 30 seconds
    },
    
    notifications: {
      enabled: true,
      channels: ['console', 'file']
    },
    
    monitoring: {
      enabled: true,
      metricsInterval: 60000, // 1 minute
      healthCheckInterval: 300000 // 5 minutes
    }
  },
  
  security: {
    enableAuditLog: true,
    auditLogPath: '.kiro/logs/l2-audit.log',
    encryptSensitiveData: true,
    accessControl: false
  }
};

/**
 * تحميل التكوين من ملف
 */
export async function loadConfig(configPath?: string): Promise<L2DecisionConfig> {
  if (!configPath) {
    return DEFAULT_L2_CONFIG;
  }
  
  try {
    const { promises: fs } = await import('fs');
    const content = await fs.readFile(configPath, 'utf-8');
    const userConfig = JSON.parse(content);
    
    // دمج التكوين الافتراضي مع تكوين المستخدم
    return mergeConfigs(DEFAULT_L2_CONFIG, userConfig);
    
  } catch (error) {
    console.warn(`⚠️ Could not load config from ${configPath}, using defaults`);
    return DEFAULT_L2_CONFIG;
  }
}

/**
 * حفظ التكوين إلى ملف
 */
export async function saveConfig(config: L2DecisionConfig, configPath: string): Promise<boolean> {
  try {
    const { promises: fs } = await import('fs');
    const * as path from 'path';
    
    // إنشاء المجلد إذا لم يكن موجوداً
    await fs.mkdir(path.dirname(configPath), { recursive: true });
    
    // حفظ التكوين
    await fs.writeFile(configPath, JSON.stringify(config, null, 2));
    
    console.log(`✅ Configuration saved to: ${configPath}`);
    return true;
    
  } catch (error) {
    console.error(`❌ Error saving config:`, error);
    return false;
  }
}

/**
 * التحقق من صحة التكوين
 */
export function validateConfig(config: L2DecisionConfig): { isValid: boolean; errors: string[] } {
  const errors: string[] = [];
  
  // التحقق من القيم المطلوبة
  if (!config.project || config.project.trim() === '') {
    errors.push('Project name is required');
  }
  
  // التحقق من قيم المهلة الزمنية
  if (config.engine.decisionTimeout <= 0) {
    errors.push('Decision timeout must be positive');
  }
  
  if (config.engine.maxConcurrentDecisions <= 0) {
    errors.push('Max concurrent decisions must be positive');
  }
  
  // التحقق من عتبات الثقة
  if (config.engine.confidenceThreshold < 0 || config.engine.confidenceThreshold > 1) {
    errors.push('Confidence threshold must be between 0 and 1');
  }
  
  if (config.ml.confidenceThreshold < 0 || config.ml.confidenceThreshold > 1) {
    errors.push('ML confidence threshold must be between 0 and 1');
  }
  
  // التحقق من المسارات
  if (!config.rules.rulesPath) {
    errors.push('Rules path is required');
  }
  
  if (!config.ml.modelsPath) {
    errors.push('ML models path is required');
  }
  
  if (!config.context.dataPath) {
    errors.push('Context data path is required');
  }
  
  return {
    isValid: errors.length === 0,
    errors
  };
}

/**
 * دمج تكوينين
 */
function mergeConfigs(defaultConfig: L2DecisionConfig, userConfig: any): L2DecisionConfig {
  const merged = JSON.parse(JSON.stringify(defaultConfig));
  
  function deepMerge(target: any, source: any): void {
    for (const key in source) {
      if (source[key] && typeof source[key] === 'object' && !Array.isArray(source[key])) {
        if (!target[key]) target[key] = {};
        deepMerge(target[key], source[key]);
      } else {
        target[key] = source[key];
      }
    }
  }
  
  deepMerge(merged, userConfig);
  return merged;
}

/**
 * إنشاء تكوين للبيئات المختلفة
 */
export function createEnvironmentConfig(environment: 'development' | 'testing' | 'production'): L2DecisionConfig {
  const config = JSON.parse(JSON.stringify(DEFAULT_L2_CONFIG));
  
  switch (environment) {
    case 'development':
      config.engine.confidenceThreshold = 0.5; // أقل صرامة للتطوير
      config.ml.confidenceThreshold = 0.4;
      config.integration.monitoring.metricsInterval = 30000; // مراقبة أكثر تكراراً
      config.security.accessControl = false;
      break;
      
    case 'testing':
      config.engine.decisionTimeout = 60000; // مهلة أقصر للاختبار
      config.actions.defaultTimeout = 30000;
      config.integration.notifications.channels = ['console'];
      config.security.enableAuditLog = false;
      break;
      
    case 'production':
      config.engine.confidenceThreshold = 0.8; // أكثر صرامة للإنتاج
      config.ml.confidenceThreshold = 0.7;
      config.security.accessControl = true;
      config.security.encryptSensitiveData = true;
      config.integration.notifications.channels = ['file', 'webhook'];
      break;
  }
  
  return config;
}

/**
 * الحصول على تكوين مخصص لمشروع بصير MVP
 */
export function getBasserMVPConfig(): L2DecisionConfig {
  const config = JSON.parse(JSON.stringify(DEFAULT_L2_CONFIG));
  
  // تخصيصات خاصة بمشروع بصير
  config.project = 'بصير MVP';
  
  // تحسين للتطبيقات Flutter
  config.engine.maxConcurrentDecisions = 8;
  config.engine.confidenceThreshold = 0.75;
  
  // تكوين خاص بـ Flutter/Riverpod/Isar
  config.rules.rulesPath = '.kiro/config/basser-rules.yml';
  config.ml.modelsPath = '.kiro/data/basser-models';
  
  // مراقبة محسنة لتطبيقات Flutter
  config.integration.monitoring.metricsInterval = 45000;
  config.context.maxHistorySize = 1500;
  
  // إعدادات الأمان للمشروع
  config.security.enableAuditLog = true;
  config.security.auditLogPath = '.kiro/logs/basser-l2-audit.log';
  
  return config;
}