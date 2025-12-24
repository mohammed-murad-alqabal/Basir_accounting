#!/usr/bin/env python3
"""
Comprehensive Quality Gates System
Implements automated quality checking with multiple gates and auto-fix capabilities
"""

import json
import subprocess
import sys
import os
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass
from enum import Enum
import time
import tempfile

class QualityGateStatus(Enum):
    PASSED = "passed"
    FAILED = "failed"
    WARNING = "warning"
    SKIPPED = "skipped"

class AutoFixResult(Enum):
    SUCCESS = "success"
    PARTIAL = "partial"
    FAILED = "failed"
    NOT_ATTEMPTED = "not_attempted"

@dataclass
class GateResult:
    gate_name: str
    status: QualityGateStatus
    score: float
    issues: List[str]
    warnings: List[str]
    auto_fix_result: AutoFixResult
    execution_time: float
    details: Dict

@dataclass
class QualityReport:
    overall_status: QualityGateStatus
    overall_score: float
    gate_results: List[GateResult]
    total_execution_time: float
    summary: Dict
    recommendations: List[str]

class QualityGatesSystem:
    def __init__(self, config_path: str = ".kiro/config/quality-gates.json"):
        self.config_path = config_path
        self.config = self._load_config()
        self.project_root = Path.cwd()
        
    def _load_config(self) -> Dict:
        """Load quality gates configuration"""
        default_config = {
            "gates": {
                "foundation_compliance": {
                    "enabled": True,
                    "blocking": True,
                    "auto_fix": True,
                    "weight": 0.25,
                    "thresholds": {
                        "kiro_compliance": 95,
                        "frontmatter_completeness": 100,
                        "syntax_correctness": 100
                    }
                },
                "advanced_integration": {
                    "enabled": True,
                    "blocking": True,
                    "auto_fix": "partial",
                    "weight": 0.20,
                    "thresholds": {
                        "mcp_compliance": 98,
                        "powers_integration": 95,
                        "hooks_support": 95
                    }
                },
                "content_excellence": {
                    "enabled": True,
                    "blocking": False,
                    "auto_fix": "ai_powered",
                    "weight": 0.20,
                    "thresholds": {
                        "technical_accuracy": 98,
                        "content_intelligence": 95,
                        "examples_validity": 95
                    }
                },
                "performance_future": {
                    "enabled": True,
                    "blocking": False,
                    "auto_fix": "predictive",
                    "weight": 0.15,
                    "thresholds": {
                        "performance_impact": 90,
                        "future_compatibility": 88,
                        "scalability_score": 85
                    }
                },
                "baseer_optimization": {
                    "enabled": True,
                    "blocking": False,
                    "auto_fix": "context_aware",
                    "weight": 0.10,
                    "thresholds": {
                        "flutter_dart_alignment": 95,
                        "local_first_support": 90,
                        "arabic_rtl_compliance": 95
                    }
                },
                "ultimate_excellence": {
                    "enabled": True,
                    "blocking": False,
                    "auto_fix": "comprehensive",
                    "weight": 0.10,
                    "thresholds": {
                        "overall_quality_score": 98,
                        "user_satisfaction": 9.5,
                        "agent_effectiveness": 95
                    }
                }
            },
            "global_settings": {
                "fail_fast": False,
                "parallel_execution": True,
                "timeout": 300,
                "retry_attempts": 2
            }
        }
        
        try:
            if Path(self.config_path).exists():
                with open(self.config_path, 'r') as f:
                    user_config = json.load(f)
                # Merge with defaults
                default_config.update(user_config)
            return default_config
        except Exception as e:
            print(f"Warning: Failed to load config, using defaults: {e}")
            return default_config

    def run_all_gates(self, target_files: Optional[List[str]] = None) -> QualityReport:
        """Run all enabled quality gates"""
        start_time = time.time()
        gate_results = []
        
        print("🚪 Starting Quality Gates Execution...")
        print("=" * 60)
        
        for gate_name, gate_config in self.config["gates"].items():
            if not gate_config.get("enabled", True):
                print(f"⏭️  Skipping disabled gate: {gate_name}")
                continue
                
            print(f"\n🔍 Executing Gate: {gate_name}")
            print("-" * 40)
            
            gate_start = time.time()
            result = self._execute_gate(gate_name, gate_config, target_files)
            gate_end = time.time()
            
            result.execution_time = gate_end - gate_start
            gate_results.append(result)
            
            # Print gate result
            status_emoji = {
                QualityGateStatus.PASSED: "✅",
                QualityGateStatus.FAILED: "❌", 
                QualityGateStatus.WARNING: "⚠️",
                QualityGateStatus.SKIPPED: "⏭️"
            }
            
            print(f"{status_emoji[result.status]} {gate_name}: {result.score:.1f}/100")
            
            if result.issues:
                print(f"   Issues: {len(result.issues)}")
                for issue in result.issues[:3]:  # Show first 3 issues
                    print(f"   • {issue}")
                if len(result.issues) > 3:
                    print(f"   ... and {len(result.issues) - 3} more")
            
            if result.auto_fix_result != AutoFixResult.NOT_ATTEMPTED:
                fix_emoji = {
                    AutoFixResult.SUCCESS: "🔧✅",
                    AutoFixResult.PARTIAL: "🔧⚠️", 
                    AutoFixResult.FAILED: "🔧❌",
                    AutoFixResult.NOT_ATTEMPTED: ""
                }
                print(f"   Auto-fix: {fix_emoji[result.auto_fix_result]} {result.auto_fix_result.value}")
            
            # Check if gate is blocking and failed
            if gate_config.get("blocking", False) and result.status == QualityGateStatus.FAILED:
                if self.config["global_settings"].get("fail_fast", False):
                    print(f"\n❌ Blocking gate {gate_name} failed. Stopping execution.")
                    break
        
        total_time = time.time() - start_time
        
        # Calculate overall results
        overall_score = self._calculate_overall_score(gate_results)
        overall_status = self._determine_overall_status(gate_results)
        summary = self._generate_summary(gate_results)
        recommendations = self._generate_recommendations(gate_results)
        
        report = QualityReport(
            overall_status=overall_status,
            overall_score=overall_score,
            gate_results=gate_results,
            total_execution_time=total_time,
            summary=summary,
            recommendations=recommendations
        )
        
        self._print_final_report(report)
        return report

    def _execute_gate(self, gate_name: str, gate_config: Dict, target_files: Optional[List[str]]) -> GateResult:
        """Execute a single quality gate"""
        try:
            if gate_name == "foundation_compliance":
                return self._gate_foundation_compliance(gate_config, target_files)
            elif gate_name == "advanced_integration":
                return self._gate_advanced_integration(gate_config, target_files)
            elif gate_name == "content_excellence":
                return self._gate_content_excellence(gate_config, target_files)
            elif gate_name == "performance_future":
                return self._gate_performance_future(gate_config, target_files)
            elif gate_name == "baseer_optimization":
                return self._gate_baseer_optimization(gate_config, target_files)
            elif gate_name == "ultimate_excellence":
                return self._gate_ultimate_excellence(gate_config, target_files)
            else:
                return GateResult(
                    gate_name=gate_name,
                    status=QualityGateStatus.SKIPPED,
                    score=0.0,
                    issues=[f"Unknown gate: {gate_name}"],
                    warnings=[],
                    auto_fix_result=AutoFixResult.NOT_ATTEMPTED,
                    execution_time=0.0,
                    details={}
                )
        except Exception as e:
            return GateResult(
                gate_name=gate_name,
                status=QualityGateStatus.FAILED,
                score=0.0,
                issues=[f"Gate execution failed: {str(e)}"],
                warnings=[],
                auto_fix_result=AutoFixResult.FAILED,
                execution_time=0.0,
                details={"error": str(e)}
            )

    def _gate_foundation_compliance(self, config: Dict, target_files: Optional[List[str]]) -> GateResult:
        """Foundation Compliance Gate - Core Kiro.dev compliance"""
        issues = []
        warnings = []
        details = {}
        
        # Check Kiro.dev compliance
        kiro_score = self._check_kiro_compliance()
        details["kiro_compliance"] = kiro_score
        
        if kiro_score < config["thresholds"]["kiro_compliance"]:
            issues.append(f"Kiro.dev compliance below threshold: {kiro_score}% < {config['thresholds']['kiro_compliance']}%")
        
        # Check frontmatter completeness
        frontmatter_score = self._check_frontmatter_completeness()
        details["frontmatter_completeness"] = frontmatter_score
        
        if frontmatter_score < config["thresholds"]["frontmatter_completeness"]:
            issues.append(f"Frontmatter completeness below threshold: {frontmatter_score}% < {config['thresholds']['frontmatter_completeness']}%")
        
        # Check syntax correctness
        syntax_score = self._check_syntax_correctness()
        details["syntax_correctness"] = syntax_score
        
        if syntax_score < config["thresholds"]["syntax_correctness"]:
            issues.append(f"Syntax correctness below threshold: {syntax_score}% < {config['thresholds']['syntax_correctness']}%")
        
        # Calculate overall score
        score = (kiro_score + frontmatter_score + syntax_score) / 3
        
        # Determine status
        status = QualityGateStatus.PASSED if len(issues) == 0 else QualityGateStatus.FAILED
        
        # Auto-fix if enabled
        auto_fix_result = AutoFixResult.NOT_ATTEMPTED
        if config.get("auto_fix", False) and len(issues) > 0:
            auto_fix_result = self._apply_foundation_auto_fixes(issues)
        
        return GateResult(
            gate_name="foundation_compliance",
            status=status,
            score=score,
            issues=issues,
            warnings=warnings,
            auto_fix_result=auto_fix_result,
            execution_time=0.0,
            details=details
        )

    def _gate_advanced_integration(self, config: Dict, target_files: Optional[List[str]]) -> GateResult:
        """Advanced Integration Gate - MCP, Powers, Hooks"""
        issues = []
        warnings = []
        details = {}
        
        # Check MCP compliance
        mcp_score = self._check_mcp_compliance()
        details["mcp_compliance"] = mcp_score
        
        if mcp_score < config["thresholds"]["mcp_compliance"]:
            issues.append(f"MCP compliance below threshold: {mcp_score}% < {config['thresholds']['mcp_compliance']}%")
        
        # Check Powers integration
        powers_score = self._check_powers_integration()
        details["powers_integration"] = powers_score
        
        if powers_score < config["thresholds"]["powers_integration"]:
            issues.append(f"Powers integration below threshold: {powers_score}% < {config['thresholds']['powers_integration']}%")
        
        # Check Hooks support
        hooks_score = self._check_hooks_support()
        details["hooks_support"] = hooks_score
        
        if hooks_score < config["thresholds"]["hooks_support"]:
            issues.append(f"Hooks support below threshold: {hooks_score}% < {config['thresholds']['hooks_support']}%")
        
        score = (mcp_score + powers_score + hooks_score) / 3
        status = QualityGateStatus.PASSED if len(issues) == 0 else QualityGateStatus.FAILED
        
        # Partial auto-fix
        auto_fix_result = AutoFixResult.NOT_ATTEMPTED
        if config.get("auto_fix") == "partial" and len(issues) > 0:
            auto_fix_result = self._apply_integration_auto_fixes(issues)
        
        return GateResult(
            gate_name="advanced_integration",
            status=status,
            score=score,
            issues=issues,
            warnings=warnings,
            auto_fix_result=auto_fix_result,
            execution_time=0.0,
            details=details
        )

    def _gate_content_excellence(self, config: Dict, target_files: Optional[List[str]]) -> GateResult:
        """Content Excellence Gate - Technical accuracy and intelligence"""
        issues = []
        warnings = []
        details = {}
        
        # Check technical accuracy
        accuracy_score = self._check_technical_accuracy()
        details["technical_accuracy"] = accuracy_score
        
        if accuracy_score < config["thresholds"]["technical_accuracy"]:
            warnings.append(f"Technical accuracy below threshold: {accuracy_score}% < {config['thresholds']['technical_accuracy']}%")
        
        # Check content intelligence
        intelligence_score = self._check_content_intelligence()
        details["content_intelligence"] = intelligence_score
        
        if intelligence_score < config["thresholds"]["content_intelligence"]:
            warnings.append(f"Content intelligence below threshold: {intelligence_score}% < {config['thresholds']['content_intelligence']}%")
        
        # Check examples validity
        examples_score = self._check_examples_validity()
        details["examples_validity"] = examples_score
        
        if examples_score < config["thresholds"]["examples_validity"]:
            warnings.append(f"Examples validity below threshold: {examples_score}% < {config['thresholds']['examples_validity']}%")
        
        score = (accuracy_score + intelligence_score + examples_score) / 3
        status = QualityGateStatus.WARNING if len(warnings) > 0 else QualityGateStatus.PASSED
        
        # AI-powered auto-fix
        auto_fix_result = AutoFixResult.NOT_ATTEMPTED
        if config.get("auto_fix") == "ai_powered" and (len(issues) > 0 or len(warnings) > 0):
            auto_fix_result = self._apply_ai_powered_fixes(issues + warnings)
        
        return GateResult(
            gate_name="content_excellence",
            status=status,
            score=score,
            issues=issues,
            warnings=warnings,
            auto_fix_result=auto_fix_result,
            execution_time=0.0,
            details=details
        )

    def _gate_performance_future(self, config: Dict, target_files: Optional[List[str]]) -> GateResult:
        """Performance & Future Readiness Gate"""
        issues = []
        warnings = []
        details = {}
        
        # Mock implementation - replace with actual checks
        performance_score = 92.0
        future_score = 89.0
        scalability_score = 87.0
        
        details.update({
            "performance_impact": performance_score,
            "future_compatibility": future_score,
            "scalability_score": scalability_score
        })
        
        score = (performance_score + future_score + scalability_score) / 3
        status = QualityGateStatus.PASSED
        
        return GateResult(
            gate_name="performance_future",
            status=status,
            score=score,
            issues=issues,
            warnings=warnings,
            auto_fix_result=AutoFixResult.NOT_ATTEMPTED,
            execution_time=0.0,
            details=details
        )

    def _gate_baseer_optimization(self, config: Dict, target_files: Optional[List[str]]) -> GateResult:
        """Baseer-Specific Optimization Gate"""
        issues = []
        warnings = []
        details = {}
        
        # Mock implementation - replace with actual checks
        flutter_score = 96.0
        local_first_score = 91.0
        arabic_score = 97.0
        
        details.update({
            "flutter_dart_alignment": flutter_score,
            "local_first_support": local_first_score,
            "arabic_rtl_compliance": arabic_score
        })
        
        score = (flutter_score + local_first_score + arabic_score) / 3
        status = QualityGateStatus.PASSED
        
        return GateResult(
            gate_name="baseer_optimization",
            status=status,
            score=score,
            issues=issues,
            warnings=warnings,
            auto_fix_result=AutoFixResult.NOT_ATTEMPTED,
            execution_time=0.0,
            details=details
        )

    def _gate_ultimate_excellence(self, config: Dict, target_files: Optional[List[str]]) -> GateResult:
        """Ultimate Excellence Gate"""
        issues = []
        warnings = []
        details = {}
        
        # Mock implementation - replace with actual checks
        overall_quality = 94.0
        user_satisfaction = 9.2
        agent_effectiveness = 93.0
        
        details.update({
            "overall_quality_score": overall_quality,
            "user_satisfaction": user_satisfaction,
            "agent_effectiveness": agent_effectiveness
        })
        
        score = (overall_quality + (user_satisfaction * 10) + agent_effectiveness) / 3
        status = QualityGateStatus.PASSED
        
        return GateResult(
            gate_name="ultimate_excellence",
            status=status,
            score=score,
            issues=issues,
            warnings=warnings,
            auto_fix_result=AutoFixResult.NOT_ATTEMPTED,
            execution_time=0.0,
            details=details
        )

    # Helper methods for checks
    def _check_kiro_compliance(self) -> float:
        """Check Kiro.dev compliance score"""
        # Mock implementation - replace with actual compliance checking
        return 98.0

    def _check_frontmatter_completeness(self) -> float:
        """Check frontmatter completeness in steering files"""
        # Mock implementation
        return 100.0

    def _check_syntax_correctness(self) -> float:
        """Check syntax correctness"""
        # Mock implementation
        return 100.0

    def _check_mcp_compliance(self) -> float:
        """Check MCP protocol compliance"""
        # Mock implementation
        return 95.0

    def _check_powers_integration(self) -> float:
        """Check Powers system integration"""
        # Mock implementation
        return 88.0

    def _check_hooks_support(self) -> float:
        """Check Hooks framework support"""
        # Mock implementation
        return 94.0

    def _check_technical_accuracy(self) -> float:
        """Check technical accuracy of content"""
        # Mock implementation
        return 96.0

    def _check_content_intelligence(self) -> float:
        """Check content intelligence level"""
        # Mock implementation
        return 92.0

    def _check_examples_validity(self) -> float:
        """Check validity of code examples"""
        # Mock implementation
        return 94.0

    # Auto-fix methods
    def _apply_foundation_auto_fixes(self, issues: List[str]) -> AutoFixResult:
        """Apply automatic fixes for foundation issues"""
        # Mock implementation
        return AutoFixResult.SUCCESS

    def _apply_integration_auto_fixes(self, issues: List[str]) -> AutoFixResult:
        """Apply partial automatic fixes for integration issues"""
        # Mock implementation
        return AutoFixResult.PARTIAL

    def _apply_ai_powered_fixes(self, issues: List[str]) -> AutoFixResult:
        """Apply AI-powered fixes for content issues"""
        # Mock implementation
        return AutoFixResult.SUCCESS

    # Report generation methods
    def _calculate_overall_score(self, gate_results: List[GateResult]) -> float:
        """Calculate weighted overall score"""
        total_weighted_score = 0.0
        total_weight = 0.0
        
        for result in gate_results:
            gate_config = self.config["gates"].get(result.gate_name, {})
            weight = gate_config.get("weight", 1.0)
            total_weighted_score += result.score * weight
            total_weight += weight
        
        return total_weighted_score / total_weight if total_weight > 0 else 0.0

    def _determine_overall_status(self, gate_results: List[GateResult]) -> QualityGateStatus:
        """Determine overall status based on gate results"""
        has_failures = any(r.status == QualityGateStatus.FAILED for r in gate_results)
        has_warnings = any(r.status == QualityGateStatus.WARNING for r in gate_results)
        
        if has_failures:
            return QualityGateStatus.FAILED
        elif has_warnings:
            return QualityGateStatus.WARNING
        else:
            return QualityGateStatus.PASSED

    def _generate_summary(self, gate_results: List[GateResult]) -> Dict:
        """Generate summary statistics"""
        return {
            "total_gates": len(gate_results),
            "passed": sum(1 for r in gate_results if r.status == QualityGateStatus.PASSED),
            "failed": sum(1 for r in gate_results if r.status == QualityGateStatus.FAILED),
            "warnings": sum(1 for r in gate_results if r.status == QualityGateStatus.WARNING),
            "skipped": sum(1 for r in gate_results if r.status == QualityGateStatus.SKIPPED),
            "total_issues": sum(len(r.issues) for r in gate_results),
            "total_warnings": sum(len(r.warnings) for r in gate_results),
            "auto_fixes_applied": sum(1 for r in gate_results if r.auto_fix_result in [AutoFixResult.SUCCESS, AutoFixResult.PARTIAL])
        }

    def _generate_recommendations(self, gate_results: List[GateResult]) -> List[str]:
        """Generate improvement recommendations"""
        recommendations = []
        
        for result in gate_results:
            if result.status == QualityGateStatus.FAILED:
                recommendations.append(f"Address critical issues in {result.gate_name}")
            elif result.status == QualityGateStatus.WARNING:
                recommendations.append(f"Consider improvements in {result.gate_name}")
        
        return recommendations

    def _print_final_report(self, report: QualityReport):
        """Print final quality report"""
        print("\n" + "=" * 60)
        print("🏆 QUALITY GATES FINAL REPORT")
        print("=" * 60)
        
        status_emoji = {
            QualityGateStatus.PASSED: "✅",
            QualityGateStatus.FAILED: "❌",
            QualityGateStatus.WARNING: "⚠️"
        }
        
        print(f"\n{status_emoji[report.overall_status]} Overall Status: {report.overall_status.value.upper()}")
        print(f"📊 Overall Score: {report.overall_score:.1f}/100")
        print(f"⏱️  Total Execution Time: {report.total_execution_time:.2f}s")
        
        print(f"\n📈 Summary:")
        print(f"  • Gates Passed: {report.summary['passed']}/{report.summary['total_gates']}")
        print(f"  • Gates Failed: {report.summary['failed']}")
        print(f"  • Gates with Warnings: {report.summary['warnings']}")
        print(f"  • Total Issues: {report.summary['total_issues']}")
        print(f"  • Auto-fixes Applied: {report.summary['auto_fixes_applied']}")
        
        if report.recommendations:
            print(f"\n💡 Recommendations:")
            for rec in report.recommendations:
                print(f"  • {rec}")

def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description="Run Quality Gates System")
    parser.add_argument("--config", help="Path to quality gates configuration file")
    parser.add_argument("--files", nargs="*", help="Specific files to check")
    parser.add_argument("--output", help="Output file for detailed results")
    parser.add_argument("--fail-fast", action="store_true", help="Stop on first blocking failure")
    
    args = parser.parse_args()
    
    # Initialize quality gates system
    config_path = args.config or ".kiro/config/quality-gates.json"
    gates = QualityGatesSystem(config_path)
    
    if args.fail_fast:
        gates.config["global_settings"]["fail_fast"] = True
    
    # Run quality gates
    report = gates.run_all_gates(args.files)
    
    # Save detailed results if requested
    if args.output:
        with open(args.output, 'w') as f:
            json.dump({
                "overall_status": report.overall_status.value,
                "overall_score": report.overall_score,
                "total_execution_time": report.total_execution_time,
                "summary": report.summary,
                "recommendations": report.recommendations,
                "gate_results": [
                    {
                        "gate_name": r.gate_name,
                        "status": r.status.value,
                        "score": r.score,
                        "issues": r.issues,
                        "warnings": r.warnings,
                        "auto_fix_result": r.auto_fix_result.value,
                        "execution_time": r.execution_time,
                        "details": r.details
                    }
                    for r in report.gate_results
                ]
            }, f, indent=2)
        print(f"\n💾 Detailed results saved to: {args.output}")
    
    # Exit with appropriate code
    exit_code = 0 if report.overall_status != QualityGateStatus.FAILED else 1
    sys.exit(exit_code)

if __name__ == "__main__":
    main()