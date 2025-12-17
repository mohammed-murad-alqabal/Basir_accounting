# EARS Requirements Template

**المشروع:** {project_name}  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** {current_date}  
**الحالة:** 🚀 للمراجعة والموافقة

---

## Introduction

{feature_description}

## Glossary

- **{System_Name}**: {system_definition}
- **{Technical_Term}**: {term_definition}
- **{Business_Term}**: {business_definition}

---

## Requirements

### Requirement 1: {requirement_name}

**User Story:** As a {role}, I want {feature}, so that {benefit}.

#### Acceptance Criteria

1. **Ubiquitous Pattern**: THE {System_Name} SHALL {response}

   - _Example: THE Invoice_System SHALL validate all invoice data before saving_

2. **Event-driven Pattern**: WHEN {trigger}, THE {System_Name} SHALL {response}

   - _Example: WHEN a user submits an invoice, THE Invoice_System SHALL generate a unique invoice number_

3. **State-driven Pattern**: WHILE {condition}, THE {System_Name} SHALL {response}

   - _Example: WHILE an invoice is in draft status, THE Invoice_System SHALL allow modifications_

4. **Unwanted event Pattern**: IF {condition}, THEN THE {System_Name} SHALL {response}

   - _Example: IF invalid data is detected, THEN THE Invoice_System SHALL display validation errors_

5. **Optional feature Pattern**: WHERE {option}, THE {System_Name} SHALL {response}

   - _Example: WHERE Arabic language is selected, THE Invoice_System SHALL display RTL layout_

6. **Complex Pattern**: [WHERE {option}] [WHILE {condition}] [WHEN {trigger}/IF {condition}] THE {System_Name} SHALL {response}
   - _Example: WHERE multi-currency is enabled WHILE invoice is editable WHEN currency is changed THE Invoice_System SHALL recalculate totals_

### Requirement 2: {requirement_name}

**User Story:** As a {role}, I want {feature}, so that {benefit}.

#### Acceptance Criteria

1. WHEN {specific_trigger}, THE {System_Name} SHALL {specific_response}
2. WHILE {specific_condition}, THE {System_Name} SHALL {specific_response}
3. IF {error_condition}, THEN THE {System_Name} SHALL {error_response}
4. WHERE {optional_feature}, THE {System_Name} SHALL {optional_response}

---

## EARS Compliance Checklist

### Structural Compliance

- [ ] All requirements follow one of the six EARS patterns
- [ ] Complex requirements follow correct clause order: WHERE → WHILE → WHEN/IF → THE → SHALL
- [ ] System names are consistently defined and used
- [ ] All technical terms are defined in the Glossary

### Semantic Quality (INCOSE Rules)

- [ ] **Active Voice**: Each requirement clearly states who does what
- [ ] **No Vague Terms**: Avoided words like "quickly", "adequate", "user-friendly"
- [ ] **No Escape Clauses**: No phrases like "where possible", "if feasible"
- [ ] **No Negative Statements**: Used positive statements instead of "SHALL not"
- [ ] **One Thought**: Each requirement expresses exactly one requirement
- [ ] **Explicit Conditions**: All conditions and criteria are measurable
- [ ] **Consistent Terminology**: Same terms used throughout the document
- [ ] **No Pronouns**: Avoided "it", "them", "they" - used specific nouns
- [ ] **No Absolutes**: Avoided "never", "always", "100%" unless truly absolute
- [ ] **Solution-Free**: Focused on what, not how
- [ ] **Realistic Tolerances**: Specified achievable timing and performance criteria

### Content Quality

- [ ] **Testable**: Each acceptance criterion can be verified through testing
- [ ] **Complete**: All necessary functionality is covered
- [ ] **Consistent**: No conflicting requirements
- [ ] **Feasible**: All requirements are technically achievable
- [ ] **Necessary**: Each requirement adds value to the system

---

## Validation Templates

### For Event-driven Requirements

```
Test Case: {test_name}
Given: {initial_state}
When: {trigger_event}
Then: {expected_response}
Verification: {how_to_verify}
```

### For State-driven Requirements

```
Test Case: {test_name}
Given: {system_state}
While: {condition_maintained}
Then: {continuous_behavior}
Verification: {how_to_verify_continuous_behavior}
```

### For Complex Requirements

```
Test Case: {test_name}
Given: {initial_setup}
Where: {optional_feature_enabled}
While: {state_condition}
When: {trigger_event}
Then: {expected_response}
Verification: {comprehensive_verification_steps}
```

---

## Common EARS Patterns for Flutter/Mobile Apps

### User Interface Requirements

```
WHEN a user taps the {button_name} button, THE {System_Name} SHALL {ui_response}
WHILE the application is loading data, THE {System_Name} SHALL display a progress indicator
WHERE Arabic language is selected, THE {System_Name} SHALL display right-to-left layout
```

### Data Management Requirements

```
WHEN data is saved locally, THE {System_Name} SHALL encrypt sensitive information
WHILE the device is offline, THE {System_Name} SHALL queue synchronization operations
IF data validation fails, THEN THE {System_Name} SHALL display specific error messages
```

### Performance Requirements

```
THE {System_Name} SHALL respond to user interactions within 200 milliseconds
WHEN loading large datasets, THE {System_Name} SHALL implement pagination with maximum 50 items per page
WHILE performing background synchronization, THE {System_Name} SHALL maintain UI responsiveness
```

### Security Requirements

```
WHEN user credentials are entered, THE {System_Name} SHALL validate them against secure storage
IF unauthorized access is detected, THEN THE {System_Name} SHALL lock the application
THE {System_Name} SHALL encrypt all data transmissions using TLS 1.3 or higher
```

---

## Quality Metrics

### Requirement Quality Score

Calculate based on:

- EARS pattern compliance: {score}/100
- INCOSE semantic quality: {score}/100
- Testability assessment: {score}/100
- Completeness evaluation: {score}/100

**Overall Quality Score: {total_score}/100**

### Improvement Recommendations

1. {improvement_suggestion_1}
2. {improvement_suggestion_2}
3. {improvement_suggestion_3}

---

## Approval Section

### Technical Review

- [ ] **Requirements Analyst**: {name} - {date}
- [ ] **System Architect**: {name} - {date}
- [ ] **Development Lead**: {name} - {date}

### Business Review

- [ ] **Product Owner**: {name} - {date}
- [ ] **Stakeholder Representative**: {name} - {date}

### Final Approval

- [ ] **Project Manager**: {name} - {date}

**Status**: ⏳ Pending Approval / ✅ Approved / ❌ Requires Revision

---

**Next Steps:** Upon approval, proceed to design.md for technical design and architecture.
