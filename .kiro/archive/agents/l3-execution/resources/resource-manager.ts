/**
 * Resource Manager - Intelligent System Resource Management
 * 
 * المشروع: بصير MVP
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 11 ديسمبر 2025
 */

import { EventEmitter } from 'events';

export interface ResourceUsage {
  timestamp: Date;
  cpu: {
    usage: number; // percentage
    cores: number;
    load: number[];
    temperature?: number;
  };
  memory: {
    used: number; // bytes
    available: number;
    total: number;
    percentage: number;
    swap?: {
      used: number;
      total: number;
    };
  };
  disk: {
    used: number;
    available: number;
    total: number;
    percentage: number;
    iops?: number;
  };
  network: {
    bytesIn: number;
    bytesOut: number;
    packetsIn: number;
    packetsOut: number;
    connections: number;
  };
}

export interface ResourceRequirement {
  type: ResourceType;
  amount: number;
  unit: string;
  duration?: number; // milliseconds
  priority: Priority;
}

export enum ResourceType {
  CPU = 'cpu',
  MEMORY = 'memory',
  DISK = 'disk',
  NETWORK = 'network',
  GPU = 'gpu'
}

export interface ResourceAllocation {
  id: string;
  timestamp: Date;
  requirements: ResourceRequirement[];
  allocated: ResourceUsage;
  taskId?: string;
  duration?: number;
  status: AllocationStatus;
}

export enum AllocationStatus {
  PENDING = 'pending',
  ALLOCATED = 'allocated',
  RELEASED = 'released',
  EXPIRED = 'expired'
}

export interface ResourceBottleneck {
  type: ResourceType;
  severity: 'low' | 'medium' | 'high' | 'critical';
  currentUsage: number;
  threshold: number;
  impact: string; // Arabic description
  suggestions: string[]; // Arabic suggestions
}

export class ResourceManager extends EventEmitter {
  private currentUsage: ResourceUsage;
  private allocations: Map<string, ResourceAllocation> = new Map();
  private reservations: Map<string, ResourceReservation> = new Map();
  private usageHistory: ResourceUsage[] = [];
  
  private isRunning = false;
  private monitoringInterval?: NodeJS.Timeout;
  private readonly maxHistorySize = 1000;
  
  // Resource thresholds
  private readonly thresholds = {
    cpu: { warning: 70, critical: 90 },
    memory: { warning: 80, critical: 95 },
    disk: { warning: 85, critical: 95 },
    network: { warning: 80, critical: 95 }
  };

  constructor() {
    super();
    this.initializeResourceUsage();
  }

  /**
   * بدء مدير الموارد
   */
  async start(): Promise<void> {
    console.log('💾 Starting Resource Manager...');
    
    try {
      // بدء مراقبة الموارد
      await this.startResourceMonitoring();
      
      this.isRunning = true;
      console.log('✅ Resource Manager started');
      this.emit('managerStarted');
      
    } catch (error) {
      console.error('❌ Failed to start Resource Manager:', error);
      throw error;
    }
  }

  /**
   * إيقاف مدير الموارد
   */
  async stop(): Promise<void> {
    console.log('🛑 Stopping Resource Manager...');
    
    // إيقاف المراقبة
    if (this.monitoringInterval) {
      clearInterval(this.monitoringInterval);
      this.monitoringInterval = undefined;
    }
    
    // تحرير جميع التخصيصات
    for (const allocation of this.allocations.values()) {
      if (allocation.status === AllocationStatus.ALLOCATED) {
        await this.releaseResources(allocation.id);
      }
    }
    
    this.isRunning = false;
    console.log('✅ Resource Manager stopped');
    this.emit('managerStopped');
  }

  /**
   * الحصول على استخدام الموارد الحالي
   */
  async getResourceUsage(): Promise<ResourceUsage> {
    await this.updateResourceUsage();
    return { ...this.currentUsage };
  }

  /**
   * تخصيص الموارد
   */
  async allocateResources(requirements: ResourceRequirement[]): Promise<ResourceAllocation> {
    console.log(`🔧 Allocating resources for ${requirements.length} requirements...`);
    
    // التحقق من توفر الموارد
    const availability = await this.checkResourceAvailability(requirements);
    if (!availability.available) {
      throw new Error(`Insufficient resources: ${availability.reason}`);
    }

    const allocation: ResourceAllocation = {
      id: this.generateAllocationId(),
      timestamp: new Date(),
      requirements,
      allocated: await this.getResourceUsage(),
      status: AllocationStatus.ALLOCATED
    };

    this.allocations.set(allocation.id, allocation);
    
    console.log(`✅ Resources allocated: ${allocation.id}`);
    this.emit('resourceAllocated', allocation);
    
    return allocation;
  }