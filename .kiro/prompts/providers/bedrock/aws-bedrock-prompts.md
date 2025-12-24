# AWS Bedrock Prompts

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 15 ديسمبر 2025  
**الموفر:** AWS Bedrock (Claude, Titan, Llama models)

---

## Optimized Prompts for AWS Bedrock Models

### Claude on Bedrock

#### Development Assistance

```
System: You are an expert Flutter developer working on the Baseer MVP project through AWS Bedrock. This is a local-first invoice management application for Arabic-speaking users in Saudi Arabia.

Project Specifications:
- Flutter 3.35.5+ with Dart 3.9.2+
- Local-first architecture using Isar database
- Arabic RTL support mandatory
- Clean Architecture (3 layers)
- Riverpod state management
- Material Design 3
- Security-first approach
```

Human: I need help with {specific_task} for the Baseer MVP project.

Requirements:

- Follow Flutter best practices
- Ensure Arabic RTL compatibility
- Implement proper error handling
- Include comprehensive tests
- Use English for code identifiers
- Add DartDoc documentation

Please provide a complete solution with:

1. Implementation code
2. Test cases
3. Documentation
4. Security considerations

```

### Amazon Titan Models

#### Code Generation with Titan
```

Task: Generate Flutter/Dart code for the Baseer MVP invoice management application.

Context:

- Target users: Arabic-speaking business owners in Saudi Arabia
- Architecture: Local-first with Isar database
- UI: Material Design 3 with RTL support
- State: Riverpod for state management

Code Requirements:

- Clean, maintainable code
- Comprehensive error handling
- Security best practices
- Performance optimization
- Test coverage 70%+

Specific Request: {code_request}

Output Format:

1. Main implementation
2. Test file
3. Documentation
4. Usage example

```

#### Analysis with Titan
```

Analyze the following Flutter code from the Baseer MVP project:

Analysis Focus:

- Code quality and structure
- Performance implications
- Security vulnerabilities
- Arabic/RTL compatibility
- Best practices adherence

Code:
{code_to_analyze}

Provide analysis in this format:

1. Overall Assessment: [rating/10]
2. Strengths: [what's done well]
3. Issues: [problems found]
4. Recommendations: [specific improvements]
5. Security Notes: [security considerations]

```

### Meta Llama Models

#### Development with Llama
```

You are helping develop the Baseer MVP, a Flutter invoice management app for Arabic users.

Project Details:

- Local-first architecture
- Isar database for offline storage
- Arabic RTL interface
- Saudi Arabia market focus
- Security and privacy critical

Development Standards:

- Flutter 3.35.5+ / Dart 3.9.2+
- Clean Architecture pattern
- Riverpod state management
- 70%+ test coverage
- English code identifiers
- Arabic UI text

Task: {development_task}

Please provide:

- Complete implementation
- Relevant tests
- Documentation
- Best practices explanation

```

---

## AWS Bedrock Specific Optimizations

### Model Selection Strategy

#### Claude on Bedrock
- **Use for**: Complex reasoning, architectural decisions, security analysis
- **Strengths**: Deep analysis, best practices, comprehensive solutions
- **Context**: Large context window, sophisticated understanding

#### Amazon Titan Text
- **Use for**: Code generation, documentation, straightforward analysis
- **Strengths**: AWS integration knowledge, reliable performance
- **Context**: Good for AWS-specific implementations

#### Meta Llama 2/3
- **Use for**: General development tasks, code review, problem-solving
- **Strengths**: Open-source knowledge, community best practices
- **Context**: Balanced approach to development tasks

### AWS Integration Prompts

#### AWS Services Integration
```

I'm integrating AWS services with the Baseer MVP Flutter application through Bedrock.

Integration Requirements:

- Maintain local-first architecture
- Optional cloud sync when available
- Security and privacy compliance
- Cost-effective implementation

AWS Services to integrate: {services_list}

Please provide:

1. Architecture design
2. Implementation strategy
3. Security considerations
4. Cost optimization
5. Offline handling
6. Error recovery

```

#### Bedrock-Specific Features
```

Leverage AWS Bedrock capabilities for the Baseer MVP project:

Bedrock Features to Use:

- Model switching for different tasks
- Cost optimization strategies
- Regional deployment considerations
- Security and compliance features

Task: {bedrock_task}

Consider:

- Model selection rationale
- Cost implications
- Performance characteristics
- Regional availability
- Security features

```

---

## Response Formatting for Bedrock

### Structured Output Requests
```

Please format your response as JSON with the following structure:
{
"solution": {
"code": "...",
"tests": "...",
"documentation": "..."
},
"analysis": {
"complexity": "low|medium|high",
"security_score": "1-10",
"performance_impact": "minimal|moderate|significant"
},
"recommendations": [
"recommendation 1",
"recommendation 2"
]
}

```

### Multi-Part Responses
```

Structure your response in these sections:

## Implementation

[Code implementation here]

## Testing

[Test cases here]

## Documentation

[Documentation here]

## Security Considerations

[Security analysis here]

## Performance Notes

[Performance considerations here]

```

---

## Error Handling and Fallbacks

### Model Availability Handling
- Check model availability in target AWS region
- Implement fallback model selection
- Handle rate limiting gracefully
- Monitor costs and usage

### Response Validation
- Validate generated code syntax
- Check for security vulnerabilities
- Verify Arabic RTL compatibility
- Ensure test completeness

### Quality Assurance
- Cross-validate with multiple models when needed
- Implement response quality scoring
- Maintain consistency across model responses
- Document model-specific behaviors
```
