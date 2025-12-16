# OpenAI Chat Completion Prompts

**Provider:** OpenAI (GPT-4, GPT-4 Turbo, GPT-3.5 Turbo)  
**Context Limit:** 128K tokens (GPT-4 Turbo)  
**Strengths:** Code generation, reasoning, analysis

---

## Code Generation Prompts

### Flutter/Dart Development

```
You are an expert Flutter/Dart developer working on a local-first invoice management app called "Baseer MVP".

Context:
- Target: Arabic-speaking small business owners in Saudi Arabia
- Architecture: Clean Architecture with Riverpod + Isar
- UI: Material Design 3 with RTL support
- Language: Arabic UI, English code

Task: [SPECIFIC_TASK]

Requirements:
- Follow effective_dart guidelines
- Use const constructors where possible
- Implement proper error handling
- Add comprehensive DartDoc comments
- Support RTL layout for Arabic text

Generate clean, production-ready code with proper testing.
```

### Code Review and Analysis

```
You are conducting a code review for a Flutter application. Analyze the following code for:

1. **Code Quality**: Adherence to Dart/Flutter best practices
2. **Performance**: Potential optimization opportunities
3. **Security**: Vulnerability assessment
4. **Maintainability**: Code structure and readability
5. **Testing**: Test coverage and quality

Code to review:
[CODE_BLOCK]

Provide specific, actionable feedback with examples.
```

## Reasoning and Problem Solving

### Technical Decision Making

```
You are a senior technical architect making decisions for a Flutter mobile app project.

Context: [PROJECT_CONTEXT]
Problem: [PROBLEM_DESCRIPTION]
Options: [AVAILABLE_OPTIONS]

Analyze each option considering:
- Technical feasibility and complexity
- Performance implications
- Maintenance overhead
- Team expertise requirements
- Long-term scalability

Provide a clear recommendation with detailed reasoning.
```

### Debugging and Troubleshooting

```
You are debugging a Flutter application issue.

Problem Description: [ISSUE_DESCRIPTION]
Error Messages: [ERROR_LOGS]
Code Context: [RELEVANT_CODE]
Environment: [FLUTTER_VERSION, DART_VERSION, PLATFORM]

Provide:
1. Root cause analysis
2. Step-by-step debugging approach
3. Specific fix recommendations
4. Prevention strategies for similar issues
```

## Documentation and Explanation

### API Documentation Generation

```
Generate comprehensive API documentation for the following Dart code:

[CODE_BLOCK]

Include:
- Clear method descriptions in English
- Parameter explanations with types
- Return value documentation
- Usage examples
- Error conditions and exceptions
- Related methods and classes

Format as DartDoc comments following effective_dart guidelines.
```

### Architecture Explanation

```
Explain the following architectural pattern/concept for a Flutter development team:

Topic: [ARCHITECTURE_TOPIC]
Context: [PROJECT_CONTEXT]
Audience: [TEAM_EXPERIENCE_LEVEL]

Provide:
- Clear conceptual explanation
- Benefits and trade-offs
- Implementation examples in Flutter/Dart
- Best practices and common pitfalls
- When to use vs alternatives
```

---

## OpenAI-Specific Optimizations

### Token Efficiency

- Use clear, concise prompts
- Leverage system messages for context
- Break complex tasks into smaller chunks
- Use structured output formats (JSON, YAML)

### Model Selection Guidelines

- **GPT-4 Turbo**: Complex reasoning, large codebases, architecture decisions
- **GPT-4**: High-quality code generation, detailed analysis
- **GPT-3.5 Turbo**: Quick tasks, simple code generation, documentation

### Response Format Optimization

```json
{
  "task_type": "code_generation|analysis|documentation|debugging",
  "confidence": "high|medium|low",
  "response": {
    "code": "// Generated code here",
    "explanation": "Clear explanation of the solution",
    "alternatives": ["Alternative approach 1", "Alternative approach 2"],
    "testing_notes": "How to test this implementation"
  },
  "follow_up": ["Suggested next steps", "Related improvements"]
}
```

---

## Integration with Baseer MVP

### Project-Specific Context

```
Project: Baseer MVP - Invoice Management App
Target Users: Arabic-speaking small business owners in Saudi Arabia
Tech Stack: Flutter 3.35.5+, Dart 3.9.2+, Riverpod, Isar, Material Design 3
Architecture: Clean Architecture (3 layers)
Features: Customer management, Invoice creation, Local-first data storage
UI Language: Arabic (RTL support required)
Code Language: English with Arabic comments for business logic
```

### Common Task Templates

1. **Feature Implementation**: New invoice/customer features
2. **UI Components**: Arabic-friendly Material Design 3 widgets
3. **Data Layer**: Isar repository and model implementations
4. **Business Logic**: Riverpod providers and use cases
5. **Testing**: Unit, widget, and integration tests
6. **Localization**: Arabic text and RTL layout support

---

**Usage Notes:**

- Always specify the model version for consistency
- Use temperature 0.1-0.3 for code generation
- Use temperature 0.7-0.9 for creative tasks
- Enable JSON mode for structured outputs
- Set max_tokens appropriately for task complexity
