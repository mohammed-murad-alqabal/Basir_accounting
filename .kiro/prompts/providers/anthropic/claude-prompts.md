# Anthropic Claude Prompts

**Provider:** Anthropic (Claude 3.5 Sonnet, Claude 3 Opus, Claude 3 Haiku)  
**Context Limit:** 200K tokens  
**Strengths:** Analysis, reasoning, code review, complex problem solving

---

## Code Analysis and Review

### Comprehensive Code Analysis

```
I need you to analyze this Flutter/Dart code with your characteristic thoroughness and attention to detail.

<code>
[CODE_BLOCK]
</code>

<context>
Project: Baseer MVP - Arabic invoice management app
Architecture: Clean Architecture with Riverpod + Isar
Target: Local-first mobile app for Saudi small businesses
</context>

Please provide a comprehensive analysis covering:

1. **Code Quality Assessment**
   - Adherence to effective_dart guidelines
   - Design patterns usage
   - SOLID principles compliance

2. **Performance Analysis**
   - Potential bottlenecks
   - Memory usage considerations
   - UI performance implications

3. **Security Review**
   - Input validation
   - Data handling security
   - Potential vulnerabilities

4. **Maintainability Evaluation**
   - Code readability and structure
   - Documentation quality
   - Testing considerations

5. **Arabic/RTL Considerations**
   - RTL layout compatibility
   - Arabic text handling
   - Localization readiness

Provide specific recommendations with code examples where applicable.
```

### Architecture Decision Analysis

```
I'm facing an architectural decision for our Flutter app and would value your analytical approach.

<situation>
[PROBLEM_DESCRIPTION]
</situation>

<options>
1. [OPTION_1_DESCRIPTION]
2. [OPTION_2_DESCRIPTION]
3. [OPTION_3_DESCRIPTION]
</options>

<constraints>
- Local-first architecture (Isar database)
- Arabic RTL support required
- Small team (2-3 developers)
- 6-month development timeline
- Performance critical for mid-range Android devices
</constraints>

Please analyze each option considering:
- Technical complexity and implementation effort
- Long-term maintainability
- Performance implications
- Team learning curve
- Risk assessment

Provide a clear recommendation with detailed reasoning.
```

## Complex Problem Solving

### System Design and Architecture

```
Help me design a robust system for the following requirements:

<requirements>
[DETAILED_REQUIREMENTS]
</requirements>

<technical_context>
- Flutter mobile app (Android primary, iOS secondary)
- Local-first with optional cloud sync
- Arabic language support (RTL)
- Offline-capable invoice management
- Small business users (non-technical)
</technical_context>

Please provide:

1. **High-Level Architecture**
   - System components and their relationships
   - Data flow diagrams
   - Technology stack recommendations

2. **Detailed Design**
   - Database schema design (Isar)
   - State management approach (Riverpod)
   - UI/UX considerations for Arabic users

3. **Implementation Strategy**
   - Development phases and milestones
   - Risk mitigation strategies
   - Testing approach

4. **Scalability Considerations**
   - Future feature additions
   - Performance optimization
   - Maintenance and updates

Use your analytical strengths to identify potential issues and provide comprehensive solutions.
```

### Debugging Complex Issues

```
I'm encountering a complex issue that requires systematic analysis.

<problem>
[DETAILED_PROBLEM_DESCRIPTION]
</problem>

<symptoms>
- [SYMPTOM_1]
- [SYMPTOM_2]
- [SYMPTOM_3]
</symptoms>

<environment>
- Flutter: [VERSION]
- Dart: [VERSION]
- Platform: [ANDROID/IOS]
- Device: [DEVICE_INFO]
</environment>

<code_context>
[RELEVANT_CODE_SNIPPETS]
</code_context>

<logs>
[ERROR_LOGS_AND_STACK_TRACES]
</logs>

Please provide:

1. **Root Cause Analysis**
   - Systematic investigation approach
   - Hypothesis formation and testing
   - Identification of the underlying issue

2. **Solution Strategy**
   - Step-by-step fix implementation
   - Alternative approaches if primary solution fails
   - Verification methods

3. **Prevention Measures**
   - Code improvements to prevent recurrence
   - Testing strategies
   - Monitoring and early detection

Use your methodical approach to break down this complex problem.
```

## Documentation and Knowledge Transfer

### Technical Documentation Creation

```
Create comprehensive technical documentation for the following component:

<component>
[COMPONENT_DESCRIPTION_OR_CODE]
</component>

<audience>
Target: Flutter developers (intermediate level)
Purpose: Onboarding and maintenance
</audience>

<requirements>
- Clear explanations of complex concepts
- Code examples with Arabic context
- Best practices and common pitfalls
- Integration guidelines
- Testing recommendations
</requirements>

Please structure the documentation with:
1. Overview and purpose
2. Architecture and design decisions
3. Implementation details
4. Usage examples
5. Testing guidelines
6. Troubleshooting guide
7. Future considerations

Use your ability to explain complex topics clearly and thoroughly.
```

### Code Review Guidelines

```
Create a comprehensive code review checklist specifically for our Flutter project.

<project_context>
- Baseer MVP: Invoice management app
- Arabic language support (RTL)
- Local-first architecture
- Clean Architecture pattern
- Riverpod + Isar tech stack
</project_context>

<team_context>
- Mixed experience levels
- Remote collaboration
- Quality-focused development
- Continuous learning culture
</team_context>

Please create:

1. **General Code Quality Checklist**
   - Dart/Flutter best practices
   - Performance considerations
   - Security guidelines

2. **Project-Specific Checklist**
   - Arabic/RTL compatibility
   - Local-first patterns
   - Architecture compliance

3. **Review Process Guidelines**
   - How to conduct effective reviews
   - Feedback delivery best practices
   - Conflict resolution

4. **Automated Checks Integration**
   - Linting and formatting
   - Testing requirements
   - CI/CD integration

Use your systematic approach to create a thorough and practical guide.
```

---

## Claude-Specific Optimizations

### Leveraging Claude's Strengths

- **Analysis**: Use for complex code review and architecture decisions
- **Reasoning**: Leverage for multi-step problem solving
- **Thoroughness**: Request comprehensive analysis and documentation
- **Nuanced Understanding**: Utilize for context-aware recommendations

### Prompt Structure for Claude

```xml
<task>
[Clear task description]
</task>

<context>
[Relevant background information]
</context>

<requirements>
[Specific requirements and constraints]
</requirements>

<output_format>
[Desired output structure]
</output_format>
```

### Model Selection Guidelines

- **Claude 3.5 Sonnet**: Best balance of capability and speed
- **Claude 3 Opus**: Most capable for complex analysis and reasoning
- **Claude 3 Haiku**: Fast responses for simpler tasks

---

## Integration Patterns

### Structured Analysis Requests

```
Analyze the following [COMPONENT_TYPE] with your characteristic attention to detail:

<component>
[COMPONENT_CODE_OR_DESCRIPTION]
</component>

<analysis_dimensions>
1. Technical correctness
2. Performance implications
3. Security considerations
4. Maintainability factors
5. Arabic/RTL compatibility
6. Testing adequacy
</analysis_dimensions>

Provide specific, actionable recommendations for each dimension.
```

### Decision Support Format

```
I need your analytical perspective on this technical decision:

<decision_context>
[CONTEXT_AND_BACKGROUND]
</decision_context>

<options>
[DETAILED_OPTIONS_WITH_PROS_CONS]
</options>

<evaluation_criteria>
[SPECIFIC_CRITERIA_FOR_EVALUATION]
</evaluation_criteria>

Please provide a systematic evaluation and clear recommendation.
```

---

**Usage Notes:**

- Use XML tags for structured input when dealing with complex information
- Leverage Claude's ability to maintain context across long conversations
- Request step-by-step reasoning for complex problems
- Use Claude's strength in identifying edge cases and potential issues
- Take advantage of the large context window for comprehensive code analysis
