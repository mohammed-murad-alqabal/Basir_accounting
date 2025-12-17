# Anthropic Claude Prompts

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 15 ديسمبر 2025  
**الموفر:** Anthropic (Claude-3.5-Sonnet, Claude-3-Haiku)

---

## Optimized Prompts for Claude Models

### Code Generation Prompts

#### Flutter Development with Claude

```
I'm working on the Baseer MVP, a Flutter invoice management app for Arabic users in Saudi Arabia. I need your help with Flutter/Dart development.

Project Context:
- Local-first architecture using Isar database
- Arabic RTL support required
- Clean Architecture pattern
- Riverpod state management
- Material Design 3
- Target: 70%+ test coverage

Development Standards:
- English for all code identifiers
- Comprehensive error handling
- DartDoc documentation
- Security-first approach
- Performance optimization

Please help me with: {specific_request}

When providing code:
1. Include complete, runnable examples
2. Add comprehensive comments
3. Consider edge cases
4. Include relevant tests
5. Explain design decisions
```

#### Code Analysis with Claude

````
I need you to analyze this Flutter code from the Baseer MVP project. Please provide a thorough analysis focusing on:

Analysis Criteria:
- Code quality and maintainability
- Security vulnerabilities
- Performance bottlenecks
- Arabic/RTL compatibility
- Clean Architecture adherence
- Testing completeness

Please structure your response as:
1. **Summary**: Overall assessment
2. **Issues**: Problems found with severity levels
3. **Recommendations**: Specific improvements
4. **Security**: Security considerations
5. **Performance**: Optimization opportunities

Code to analyze:
```{language}
{code_content}
````

```

### Reasoning and Problem-Solving

#### Architecture Decision Prompts
```

I'm making an architectural decision for the Baseer MVP Flutter project and need your analytical approach.

Decision Context:

- Local-first invoice management app
- Arabic-speaking users in Saudi Arabia
- Offline-first with optional sync
- Performance and security critical

Please help me evaluate: {decision_topic}

Analysis Framework:

1. **Options**: List all viable alternatives
2. **Pros/Cons**: Detailed analysis of each option
3. **Trade-offs**: What we gain vs. what we lose
4. **Risks**: Potential issues and mitigation strategies
5. **Recommendation**: Your suggested approach with reasoning
6. **Implementation**: High-level implementation strategy

Consider factors like:

- Development complexity
- Maintenance burden
- Performance impact
- Security implications
- User experience
- Future scalability

```

### Documentation and Explanation

#### Technical Documentation
```

Please create comprehensive technical documentation for the Baseer MVP project.

Documentation Requirements:

- Clear, structured format
- Code examples with explanations
- Arabic translations for user-facing content
- Implementation guidelines
- Best practices
- Common pitfalls and solutions

Topic to document: {documentation_topic}

Structure the documentation with:

1. **Overview**: What it is and why it's important
2. **Implementation**: Step-by-step guide
3. **Examples**: Practical code examples
4. **Best Practices**: Recommended approaches
5. **Troubleshooting**: Common issues and solutions
6. **References**: Related documentation and resources

```

---

## Claude-Specific Optimizations

### Leveraging Claude's Strengths

#### Analytical Thinking
- Request step-by-step reasoning
- Ask for multiple perspectives
- Use structured analysis frameworks
- Encourage consideration of edge cases

#### Code Understanding
- Provide full context when possible
- Ask for explanation of complex logic
- Request refactoring suggestions
- Seek architectural insights

#### Safety and Security
- Emphasize security considerations
- Request vulnerability assessments
- Ask for secure coding practices
- Seek privacy protection strategies

### Response Optimization

#### Structured Requests
```

Please analyze this in the following structure:

1. [First aspect]
2. [Second aspect]
3. [Third aspect]
   ...

```

#### Context Preservation
- Include relevant project context in each prompt
- Reference previous decisions and constraints
- Maintain consistency with established patterns

#### Quality Assurance
- Request validation of suggestions
- Ask for alternative approaches
- Seek confirmation of best practices
- Request testing strategies

---

## Model-Specific Usage Guidelines

### Claude-3.5-Sonnet
- **Best for**: Complex analysis, architectural decisions, comprehensive code reviews
- **Context**: Can handle large codebases and complex requirements
- **Strengths**: Deep reasoning, security analysis, best practices

### Claude-3-Haiku
- **Best for**: Quick code generation, simple analysis, documentation
- **Context**: Faster responses for straightforward tasks
- **Strengths**: Speed, efficiency, clear explanations

### Claude-3-Opus (when available)
- **Best for**: Most complex architectural decisions, comprehensive system design
- **Context**: Largest context window, most sophisticated reasoning
- **Strengths**: Highest quality analysis, complex problem solving
```
