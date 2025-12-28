/**
 * System Monitor - L1 Analysis Layer
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 10 ديسمبر 2025
 */

import { exec } from 'child_process';
import { promises as fs } from 'fs';
import * as os from 'os';
import * as path from 'path';
import { promisify } from 'util';

const execAsync = promisify(exec);

export interface SystemMetrics {
  timestamp: Date;
  system: {
    platform: string;
    arch: string;
    hostname: string;
    uptime: number;
    loadAverage: number[];
  };
  cpu: {
    model: string;
    cores: number;
    usage: number;
    temperature?: number;
  };
  memory: {
    total: number;
    free: number;
    used: number;
    usagePercent: number;
    swapTotal: number;
    swapUsed: number;
  };
  disk: {
    total: number;
    free: number;
    used: number;
    usagePercent: number;
  };
  network: {
    interfaces: NetworkInterface[];
    activeConnections: number;
  };
  processes: {
    total: number;
    running: number;
    sleeping: number;
    zombie: number;
  };
}

export interface NetworkInterface {
  name: string;
  address: string;
  netmask: string;
  family: string;
  mac: string;
  internal: boolean;
}

export interface SystemAlert {
  level: 'info' | 'warning' | 'critical';
  component: string;
  message: string;
  value: number;
  threshold: number;
  timestamp: Date;
}

export class SystemMonitor {
  private alertThresholds = {
    cpu: { warning: 70, critical: 90 },
    memory: { warning: 80, critical: 95 },
    disk: { warning: 85, critical: 95 },
    load: { warning: 2, critical: 4 }
  };

  private monitoringInterval?: NodeJS.Timeout;
  private isMonitoring = false;

  /**
   * جمع جميع مقاييس النظام
   */
  async collectMetrics(): Promise<SystemMetrics> {
    const timestamp = new Date();
    
    const [system, cpu, memory, disk, network, processes] = await Promise.all([
      this.collectSystemInfo(),
      this.collectCpuMetrics(),
      this.collectMemoryMetrics(),
      this.collectDiskMetrics(),
      this.collectNetworkMetrics(),
      this.collectProcessMetrics()
    ]);

    return {
      timestamp,
      system,
      cpu,
      memory,
      disk,
      network,
      processes
    };
  }

  /**
   * جمع معلومات النظام الأساسية
   */
  private async collectSystemInfo() {
    return {
      platform: os.platform(),
      arch: os.arch(),
      hostname: os.hostname(),
      uptime: os.uptime(),
      loadAverage: os.loadavg()
    };
  }

  /**
   * جمع مقاييس المعالج
   */
  private async collectCpuMetrics() {
    const cpus = os.cpus();
    const cpuUsage = await this.getCpuUsage();
    
    return {
      model: cpus[0]?.model || 'Unknown',
      cores: cpus.length,
      usage: cpuUsage,
      temperature: await this.getCpuTemperature()
    };
  }

  /**
   * جمع مقاييس الذاكرة
   */
  private async collectMemoryMetrics() {
    const totalMemory = os.totalmem();
    const freeMemory = os.freemem();
    const usedMemory = totalMemory - freeMemory;
    const usagePercent = (usedMemory / totalMemory) * 100;
    
    const swapInfo = await this.getSwapInfo();
    
    return {
      total: totalMemory,
      free: freeMemory,
      used: usedMemory,
      usagePercent,
      swapTotal: swapInfo.total,
      swapUsed: swapInfo.used
    };
  }

  /**
   * جمع مقاييس القرص
   */
  private async collectDiskMetrics() {
    const diskInfo = await this.getDiskInfo();
    
    return {
      total: diskInfo.total,
      free: diskInfo.free,
      used: diskInfo.used,
      usagePercent: diskInfo.usagePercent
    };
  }

  /**
   * جمع مقاييس الشبكة
   */
  private async collectNetworkMetrics() {
    const interfaces = this.getNetworkInterfaces();
    const activeConnections = await this.getActiveConnections();
    
    return {
      interfaces,
      activeConnections
    };
  }

  /**
   * جمع مقاييس العمليات
   */
  private async collectProcessMetrics() {
    const processInfo = await this.getProcessInfo();
    
    return {
      total: processInfo.total,
      running: processInfo.running,
      sleeping: processInfo.sleeping,
      zombie: processInfo.zombie
    };
  }

  /**
   * حساب استخدام المعالج
   */
  private async getCpuUsage(): Promise<number> {
    return new Promise((resolve) => {
      const startMeasure = this.cpuAverage();
      
      setTimeout(() => {
        const endMeasure = this.cpuAverage();
        const idleDifference = endMeasure.idle - startMeasure.idle;
        const totalDifference = endMeasure.total - startMeasure.total;
        const cpuPercentage = 100 - ~~(100 * idleDifference / totalDifference);
        
        resolve(cpuPercentage);
      }, 1000);
    });
  }

  /**
   * حساب متوسط المعالج
   */
  private cpuAverage() {
    const cpus = os.cpus();
    let totalIdle = 0;
    let totalTick = 0;
    
    for (const cpu of cpus) {
      for (const type in cpu.times) {
        totalTick += cpu.times[type as keyof typeof cpu.times];
      }
      totalIdle += cpu.times.idle;
    }
    
    return {
      idle: totalIdle / cpus.length,
      total: totalTick / cpus.length
    };
  }

  /**
   * الحصول على درجة حرارة المعالج
   */
  private async getCpuTemperature(): Promise<number | undefined> {
    try {
      if (os.platform() === 'linux') {
        const { stdout } = await execAsync('cat /sys/class/thermal/thermal_zone0/temp');
        return parseInt(stdout.trim()) / 1000;
      }
      return undefined;
    } catch {
      return undefined;
    }
  }

  /**
   * الحصول على معلومات Swap
   */
  private async getSwapInfo(): Promise<{ total: number; used: number }> {
    try {
      if (os.platform() === 'linux') {
        const { stdout } = await execAsync('free -b | grep Swap');
        const parts = stdout.trim().split(/\s+/);
        return {
          total: parseInt(parts[1]) || 0,
          used: parseInt(parts[2]) || 0
        };
      }
      return { total: 0, used: 0 };
    } catch {
      return { total: 0, used: 0 };
    }
  }

  /**
   * الحصول على معلومات القرص
   */
  private async getDiskInfo(): Promise<{
    total: number;
    free: number;
    used: number;
    usagePercent: number;
  }> {
    try {
      const { stdout } = await execAsync('df -B1 .');
      const lines = stdout.trim().split('\n');
      const parts = lines[1].split(/\s+/);
      
      const total = parseInt(parts[1]);
      const used = parseInt(parts[2]);
      const free = parseInt(parts[3]);
      const usagePercent = (used / total) * 100;
      
      return { total, free, used, usagePercent };
    } catch {
      return { total: 0, free: 0, used: 0, usagePercent: 0 };
    }
  }

  /**
   * الحصول على واجهات الشبكة
   */
  private getNetworkInterfaces(): NetworkInterface[] {
    const interfaces = os.networkInterfaces();
    const result: NetworkInterface[] = [];
    
    for (const [name, addresses] of Object.entries(interfaces)) {
      if (addresses) {
        for (const addr of addresses) {
          result.push({
            name,
            address: addr.address,
            netmask: addr.netmask,
            family: addr.family,
            mac: addr.mac,
            internal: addr.internal
          });
        }
      }
    }
    
    return result;
  }

  /**
   * الحصول على الاتصالات النشطة
   */
  private async getActiveConnections(): Promise<number> {
    try {
      const { stdout } = await execAsync('netstat -an | wc -l');
      return parseInt(stdout.trim()) || 0;
    } catch {
      return 0;
    }
  }

  /**
   * الحصول على معلومات العمليات
   */
  private async getProcessInfo(): Promise<{
    total: number;
    running: number;
    sleeping: number;
    zombie: number;
  }> {
    try {
      const { stdout } = await execAsync('ps aux | wc -l');
      const total = parseInt(stdout.trim()) - 1; // exclude header
      
      // TODO: تحسين لحساب حالات العمليات المختلفة
      return {
        total,
        running: Math.floor(total * 0.1),
        sleeping: Math.floor(total * 0.8),
        zombie: 0
      };
    } catch {
      return { total: 0, running: 0, sleeping: 0, zombie: 0 };
    }
  }

  /**
   * تحليل المقاييس وإنتاج التنبيهات
   */
  async analyzeMetrics(metrics: SystemMetrics): Promise<SystemAlert[]> {
    const alerts: SystemAlert[] = [];
    
    // تحليل استخدام المعالج
    if (metrics.cpu.usage >= this.alertThresholds.cpu.critical) {
      alerts.push({
        level: 'critical',
        component: 'CPU',
        message: 'استخدام المعالج مرتفع جداً',
        value: metrics.cpu.usage,
        threshold: this.alertThresholds.cpu.critical,
        timestamp: new Date()
      });
    } else if (metrics.cpu.usage >= this.alertThresholds.cpu.warning) {
      alerts.push({
        level: 'warning',
        component: 'CPU',
        message: 'استخدام المعالج مرتفع',
        value: metrics.cpu.usage,
        threshold: this.alertThresholds.cpu.warning,
        timestamp: new Date()
      });
    }

    // تحليل استخدام الذاكرة
    if (metrics.memory.usagePercent >= this.alertThresholds.memory.critical) {
      alerts.push({
        level: 'critical',
        component: 'Memory',
        message: 'استخدام الذاكرة مرتفع جداً',
        value: metrics.memory.usagePercent,
        threshold: this.alertThresholds.memory.critical,
        timestamp: new Date()
      });
    } else if (metrics.memory.usagePercent >= this.alertThresholds.memory.warning) {
      alerts.push({
        level: 'warning',
        component: 'Memory',
        message: 'استخدام الذاكرة مرتفع',
        value: metrics.memory.usagePercent,
        threshold: this.alertThresholds.memory.warning,
        timestamp: new Date()
      });
    }

    // تحليل استخدام القرص
    if (metrics.disk.usagePercent >= this.alertThresholds.disk.critical) {
      alerts.push({
        level: 'critical',
        component: 'Disk',
        message: 'مساحة القرص ممتلئة تقريباً',
        value: metrics.disk.usagePercent,
        threshold: this.alertThresholds.disk.critical,
        timestamp: new Date()
      });
    } else if (metrics.disk.usagePercent >= this.alertThresholds.disk.warning) {
      alerts.push({
        level: 'warning',
        component: 'Disk',
        message: 'مساحة القرص منخفضة',
        value: metrics.disk.usagePercent,
        threshold: this.alertThresholds.disk.warning,
        timestamp: new Date()
      });
    }

    // تحليل Load Average
    const loadAvg = metrics.system.loadAverage[0];
    if (loadAvg >= this.alertThresholds.load.critical) {
      alerts.push({
        level: 'critical',
        component: 'Load',
        message: 'حمولة النظام مرتفعة جداً',
        value: loadAvg,
        threshold: this.alertThresholds.load.critical,
        timestamp: new Date()
      });
    } else if (loadAvg >= this.alertThresholds.load.warning) {
      alerts.push({
        level: 'warning',
        component: 'Load',
        message: 'حمولة النظام مرتفعة',
        value: loadAvg,
        threshold: this.alertThresholds.load.warning,
        timestamp: new Date()
      });
    }

    return alerts;
  }

  /**
   * بدء المراقبة المستمرة
   */
  startMonitoring(intervalMs: number = 60000, callback?: (metrics: SystemMetrics, alerts: SystemAlert[]) => void): void {
    if (this.isMonitoring) {
      return;
    }

    this.isMonitoring = true;
    
    const monitor = async () => {
      try {
        const metrics = await this.collectMetrics();
        const alerts = await this.analyzeMetrics(metrics);
        
        // حفظ المقاييس
        await this.saveMetrics(metrics);
        
        // حفظ التنبيهات إذا وجدت
        if (alerts.length > 0) {
          await this.saveAlerts(alerts);
        }
        
        // استدعاء callback إذا تم توفيره
        if (callback) {
          callback(metrics, alerts);
        }
        
      } catch (error) {
        console.error('❌ Error in system monitoring:', error);
      }
    };

    // تشغيل فوري ثم دوري
    monitor();
    this.monitoringInterval = setInterval(monitor, intervalMs);
  }

  /**
   * إيقاف المراقبة
   */
  stopMonitoring(): void {
    if (this.monitoringInterval) {
      clearInterval(this.monitoringInterval);
      this.monitoringInterval = undefined;
    }
    this.isMonitoring = false;
  }

  /**
   * حفظ المقاييس
   */
  async saveMetrics(metrics: SystemMetrics, outputPath: string = '.kiro/data/system-metrics.json'): Promise<void> {
    const dir = path.dirname(outputPath);
    await fs.mkdir(dir, { recursive: true });
    
    // قراءة البيانات الموجودة
    let existingData: SystemMetrics[] = [];
    try {
      const existing = await fs.readFile(outputPath, 'utf-8');
      existingData = JSON.parse(existing);
    } catch {
      // الملف غير موجود
    }
    
    // إضافة المقاييس الجديدة
    existingData.push(metrics);
    
    // الاحتفاظ بآخر 1000 قياس فقط
    if (existingData.length > 1000) {
      existingData = existingData.slice(-1000);
    }
    
    await fs.writeFile(outputPath, JSON.stringify(existingData, null, 2));
  }

  /**
   * حفظ التنبيهات
   */
  async saveAlerts(alerts: SystemAlert[], outputPath: string = '.kiro/data/system-alerts.json'): Promise<void> {
    const dir = path.dirname(outputPath);
    await fs.mkdir(dir, { recursive: true });
    
    // قراءة التنبيهات الموجودة
    let existingAlerts: SystemAlert[] = [];
    try {
      const existing = await fs.readFile(outputPath, 'utf-8');
      existingAlerts = JSON.parse(existing);
    } catch {
      // الملف غير موجود
    }
    
    // إضافة التنبيهات الجديدة
    existingAlerts.push(...alerts);
    
    // الاحتفاظ بآخر 500 تنبيه فقط
    if (existingAlerts.length > 500) {
      existingAlerts = existingAlerts.slice(-500);
    }
    
    await fs.writeFile(outputPath, JSON.stringify(existingAlerts, null, 2));
  }

  /**
   * الحصول على تقرير صحة النظام
   */
  async getHealthReport(): Promise<{
    status: 'healthy' | 'warning' | 'critical';
    score: number;
    issues: string[];
    recommendations: string[];
  }> {
    const metrics = await this.collectMetrics();
    const alerts = await this.analyzeMetrics(metrics);
    
    let score = 100;
    const issues: string[] = [];
    const recommendations: string[] = [];
    
    // تحليل التنبيهات
    for (const alert of alerts) {
      if (alert.level === 'critical') {
        score -= 30;
        issues.push(alert.message);
        recommendations.push(`تحسين ${alert.component}`);
      } else if (alert.level === 'warning') {
        score -= 15;
        issues.push(alert.message);
        recommendations.push(`مراقبة ${alert.component}`);
      }
    }
    
    // تحديد الحالة العامة
    let status: 'healthy' | 'warning' | 'critical' = 'healthy';
    if (alerts.some(a => a.level === 'critical')) {
      status = 'critical';
    } else if (alerts.some(a => a.level === 'warning')) {
      status = 'warning';
    }
    
    return {
      status,
      score: Math.max(0, score),
      issues,
      recommendations
    };
  }
}

// مثال على الاستخدام
if (require.main === module) {
  const monitor = new SystemMonitor();
  
  // جمع مقاييس فورية
  monitor.collectMetrics()
    .then(metrics => {
      console.log('🖥️ System Metrics:', metrics);
      return monitor.analyzeMetrics(metrics);
    })
    .then(alerts => {
      if (alerts.length > 0) {
        console.log('⚠️ System Alerts:', alerts);
      } else {
        console.log('✅ No system alerts');
      }
      return monitor.getHealthReport();
    })
    .then(health => {
      console.log('🏥 System Health:', health);
    })
    .catch(error => console.error('❌ Error:', error));
}