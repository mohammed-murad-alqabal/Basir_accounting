#!/usr/bin/env python3
"""
EARS (Easy Approach to Requirements Syntax) Validator
Validates requirements documents for EARS compliance and INCOSE quality rules
"""

import re
import json
import sys
from pathlib import Path
from typing import List, Dict, Tuple, Optional
from dataclasses import dataclass
from enum import Enum

class EARSPattern(Enum):
    UBIQUITOUS = "ubiquitous"
    EVENT_DRIVEN = "event_driven"
    STATE_DRIVEN = "state_driven" 
    UNWANTED_EVENT = "unwanted_event"
    OPTIONAL_FEATURE = "optional_feature"
    COMPLEX = "complex"

@dataclass
class ValidationResult:
    is_valid: bool
    pattern: Optional[EARSPattern]
    issues: List[str]
    suggestions: List[str]
    quality_score: float

@dataclass
class RequirementAnalysis:
    text: str
    validation: ValidationResult
    incose_compliance: Dict[str, bool]
    testability_score: float

class EARSValidator:
    def __init__(self):
        self.ears_patterns = {
            EARSPattern.UBIQUITOUS: r'^THE\s+(\w+)\s+SHALL\s+(.+)$',
            EARSPattern.EVENT_DRIVEN: r'^WHEN\s+(.+),\s*THE\s+(\w+)\s+SHALL\s+(.+)$',
            EARSPattern.STATE_DRIVEN: r'^WHILE\s+(.+),\s*THE\s+(\w+)\s+SHALL\s+(.+)$',
            EARSPattern.UNWANTED_EVENT: r'^IF\s+(.+),\s*THEN\s+THE\s+(\w+)\s+SHALL\s+(.+)$',
            EARSPattern.OPTIONAL_FEATURE: r'^WHERE\s+(.+),\s*THE\s+(\w+)\s+SHALL\s+(.+)$',
            EARSPattern.COMPLEX: r'^(?:WHERE\s+(.+?))?\s*(?:WHILE\s+(.+?))?\s*(?:(?:WHEN|IF)\s+(.+?))?\s*THE\s+(\w+)\s+SHALL\s+(.+)$'
        }
        
        self.vague_terms = [
            'quickly', 'slowly', 'fast', 'adequate', 'sufficient', 'appropriate',
            'user-friendly', 'easy', 'simple', 'complex', 'reasonable', 'normal',
            'typical', 'standard', 'good', 'bad', 'better', 'worse', 'optimal'
        ]
        
        self.escape_clauses = [
            'where possible', 'if feasible', 'as appropriate', 'when necessary',
            'if required', 'as needed', 'where applicable', 'if practical'
        ]
        
        self.absolutes = [
            'never', 'always', 'all', 'none', 'every', 'completely', 'totally',
            '100%', 'zero', 'infinite', 'unlimited', 'perfect'
        ]

    def validate_requirement(self, requirement_text: str) -> ValidationResult:
        """Validate a single requirement against EARS patterns"""
        issues = []
        suggestions = []
        pattern = None
        
        # Clean and normalize the requirement text
        cleaned_text = self._clean_requirement_text(requirement_text)
        
        # Check for EARS pattern compliance
        pattern, pattern_issues = self._check_ears_pattern(cleaned_text)
        issues.extend(pattern_issues)
        
        # Check INCOSE quality rules
        incose_issues = self._check_incose_quality(cleaned_text)
        issues.extend(incose_issues)
        
        # Generate suggestions
        suggestions = self._generate_suggestions(cleaned_text, pattern, issues)
        
        # Calculate quality score
        quality_score = self._calculate_quality_score(pattern, issues)
        
        return ValidationResult(
            is_valid=len(issues) == 0,
            pattern=pattern,
            issues=issues,
            suggestions=suggestions,
            quality_score=quality_score
        )

    def _clean_requirement_text(self, text: str) -> str:
        """Clean and normalize requirement text"""
        # Remove markdown formatting
        text = re.sub(r'\*\*(.+?)\*\*', r'\1', text)
        text = re.sub(r'\*(.+?)\*', r'\1', text)
        text = re.sub(r'`(.+?)`', r'\1', text)
        
        # Remove numbering
        text = re.sub(r'^\d+\.\s*', '', text)
        
        # Normalize whitespace
        text = ' '.join(text.split())
        
        return text.strip()

    def _check_ears_pattern(self, text: str) -> Tuple[Optional[EARSPattern], List[str]]:
        """Check if text matches any EARS pattern"""
        issues = []
        
        for pattern, regex in self.ears_patterns.items():
            if re.match(regex, text, re.IGNORECASE):
                # Validate complex pattern clause order
                if pattern == EARSPattern.COMPLEX:
                    order_issues = self._validate_complex_pattern_order(text)
                    issues.extend(order_issues)
                return pattern, issues
        
        issues.append("Requirement does not follow any EARS pattern")
        issues.append("Must start with WHEN/WHILE/IF/WHERE/THE and contain SHALL")
        
        return None, issues

    def _validate_complex_pattern_order(self, text: str) -> List[str]:
        """Validate clause order in complex EARS patterns"""
        issues = []
        
        # Expected order: WHERE → WHILE → WHEN/IF → THE → SHALL
        where_pos = text.upper().find('WHERE')
        while_pos = text.upper().find('WHILE')
        when_pos = max(text.upper().find('WHEN'), text.upper().find('IF'))
        the_pos = text.upper().find('THE')
        shall_pos = text.upper().find('SHALL')
        
        positions = []
        if where_pos != -1:
            positions.append(('WHERE', where_pos))
        if while_pos != -1:
            positions.append(('WHILE', while_pos))
        if when_pos != -1:
            positions.append(('WHEN/IF', when_pos))
        if the_pos != -1:
            positions.append(('THE', the_pos))
        if shall_pos != -1:
            positions.append(('SHALL', shall_pos))
        
        # Check if positions are in correct order
        positions.sort(key=lambda x: x[1])
        expected_order = ['WHERE', 'WHILE', 'WHEN/IF', 'THE', 'SHALL']
        
        actual_order = [pos[0] for pos in positions]
        filtered_expected = [clause for clause in expected_order if clause in actual_order]
        
        if actual_order != filtered_expected:
            issues.append(f"Complex pattern clause order incorrect. Expected: {' → '.join(filtered_expected)}, Got: {' → '.join(actual_order)}")
        
        return issues

    def _check_incose_quality(self, text: str) -> List[str]:
        """Check INCOSE semantic quality rules"""
        issues = []
        
        # Check for vague terms
        for term in self.vague_terms:
            if re.search(r'\b' + re.escape(term) + r'\b', text, re.IGNORECASE):
                issues.append(f"Contains vague term: '{term}' - use specific, measurable criteria")
        
        # Check for escape clauses
        for clause in self.escape_clauses:
            if clause.lower() in text.lower():
                issues.append(f"Contains escape clause: '{clause}' - requirements must be definitive")
        
        # Check for negative statements
        if re.search(r'\bSHALL\s+NOT\b', text, re.IGNORECASE):
            issues.append("Uses negative statement (SHALL NOT) - prefer positive statements")
        
        # Check for pronouns
        pronouns = ['it', 'they', 'them', 'this', 'that', 'these', 'those']
        for pronoun in pronouns:
            if re.search(r'\b' + pronoun + r'\b', text, re.IGNORECASE):
                issues.append(f"Contains pronoun '{pronoun}' - use specific nouns instead")
        
        # Check for absolutes (with exceptions for technical terms)
        for absolute in self.absolutes:
            if re.search(r'\b' + re.escape(absolute) + r'\b', text, re.IGNORECASE):
                # Allow some technical absolutes
                if absolute not in ['zero', '100%'] or not self._is_technical_context(text, absolute):
                    issues.append(f"Contains absolute term: '{absolute}' - consider if truly absolute")
        
        # Check for passive voice
        if self._has_passive_voice(text):
            issues.append("Uses passive voice - prefer active voice (who does what)")
        
        # Check for multiple thoughts
        if self._has_multiple_thoughts(text):
            issues.append("Contains multiple thoughts - split into separate requirements")
        
        return issues

    def _is_technical_context(self, text: str, term: str) -> bool:
        """Check if absolute term is used in technical context"""
        technical_contexts = [
            'error rate', 'success rate', 'accuracy', 'precision',
            'temperature', 'voltage', 'frequency', 'count'
        ]
        
        for context in technical_contexts:
            if context in text.lower():
                return True
        return False

    def _has_passive_voice(self, text: str) -> bool:
        """Detect passive voice patterns"""
        passive_patterns = [
            r'\bis\s+\w+ed\b',
            r'\bare\s+\w+ed\b', 
            r'\bwas\s+\w+ed\b',
            r'\bwere\s+\w+ed\b',
            r'\bbeen\s+\w+ed\b',
            r'\bbe\s+\w+ed\b'
        ]
        
        for pattern in passive_patterns:
            if re.search(pattern, text, re.IGNORECASE):
                return True
        return False

    def _has_multiple_thoughts(self, text: str) -> bool:
        """Check if requirement contains multiple thoughts"""
        # Look for conjunctions that might indicate multiple thoughts
        conjunctions = [' and ', ' or ', ' but ', ' however ', ' also ', ' additionally ']
        
        conjunction_count = sum(1 for conj in conjunctions if conj.lower() in text.lower())
        
        # More than 2 conjunctions likely indicates multiple thoughts
        return conjunction_count > 2

    def _generate_suggestions(self, text: str, pattern: Optional[EARSPattern], issues: List[str]) -> List[str]:
        """Generate improvement suggestions"""
        suggestions = []
        
        if not pattern:
            suggestions.append("Rewrite using one of the EARS patterns:")
            suggestions.append("- Ubiquitous: THE <system> SHALL <response>")
            suggestions.append("- Event-driven: WHEN <trigger>, THE <system> SHALL <response>")
            suggestions.append("- State-driven: WHILE <condition>, THE <system> SHALL <response>")
            suggestions.append("- Unwanted event: IF <condition>, THEN THE <system> SHALL <response>")
            suggestions.append("- Optional: WHERE <option>, THE <system> SHALL <response>")
        
        # Suggest specific improvements based on issues
        for issue in issues:
            if "vague term" in issue:
                suggestions.append("Replace vague terms with specific, measurable criteria")
            elif "escape clause" in issue:
                suggestions.append("Remove escape clauses and make requirements definitive")
            elif "pronoun" in issue:
                suggestions.append("Replace pronouns with specific system/component names")
            elif "passive voice" in issue:
                suggestions.append("Rewrite in active voice: specify who performs the action")
            elif "multiple thoughts" in issue:
                suggestions.append("Split into separate requirements, one thought per requirement")
        
        return suggestions

    def _calculate_quality_score(self, pattern: Optional[EARSPattern], issues: List[str]) -> float:
        """Calculate quality score (0-100)"""
        base_score = 100.0
        
        # Deduct points for issues
        if not pattern:
            base_score -= 40  # Major deduction for no EARS pattern
        
        # Deduct points for each issue
        for issue in issues:
            if "vague term" in issue or "escape clause" in issue:
                base_score -= 15  # Major quality issues
            elif "pronoun" in issue or "passive voice" in issue:
                base_score -= 10  # Moderate quality issues
            else:
                base_score -= 5   # Minor quality issues
        
        return max(0.0, base_score)

    def validate_document(self, file_path: str) -> Dict:
        """Validate entire requirements document"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            return {"error": f"Failed to read file: {e}"}
        
        # Extract requirements from markdown
        requirements = self._extract_requirements(content)
        
        # Validate each requirement
        results = []
        total_score = 0
        
        for req_text in requirements:
            analysis = RequirementAnalysis(
                text=req_text,
                validation=self.validate_requirement(req_text),
                incose_compliance=self._check_incose_compliance_detailed(req_text),
                testability_score=self._assess_testability(req_text)
            )
            results.append(analysis)
            total_score += analysis.validation.quality_score
        
        # Calculate overall metrics
        avg_score = total_score / len(requirements) if requirements else 0
        compliance_rate = sum(1 for r in results if r.validation.is_valid) / len(requirements) if requirements else 0
        
        return {
            "file_path": file_path,
            "total_requirements": len(requirements),
            "valid_requirements": sum(1 for r in results if r.validation.is_valid),
            "compliance_rate": compliance_rate * 100,
            "average_quality_score": avg_score,
            "overall_grade": self._calculate_grade(avg_score),
            "requirements_analysis": [
                {
                    "text": r.text[:100] + "..." if len(r.text) > 100 else r.text,
                    "pattern": r.validation.pattern.value if r.validation.pattern else None,
                    "is_valid": r.validation.is_valid,
                    "quality_score": r.validation.quality_score,
                    "issues": r.validation.issues,
                    "suggestions": r.validation.suggestions,
                    "testability_score": r.testability_score
                }
                for r in results
            ],
            "summary": {
                "excellent": sum(1 for r in results if r.validation.quality_score >= 90),
                "good": sum(1 for r in results if 70 <= r.validation.quality_score < 90),
                "needs_improvement": sum(1 for r in results if r.validation.quality_score < 70),
                "common_issues": self._identify_common_issues(results)
            }
        }

    def _extract_requirements(self, content: str) -> List[str]:
        """Extract requirement statements from markdown content"""
        requirements = []
        
        # Look for numbered lists that contain SHALL
        lines = content.split('\n')
        current_requirement = ""
        
        for line in lines:
            line = line.strip()
            
            # Check if line starts a new requirement
            if re.match(r'^\d+\.\s+', line) and 'SHALL' in line.upper():
                if current_requirement:
                    requirements.append(current_requirement.strip())
                current_requirement = re.sub(r'^\d+\.\s+', '', line)
            elif current_requirement and line and not line.startswith('#'):
                # Continue multi-line requirement
                current_requirement += " " + line
            elif current_requirement and (not line or line.startswith('#')):
                # End of requirement
                requirements.append(current_requirement.strip())
                current_requirement = ""
        
        # Add last requirement if exists
        if current_requirement:
            requirements.append(current_requirement.strip())
        
        return requirements

    def _check_incose_compliance_detailed(self, text: str) -> Dict[str, bool]:
        """Detailed INCOSE compliance check"""
        return {
            "active_voice": not self._has_passive_voice(text),
            "no_vague_terms": not any(term in text.lower() for term in self.vague_terms),
            "no_escape_clauses": not any(clause in text.lower() for clause in self.escape_clauses),
            "no_negatives": "shall not" not in text.lower(),
            "single_thought": not self._has_multiple_thoughts(text),
            "no_pronouns": not any(re.search(r'\b' + pronoun + r'\b', text, re.IGNORECASE) 
                                 for pronoun in ['it', 'they', 'them', 'this', 'that']),
            "no_absolutes": not any(absolute in text.lower() for absolute in self.absolutes)
        }

    def _assess_testability(self, text: str) -> float:
        """Assess how testable a requirement is"""
        score = 100.0
        
        # Deduct for vague terms
        if any(term in text.lower() for term in self.vague_terms):
            score -= 30
        
        # Deduct for missing measurable criteria
        if not re.search(r'\d+', text):  # No numbers
            score -= 20
        
        # Deduct for escape clauses
        if any(clause in text.lower() for clause in self.escape_clauses):
            score -= 25
        
        # Bonus for specific verbs
        specific_verbs = ['display', 'calculate', 'validate', 'generate', 'store', 'retrieve']
        if any(verb in text.lower() for verb in specific_verbs):
            score += 10
        
        return max(0.0, min(100.0, score))

    def _calculate_grade(self, score: float) -> str:
        """Calculate letter grade from score"""
        if score >= 90:
            return "A"
        elif score >= 80:
            return "B"
        elif score >= 70:
            return "C"
        elif score >= 60:
            return "D"
        else:
            return "F"

    def _identify_common_issues(self, results: List[RequirementAnalysis]) -> List[str]:
        """Identify most common issues across all requirements"""
        issue_counts = {}
        
        for result in results:
            for issue in result.validation.issues:
                # Categorize issues
                if "vague term" in issue:
                    issue_counts["Vague terminology"] = issue_counts.get("Vague terminology", 0) + 1
                elif "escape clause" in issue:
                    issue_counts["Escape clauses"] = issue_counts.get("Escape clauses", 0) + 1
                elif "pronoun" in issue:
                    issue_counts["Pronoun usage"] = issue_counts.get("Pronoun usage", 0) + 1
                elif "passive voice" in issue:
                    issue_counts["Passive voice"] = issue_counts.get("Passive voice", 0) + 1
                elif "EARS pattern" in issue:
                    issue_counts["EARS pattern compliance"] = issue_counts.get("EARS pattern compliance", 0) + 1
        
        # Return top 5 most common issues
        return sorted(issue_counts.items(), key=lambda x: x[1], reverse=True)[:5]

def main():
    if len(sys.argv) != 2:
        print("Usage: python ears-validator.py <requirements_file.md>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    
    if not Path(file_path).exists():
        print(f"Error: File {file_path} not found")
        sys.exit(1)
    
    validator = EARSValidator()
    results = validator.validate_document(file_path)
    
    if "error" in results:
        print(f"Error: {results['error']}")
        sys.exit(1)
    
    # Print results
    print(f"\n📋 EARS Validation Report for {file_path}")
    print("=" * 60)
    print(f"Total Requirements: {results['total_requirements']}")
    print(f"Valid Requirements: {results['valid_requirements']}")
    print(f"Compliance Rate: {results['compliance_rate']:.1f}%")
    print(f"Average Quality Score: {results['average_quality_score']:.1f}/100")
    print(f"Overall Grade: {results['overall_grade']}")
    
    print(f"\n📊 Quality Distribution:")
    print(f"Excellent (90+): {results['summary']['excellent']}")
    print(f"Good (70-89): {results['summary']['good']}")
    print(f"Needs Improvement (<70): {results['summary']['needs_improvement']}")
    
    if results['summary']['common_issues']:
        print(f"\n⚠️ Most Common Issues:")
        for issue, count in results['summary']['common_issues']:
            print(f"  • {issue}: {count} occurrences")
    
    # Save detailed results to JSON
    output_file = file_path.replace('.md', '_ears_validation.json')
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    
    print(f"\n💾 Detailed results saved to: {output_file}")
    
    # Exit with appropriate code
    sys.exit(0 if results['compliance_rate'] >= 80 else 1)

if __name__ == "__main__":
    main()