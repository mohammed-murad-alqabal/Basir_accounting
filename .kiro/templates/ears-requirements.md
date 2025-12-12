# EARS Requirements Template - Enhanced with Zero-Trust & DORA/SPACE

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 11 ديسمبر 2025  
**الحالة:** 📋 **Enhanced template integrating EARS + Zero-Trust + DORA/SPACE metrics**

---

## Strategic Integration

This enhanced EARS template integrates:

- **Zero-Trust Security**: "Never trust, always verify" principles
- **DORA Metrics**: Deployment frequency, lead time, change failure rate, recovery time
- **SPACE Framework**: Satisfaction, Performance, Activity, Communication, Efficiency

---

## EARS Pattern Reference

### The Six EARS Patterns

1. **Ubiquitous**: THE `<system>` SHALL `<response>`
2. **Event-driven**: WHEN `<trigger>`, THE `<system>` SHALL `<response>`
3. **State-driven**: WHILE `<condition>`, THE `<system>` SHALL `<response>`
4. **Unwanted event**: IF `<condition>`, THEN THE `<system>` SHALL `<response>`
5. **Optional feature**: WHERE `<option>`, THE `<system>` SHALL `<response>`
6. **Complex**: [WHERE] [WHILE] [WHEN/IF] THE `<system>` SHALL `<response>`

---

## Enhanced Template Structure

```markdown
# Requirements Document - [Feature Name]

**المشروع:** [Project Name]  
**التاريخ:** [Date]  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** [Status]

---

## Strategic Alignment

### DORA Impact Assessment

- **Deployment Frequency**: [How this feature affects deployment cadence]
- **Lead Time**: [Expected impact on change lead time]
- **Change Failure Rate**: [Risk mitigation strategies]
- **Recovery Time**: [Rollback and recovery considerations]

### SPACE Framework Impact

- **Satisfaction**: [Developer experience improvements]
- **Performance**: [Quality and reliability enhancements]
- **Activity**: [Development workflow changes]
- **Communication**: [Information flow improvements]
- **Efficiency**: [Friction reduction measures]

### Security Classification

- **Data Classification**: [Public/Internal/Confidential/Restricted]
- **Zero-Trust Level**: [Verification requirements]
- **Compliance Requirements**: [Regulatory/organizational standards]

---

## Introduction

[Brief description of the feature/system being specified]

## Glossary

- **[System_Name]**: [Definition of the main system]
- **[Technical_Term]**: [Definition]
- **[Business_Term]**: [Definition]
- **Zero-Trust Verification**: Continuous identity and device validation
- **Supply Chain Security**: Verification of all dependencies and artifacts

---

## Requirements

### Requirement 1: [Requirement Name]

**User Story:** As a [role], I want [feature], so that [benefit]

#### Acceptance Criteria

1. WHEN [trigger event], THE [System_Name] SHALL [specific response]
2. WHILE [ongoing condition], THE [System_Name] SHALL [continuous behavior]
3. IF [error condition], THEN THE [System_Name] SHALL [error response]
4. WHERE [optional feature enabled], THE [System_Name] SHALL [optional behavior]
5. THE [System_Name] SHALL [ubiquitous requirement]

### Requirement 2: [Next Requirement Name]

**User Story:** As a [role], I want [feature], so that [benefit]

#### Acceptance Criteria

1. [EARS pattern] [System_Name] SHALL [requirement]
2. [EARS pattern] [System_Name] SHALL [requirement]
3. [EARS pattern] [System_Name] SHALL [requirement]

[Continue for all requirements...]

---

## Zero-Trust Security Requirements

### Authentication & Authorization

1. WHEN a user attempts system access, THE [System_Name] SHALL verify identity using multi-factor authentication
2. WHILE user session is active, THE [System_Name] SHALL continuously validate permissions and device trust
3. IF user device trust score falls below threshold, THEN THE [System_Name] SHALL require re-authentication
4. WHERE privileged operations are requested, THE [System_Name] SHALL require additional verification

### Data Protection

1. THE [System_Name] SHALL encrypt all data at rest using AES-256 or stronger
2. THE [System_Name] SHALL encrypt all data in transit using TLS 1.3 or stronger
3. WHEN sensitive data is accessed, THE [System_Name] SHALL log access with user identity and timestamp
4. IF data breach is detected, THEN THE [System_Name] SHALL immediately revoke access and alert security team

### Supply Chain Security

1. WHEN dependency is added, THE [System_Name] SHALL scan for known vulnerabilities
2. IF vulnerability with CVSS > 7.0 is found, THEN THE [System_Name] SHALL block integration
3. THE [System_Name] SHALL sign all build artifacts with organization's private key
4. WHEN deploying artifacts, THE [System_Name] SHALL verify signatures before execution

---

## DORA Metrics Requirements

### Deployment Optimization

1. WHEN code is committed to main branch, THE [System_Name] SHALL trigger automated testing within 30 seconds
2. IF all tests pass, THEN THE [System_Name] SHALL deploy to staging within 5 minutes
3. WHILE deployment is in progress, THE [System_Name] SHALL provide real-time status updates
4. THE [System_Name] SHALL support rollback to previous version within 2 minutes

### Quality Assurance

1. IF deployment fails, THEN THE [System_Name] SHALL automatically rollback and notify on-call engineer
2. THE [System_Name] SHALL maintain change failure rate below 15%
3. WHEN critical issue is detected, THE [System_Name] SHALL alert within 1 minute
4. THE [System_Name] SHALL track and report lead time for all changes

---

## Success Criteria

### Quantitative Metrics

- [Measurable metric]: [Target value]
- [Performance metric]: [Target value]
- [Quality metric]: [Target value]

### Qualitative Metrics

- ✅ [Qualitative goal]
- ✅ [User experience goal]
- ✅ [Business goal]

---

## Integration Requirements

[How this feature integrates with existing systems]

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** [Date]  
**الحالة:** ✅ [Status]
```

---

## EARS Compliance Checklist

### ✅ Pattern Compliance

- [ ] Each requirement follows exactly one EARS pattern
- [ ] Complex requirements follow correct clause order: WHERE → WHILE → WHEN/IF → THE → SHALL
- [ ] No requirements mix multiple patterns incorrectly

### ✅ INCOSE Quality Rules

- [ ] Active voice used (who does what)
- [ ] No vague terms ("quickly", "adequate", "user-friendly")
- [ ] No escape clauses ("where possible", "as appropriate")
- [ ] No negative statements ("SHALL not...")
- [ ] One thought per requirement
- [ ] Explicit and measurable conditions
- [ ] Consistent terminology throughout
- [ ] No pronouns ("it", "them", "they")
- [ ] No absolutes ("never", "always", "100%")
- [ ] Solution-free (focus on what, not how)
- [ ] Realistic tolerances for timing and performance

### ✅ System Definition

- [ ] System name clearly defined in Glossary
- [ ] All technical terms defined
- [ ] Consistent system naming throughout
- [ ] Clear system boundaries established

---

## Common EARS Examples

### Event-Driven Examples

```
WHEN a user clicks the submit button, THE System SHALL validate all form fields
WHEN a payment is processed successfully, THE System SHALL send a confirmation email
WHEN system load exceeds 80%, THE System SHALL scale up additional instances
```

### State-Driven Examples

```
WHILE a user is logged in, THE System SHALL maintain session state
WHILE processing a transaction, THE System SHALL prevent duplicate submissions
WHILE in maintenance mode, THE System SHALL display maintenance message
```

### Error Handling Examples

```
IF a network connection fails, THEN THE System SHALL retry up to 3 times
IF invalid data is submitted, THEN THE System SHALL display specific error messages
IF authentication fails, THEN THE System SHALL log the attempt and block access
```

### Optional Feature Examples

```
WHERE premium features are enabled, THE System SHALL provide advanced analytics
WHERE multi-language support is configured, THE System SHALL display localized content
WHERE API access is granted, THE System SHALL provide rate-limited endpoints
```

---

## Validation Tools

### Automated Checks

- Pattern recognition for EARS compliance
- Terminology consistency validation
- Requirement completeness verification
- Cross-reference validation

### Manual Review

- Business stakeholder review
- Technical feasibility assessment
- Testability evaluation
- Completeness verification
