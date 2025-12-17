/**
 * AI Provider Interface System
 * 
 * المؤلف: فريق وكلاء تطوير مشروع بصير
 * التاريخ: 15 ديسمبر 2025
 * الحالة: ✅ نشط ومتقدم
 */

// Core interfaces for AI provider system
export interface AIProvider {
  readonly name: string;
  readonly capabilities: ProviderCapability[];
  readonly contextLimit: number;
  readonly costPerToken: number;
  readonly averageResponseTime: number;

  // Core methods
  generatePrompt(task: TaskRequest, context: ProjectContext): string;
  optimizeForProvider(prompt: string): OptimizedPrompt;
  handleResponse(response: ProviderResponse): ProcessedResponse;
  healthCheck(): Promise<ProviderHealth>;
}

export interface TaskRequest {
  type: TaskType;
  description: string;
  priority: Priority;
  context: TaskContext;
  requirements: TaskRequirement[];
  constraints: TaskConstraint[];
}

export enum TaskType {
  CODE_GENERATION = 'code_generation',
  CODE_REVIEW = 'code_review',
  ARCHITECTURE_ANALYSIS = 'architecture_analysis',
  DOCUMENTATION = 'documentation',
  DEBUGGING = 'debugging',
  TESTING = 'testing',
  SECURITY_ANALYSIS = 'security_analysis',
  PERFORMANCE_OPTIMIZATION = 'performance_optimization'
}

export enum Priority {
  LOW = 'low',
  MEDIUM = 'medium',
  HIGH = 'high',
  CRITICAL = 'critical'
}

export interface ProjectContext {
  projectName: string;
  framework: string; // 'Flutter'
  language: string; // 'Dart'
  architecture: string; // 'Clean Architecture'
  stateManagement: string; // 'Riverpod'
  database: string; // 'Isar'
  targetUsers: string; // 'Arabic-speaking users in Saudi Arabia'
  specialRequirements: string[]; // ['RTL support', 'offline-first', 'local-first']
}

export interface ProviderCapability {
  name: string;
  description: string;
  qualityScore: number; // 0-10
  supportLevel: SupportLevel;
}

export enum SupportLevel {
  EXCELLENT = 'excellent',
  GOOD = 'good',
  FAIR = 'fair',
  LIMITED = 'limited',
  NOT_SUPPORTED = 'not_supported'
}

export interface OptimizedPrompt {
  content: string;
  estimatedTokens: number;
  optimizations: PromptOptimization[];
  metadata: PromptMetadata;
}

export interface PromptOptimization {
  type: OptimizationType;
  description: string;
  impact: OptimizationImpact;
}

export enum OptimizationType {
  TOKEN_REDUCTION = '<credential-fixture>',
  CONTEXT_ENHANCEMENT = 'context_enhancement',
  STRUCTURE_IMPROVEMENT = 'structure_improvement',
  PROVIDER_SPECIFIC = 'provider_specific'
}

export interface OptimizationImpact {
  tokensSaved: number;
  qualityImprovement: number; // 0-1
  responseTimeImprovement: number; // milliseconds
}

export interface ProviderResponse {
  content: string;
  metadata: ResponseMetadata;
  usage: TokenUsage;
  timing: ResponseTiming;
}

export interface ProcessedResponse {
  content: string;
  quality: QualityAssessment;
  validation: ValidationResult;
  enhancements: ResponseEnhancement[];
}

export interface QualityAssessment {
  overallScore: number; // 0-10
  criteria: QualityCriterion[];
  recommendations: string[];
}

export interface QualityCriterion {
  name: string;
  score: number; // 0-10
  weight: number; // 0-1
  feedback: string;
}

export interface ValidationResult {
  isValid: boolean;
  syntaxCheck: SyntaxValidation;
  securityCheck: SecurityValidation;
  rtlCompatibility: RTLValidation;
  testCoverage: TestCoverageValidation;
}

export interface SyntaxValidation {
  isValid: boolean;
  errors: SyntaxError[];
  warnings: SyntaxWarning[];
}

export interface SecurityValidation {
  isSecure: boolean;
  vulnerabilities: SecurityVulnerability[];
  recommendations: SecurityRecommendation[];
}

export interface RTLValidation {
  isCompatible: boolean;
  issues: RTLIssue[];
  suggestions: RTLSuggestion[];
}

export interface TestCoverageValidation {
  hasTests: boolean;
  coverageEstimate: number; // 0-100
  missingTests: string[];
  testQuality: number; // 0-10
}

export interface ProviderHealth {
  isAvailable: boolean;
  responseTime: number; // milliseconds
  errorRate: number; // 0-1
  lastCheck: Date;
  issues: HealthIssue[];
}

export interface HealthIssue {
  severity: IssueSeverity;
  description: string;
  impact: string;
  recommendation: string;
}

export enum IssueSeverity {
  INFO = 'info',
  WARNING = 'warning',
  ERROR = 'error',
  CRITICAL = 'critical'
}

// Provider Manager Interface
export interface ProviderManager {
  // Provider management
  registerProvider(provider: AIProvider): void;
  getProvider(name: string): AIProvider | undefined;
  getAllProviders(): AIProvider[];
  getAvailableProviders(): AIProvider[];

  // Task execution
  executeTask(task: TaskRequest): Promise<TaskResult>;
  selectOptimalProvider(task: TaskRequest): AIProvider;
  executeFallback(task: TaskRequest, originalError: Error): Promise<TaskResult>;

  // Health monitoring
  checkProviderHealth(providerName: string): Promise<ProviderHealth>;
  getHealthStatus(): Promise<SystemHealth>;
  
  // Performance monitoring
  getPerformanceMetrics(): ProviderMetrics;
  optimizeProviderSelection(): void;
}

export interface TaskResult {
  success: boolean;
  response: ProcessedResponse;
  provider: string;
  executionTime: number;
  cost: number;
  quality: number;
  error?: TaskError;
}

export interface TaskError {
  type: ErrorType;
  message: string;
  details: string;
  recoverable: boolean;
  suggestedAction: string;
}

export enum ErrorType {
  PROVIDER_UNAVAILABLE = 'provider_unavailable',
  RATE_LIMIT_EXCEEDED = 'rate_limit_exceeded',
  INVALID_REQUEST = 'invalid_request',
  PROCESSING_ERROR = 'processing_error',
  VALIDATION_FAILED = 'validation_failed',
  TIMEOUT = 'timeout'
}

export interface SystemHealth {
  overallStatus: HealthStatus;
  providers: Map<string, ProviderHealth>;
  lastUpdate: Date;
  recommendations: SystemRecommendation[];
}

export enum HealthStatus {
  HEALTHY = 'healthy',
  DEGRADED = 'degraded',
  UNHEALTHY = 'unhealthy',
  CRITICAL = 'critical'
}

export interface SystemRecommendation {
  priority: Priority;
  category: RecommendationCategory;
  description: string;
  action: string;
  impact: string;
}

export enum RecommendationCategory {
  PERFORMANCE = 'performance',
  RELIABILITY = 'reliability',
  COST_OPTIMIZATION = 'cost_optimization',
  SECURITY = 'security',
  MAINTENANCE = 'maintenance'
}

export interface ProviderMetrics {
  totalRequests: number;
  successRate: number;
  averageResponseTime: number;
  totalCost: number;
  qualityScore: number;
  providerUsage: Map<string, ProviderUsageMetrics>;
}

export interface ProviderUsageMetrics {
  requests: number;
  successRate: number;
  averageResponseTime: number;
  cost: number;
  qualityScore: number;
  lastUsed: Date;
}

// Context optimization interfaces
export interface ContextOptimizer {
  optimizeContext(content: string, maxTokens: number, provider: string): OptimizedContext;
  estimateTokens(content: string, provider: string): number;
  prioritizeContent(sections: ContentSection[]): ContentSection[];
}

export interface OptimizedContext {
  content: string;
  tokenCount: number;
  optimizations: ContextOptimization[];
  removedSections: ContentSection[];
}

export interface ContextOptimization {
  type: string;
  description: string;
  tokensSaved: number;
  qualityImpact: number;
}

export interface ContentSection {
  id: string;
  content: string;
  priority: number;
  tokenCount: number;
  type: ContentType;
}

export enum ContentType {
  PROJECT_CONTEXT = 'project_context',
  CODE_CONTEXT = 'code_context',
  REQUIREMENTS = 'requirements',
  EXAMPLES = 'examples',
  DOCUMENTATION = 'documentation',
  METADATA = 'metadata'
}

// Response enhancement interfaces
export interface ResponseEnhancer {
  enhanceResponse(response: ProcessedResponse, task: TaskRequest): EnhancedResponse;
  addDocumentation(code: string): string;
  generateTests(code: string, framework: string): string;
  optimizePerformance(code: string): string;
  ensureRTLSupport(code: string): string;
}

export interface EnhancedResponse {
  originalResponse: ProcessedResponse;
  enhancements: Enhancement[];
  finalContent: string;
  qualityImprovement: number;
}

export interface Enhancement {
  type: EnhancementType;
  description: string;
  content: string;
  impact: EnhancementImpact;
}

export enum EnhancementType {
  DOCUMENTATION_ADDED = 'documentation_added',
  TESTS_GENERATED = 'tests_generated',
  PERFORMANCE_OPTIMIZED = 'performance_optimized',
  RTL_SUPPORT_ADDED = 'rtl_support_added',
  SECURITY_IMPROVED = 'security_improved',
  ERROR_HANDLING_ENHANCED = 'error_handling_enhanced'
}

export interface EnhancementImpact {
  qualityIncrease: number;
  maintainabilityIncrease: number;
  securityIncrease: number;
  performanceIncrease: number;
}

// Additional utility interfaces
export interface TokenUsage {
  promptTokens: number;
  completionTokens: number;
  totalTokens: number;
  cost: number;
}

export interface ResponseTiming {
  startTime: Date;
  endTime: Date;
  duration: number;
  processingTime: number;
}

export interface ResponseMetadata {
  provider: string;
  model: string;
  version: string;
  timestamp: Date;
  requestId: string;
}

export interface PromptMetadata {
  version: string;
  template: string;
  variables: Record<string, any>;
  optimizations: string[];
}

export interface TaskContext {
  filePath?: string;
  codeContext?: string;
  relatedFiles?: string[];
  architectureLayer?: ArchitectureLayer;
  dependencies?: string[];
}

export enum ArchitectureLayer {
  PRESENTATION = 'presentation',
  DOMAIN = 'domain',
  DATA = 'data',
  INFRASTRUCTURE = 'infrastructure'
}

export interface TaskRequirement {
  type: RequirementType;
  description: string;
  mandatory: boolean;
  validationCriteria: string[];
}

export enum RequirementType {
  FUNCTIONAL = 'functional',
  NON_FUNCTIONAL = 'non_functional',
  TECHNICAL = 'technical',
  BUSINESS = 'business',
  SECURITY = 'security',
  PERFORMANCE = 'performance'
}

export interface TaskConstraint {
  type: ConstraintType;
  description: string;
  impact: ConstraintImpact;
}

export enum ConstraintType {
  TIME = 'time',
  BUDGET = 'budget',
  TECHNOLOGY = 'technology',
  RESOURCE = 'resource',
  COMPLIANCE = 'compliance'
}

export interface ConstraintImpact {
  severity: ImpactSeverity;
  description: string;
  mitigation: string;
}

export enum ImpactSeverity {
  LOW = 'low',
  MEDIUM = 'medium',
  HIGH = 'high',
  BLOCKING = 'blocking'
}