# Ollama Local Models Prompts

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 15 ديسمبر 2025  
**الموفر:** Ollama (Local Models)

---

## Optimized Prompts for Local Ollama Models

### Code Assistance with Local Models

#### Flutter Development (CodeLlama, DeepSeek Coder)

```
You are a Flutter/Dart expert helping with the Basir App project - a local-first invoice management app for Arabic users in Saudi Arabia.

Project Context:
- Flutter 3.35.5+ with Dart 3.9.2+
- Local-first using Isar database
- Arabic RTL interface required
- Clean Architecture pattern
- Riverpod state management
- Material Design 3

Coding Standards:
- English for all code identifiers
- Comprehensive error handling
- DartDoc documentation
- Security best practices
- 70%+ test coverage

Task: {coding_task}

Provide:
1. Clean, working code
2. Proper error handling
3. Basic tests
4. Brief documentation
```

#### Code Review (Llama 3.1, Mistral)

````
Review this Flutter code from the Basir App project:

Review Criteria:
- Code quality and readability
- Flutter best practices
- Security issues
- Performance concerns
- Arabic/RTL compatibility

Code to review:
```dart
{code_content}
````

Provide:

1. Issues found (if any)
2. Improvement suggestions
3. Security notes
4. Performance tips

```

### Documentation Generation

#### API Documentation (Llama 3.1)
```

Generate documentation for this Basir App Flutter code:

Documentation Requirements:

- DartDoc format
- Clear parameter descriptions
- Usage examples
- Error handling notes
- Arabic descriptions for user-facing elements

Code to document:
{code_to_document}

Format as:

1. Overview
2. Parameters
3. Returns
4. Examples
5. Notes

```

### Analysis and Problem Solving

#### Architecture Analysis (Llama 3.1, Mistral)
```

Analyze the architecture of this Flutter component from the Basir App:

Analysis Focus:

- Clean Architecture compliance
- Separation of concerns
- State management patterns
- Local-first architecture
- Performance implications

Component: {component_info}

Provide:

1. Architecture assessment
2. Strengths and weaknesses
3. Improvement suggestions
4. Best practices alignment

```

---

## Local Model Optimizations

### Model-Specific Approaches

#### CodeLlama (7B, 13B, 34B)
- **Best for**: Code generation, debugging, refactoring
- **Prompt style**: Direct, code-focused requests
- **Context**: Keep code examples concise but complete
- **Output**: Expect good code quality, may need refinement

#### Llama 3.1 (8B, 70B)
- **Best for**: General development advice, analysis, documentation
- **Prompt style**: Conversational, detailed context
- **Context**: Can handle broader discussions
- **Output**: Good reasoning, comprehensive responses

#### Mistral (7B, 8x7B)
- **Best for**: Code review, problem-solving, optimization
- **Prompt style**: Structured, specific questions
- **Context**: Efficient with focused tasks
- **Output**: Concise, practical suggestions

#### DeepSeek Coder
- **Best for**: Complex code generation, algorithm implementation
- **Prompt style**: Technical, detailed specifications
- **Context**: Provide complete requirements
- **Output**: High-quality code, good practices

### Performance Considerations

#### Context Management
```

Keep prompts focused and concise for local models:

Good:
"Generate a Flutter widget for displaying invoice items with Arabic RTL support."

Better:
"Create a Flutter ListView widget that:

- Displays invoice items
- Supports Arabic RTL layout
- Uses Material Design 3
- Handles empty states"

```

#### Response Optimization
- Request specific output formats
- Limit response length when needed
- Use structured prompts for better parsing
- Implement response validation

### Local Development Workflow

#### Iterative Development
```

Step 1: Generate initial code
"Create a basic Flutter repository class for invoice management using Isar."

Step 2: Add features
"Add search functionality to the invoice repository with Arabic text support."

Step 3: Optimize
"Optimize the invoice repository for better performance with large datasets."

Step 4: Test
"Generate unit tests for the invoice repository class."

```

#### Code Review Process
```

1. Generate code with primary model
2. Review with secondary model
3. Validate against project standards
4. Test and refine

````

---

## Offline Development Support

### Local Model Benefits
- **Privacy**: Code never leaves local environment
- **Speed**: No network latency
- **Availability**: Works without internet connection
- **Cost**: No API costs after initial setup
- **Customization**: Can fine-tune for project-specific needs

### Setup Recommendations

#### Hardware Requirements
- **Minimum**: 8GB RAM, 4-core CPU
- **Recommended**: 16GB+ RAM, 8-core CPU
- **Storage**: 10GB+ for model files
- **GPU**: Optional but recommended for larger models

#### Model Selection for Basir App
```yaml
Primary Models:
  - CodeLlama 13B: Main code generation
  - Llama 3.1 8B: General assistance
  - DeepSeek Coder 6.7B: Complex algorithms

Secondary Models:
  - Mistral 7B: Code review
  - CodeLlama 7B: Quick tasks
  - Llama 3.1 70B: Complex analysis (if hardware allows)
````

### Integration with Development Environment

#### VS Code Integration

```json
{
  "ollama.models": ["codellama:13b", "llama3.1:8b", "deepseek-coder:6.7b"],
  "ollama.defaultModel": "codellama:13b",
  "ollama.temperature": 0.1
}
```

#### Command Line Usage

```bash
# Code generation
ollama run codellama:13b "Generate Flutter widget for invoice display"

# Code review
ollama run llama3.1:8b "Review this Dart code for best practices: [code]"

# Documentation
ollama run mistral:7b "Document this Flutter function: [function]"
```

---

## Quality Assurance for Local Models

### Response Validation

- Syntax checking for generated code
- Security vulnerability scanning
- Performance impact assessment
- Arabic RTL compatibility verification

### Model Performance Monitoring

- Response quality scoring
- Generation time tracking
- Resource usage monitoring
- Accuracy measurement against standards

### Continuous Improvement

- Fine-tuning with project-specific data
- Model comparison and selection
- Prompt optimization based on results
- Integration with CI/CD pipeline
