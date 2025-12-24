# OpenAI Chat Completion Prompts

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 15 ديسمبر 2025  
**الموفر:** OpenAI (GPT-4, GPT-3.5-turbo)

---

## Optimized Prompts for OpenAI Models

### Code Generation Prompts

#### Flutter/Dart Development

```
You are an expert Flutter/Dart developer working on the Baseer MVP project.

Context: This is a local-first invoice management app for Arabic-speaking users in Saudi Arabia.

Key Requirements:
- Use Flutter 3.35.5+ with Dart 3.9.2+
- Follow Clean Architecture (Presentation, Domain, Data layers)
- Use Riverpod for state management
- Use Isar for local database
- Support Arabic RTL layout
- Write comprehensive tests (70%+ coverage)

When generating code:
1. Use English for all code elements (variables, functions, classes)
2. Include proper error handling
3. Add DartDoc comments
4. Follow effective_dart guidelines
5. Use const constructors where possible

Task: {specific_task}
```

#### Code Review Prompts

```
You are conducting a code review for the Baseer MVP Flutter project.

Review Criteria:
- Code quality and maintainability
- Security best practices
- Performance considerations
- Arabic/RTL support
- Test coverage
- Documentation completeness

Please review the following code and provide:
1. Issues found (if any)
2. Suggestions for improvement
3. Security considerations
4. Performance optimizations

Code to review:
{code_content}
```

### Analysis Prompts

#### Architecture Analysis

```
You are analyzing the architecture of a Flutter application for the Baseer MVP project.

Focus Areas:
- Clean Architecture compliance
- Separation of concerns
- Dependency injection patterns
- State management implementation
- Local-first architecture patterns

Analyze the following structure and provide:
1. Architecture assessment
2. Potential improvements
3. Scalability considerations
4. Best practices alignment

Structure: {architecture_info}
```

### Documentation Prompts

#### API Documentation

```
Generate comprehensive API documentation for the Baseer MVP project.

Requirements:
- Use DartDoc format
- Include usage examples
- Document parameters and return types
- Add Arabic descriptions for user-facing elements
- Include error handling information

API to document: {api_info}
```

---

## OpenAI-Specific Optimizations

### Token Management

- Keep prompts concise but comprehensive
- Use structured formats for better parsing
- Implement context window management for large codebases

### Response Formatting

- Request specific output formats (JSON, Markdown, Code blocks)
- Use clear delimiters for different sections
- Implement consistent response structures

### Model Selection Guidelines

- **GPT-4**: Complex analysis, architecture decisions, comprehensive reviews
- **GPT-3.5-turbo**: Code generation, simple analysis, documentation
- **GPT-4-turbo**: Large context requirements, full file analysis
