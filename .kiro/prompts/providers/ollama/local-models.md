# Ollama Local Models Prompts

**Provider:** Ollama (Local deployment)  
**Models:** Llama 3.1, Code Llama, Mistral, Gemma, Qwen  
**Context Limit:** Varies by model (8K-128K tokens)  
**Strengths:** Privacy, cost-effectiveness, offline capability, customization

---

## Code Llama Prompts

### Local Development Assistant

```
You are Code Llama, a specialized coding assistant running locally for privacy and cost-effectiveness.

Context:
- Project: Baseer MVP (Flutter invoice management app)
- Environment: Local development (offline-capable)
- Privacy: All code stays on local machine
- Target: Arabic small business users
- Tech Stack: Flutter, Dart, Riverpod, Isar

Task: [SPECIFIC_CODING_TASK]

Requirements:
- Generate clean, efficient Dart/Flutter code
- Follow effective_dart guidelines
- Include comprehensive comments
- Consider mobile performance
- Support Arabic RTL layout

Provide practical, implementable code solutions.
```

### Code Review and Refactoring

````
Review and improve the following Dart code for a local-first Flutter application:

```dart
[CODE_BLOCK]
````

Focus on:

1. Code quality and Dart best practices
2. Performance optimization for mobile
3. Memory efficiency
4. Error handling improvements
5. Readability and maintainability

Provide specific refactoring suggestions with improved code examples.

```

### Flutter Widget Generation
```

Generate a Flutter widget for the following requirements:

Widget Purpose: [WIDGET_DESCRIPTION]
Arabic Support: RTL layout required
Material Design: Version 3
State Management: Riverpod
Local Database: Isar integration

Requirements:

- Responsive design for various screen sizes
- Accessibility support (Arabic screen readers)
- Proper error handling and loading states
- Clean, testable code structure
- Performance optimized for mid-range devices

Generate complete widget implementation with documentation.

```

## Llama 3.1 General Purpose

### Architecture and Design Decisions
```

You are an experienced software architect helping with Flutter app design decisions.

Project Context:

- Baseer MVP: Invoice management for Saudi small businesses
- Local-first architecture with optional cloud sync
- Arabic language support (RTL)
- Target: Non-technical small business owners

Current Decision: [DECISION_CONTEXT]

Options:

1. [OPTION_1]
2. [OPTION_2]
3. [OPTION_3]

Evaluation Criteria:

- Implementation complexity
- Performance impact
- User experience (Arabic users)
- Maintenance overhead
- Future scalability

Provide detailed analysis and recommendation with reasoning.

```

### Business Logic Implementation
```

Implement business logic for Saudi Arabian invoice management system.

Requirements:

- VAT calculation (15% standard rate)
- Arabic invoice numbering
- Payment terms handling
- Multi-currency support (SAR primary)
- Discount calculations
- Due date management

Technical Context:

- Flutter/Dart implementation
- Local Isar database
- Offline-first approach
- Clean Architecture pattern

Generate robust, well-tested business logic with proper error handling.

```

### Documentation Generation
```

Generate comprehensive documentation for the following Flutter component:

Component: [COMPONENT_NAME]
Purpose: [COMPONENT_PURPOSE]
Context: Arabic invoice management app

Documentation Requirements:

1. Clear overview and purpose
2. API reference with examples
3. Usage patterns and best practices
4. Arabic/RTL considerations
5. Testing guidelines
6. Common troubleshooting

Target Audience: Flutter developers (intermediate level)
Format: Markdown with code examples

Create thorough, practical documentation.

```

## Mistral Models

### Efficient Problem Solving
```

Solve this Flutter development challenge efficiently:

Challenge: [PROBLEM_DESCRIPTION]
Constraints:

- Limited development time
- Small team (2-3 developers)
- Budget constraints
- Arabic language requirements
- Local-first architecture

Context:

- Flutter 3.35.5+, Dart 3.9.2+
- Riverpod for state management
- Isar for local database
- Material Design 3

Provide:

1. Quick analysis of the problem
2. Efficient solution approach
3. Implementation steps
4. Potential pitfalls to avoid
5. Testing strategy

Focus on practical, time-efficient solutions.

```

### Performance Optimization
```

Optimize the following Flutter code for better performance:

```dart
[CODE_TO_OPTIMIZE]
```

Performance Goals:

- Smooth 60fps on mid-range Android devices
- Minimal memory usage
- Fast app startup time
- Efficient battery usage
- Responsive UI for Arabic text

Optimization Areas:

1. Widget rebuilds
2. Memory management
3. Database queries
4. Image handling
5. Animation performance

Provide optimized code with performance improvements explained.

```

## Gemma Models

### Educational and Learning
```

Explain the following Flutter/Dart concept for learning purposes:

Concept: [TECHNICAL_CONCEPT]
Context: Building Arabic invoice management app
Audience: Intermediate Flutter developers

Explanation Requirements:

1. Clear conceptual overview
2. Why it's important for our use case
3. Practical implementation examples
4. Common mistakes to avoid
5. Best practices and tips
6. Related concepts to explore

Make the explanation practical and applicable to our project context.

```

### Code Examples and Tutorials
```

Create a step-by-step tutorial for implementing:

Feature: [FEATURE_NAME]
Context: Arabic invoice management Flutter app
Difficulty: [BEGINNER/INTERMEDIATE/ADVANCED]

Tutorial Structure:

1. Prerequisites and setup
2. Step-by-step implementation
3. Code explanations
4. Testing the implementation
5. Common issues and solutions
6. Next steps and improvements

Include complete, runnable code examples with detailed explanations.

```

## Qwen Models

### Multilingual Development
```

Help with Arabic language integration in Flutter development:

Task: [ARABIC_INTEGRATION_TASK]
Context: Invoice management app for Saudi market

Arabic Requirements:

- RTL text layout
- Arabic number formatting
- Date formatting (Hijri calendar support)
- Currency formatting (Saudi Riyal)
- Arabic input validation
- Proper font rendering

Technical Considerations:

- Flutter localization
- Material Design RTL support
- Text direction handling
- Input method compatibility

Provide comprehensive Arabic language integration solution.

```

### Cultural and Regional Adaptation
```

Adapt the following feature for Saudi Arabian business culture:

Feature: [FEATURE_DESCRIPTION]
Current Implementation: [CURRENT_APPROACH]

Cultural Considerations:

- Saudi business practices
- Islamic calendar integration
- Local payment methods
- Government regulations
- User expectations
- Accessibility requirements

Adaptation Requirements:

1. Cultural appropriateness
2. Legal compliance
3. User experience optimization
4. Technical implementation
5. Testing considerations

Provide culturally adapted solution with implementation details.

````

---

## Ollama-Specific Optimizations

### Local Deployment Configuration
```yaml
ollama_config:
  models:
    code_llama:
      size: "13b"  # Balance between capability and resource usage
      context_length: 16384
      use_case: "Code generation and review"

    llama3_1:
      size: "8b"   # Efficient for general tasks
      context_length: 8192
      use_case: "General development assistance"

    mistral:
      size: "7b"   # Fast responses
      context_length: 8192
      use_case: "Quick problem solving"

  performance:
    gpu_acceleration: true
    memory_limit: "8GB"
    concurrent_requests: 2
````

### Privacy and Security Benefits

```
Local AI Development Advantages:

Privacy Benefits:
- Code never leaves local machine
- No data transmission to external services
- Complete control over sensitive business logic
- Compliance with data protection regulations

Cost Benefits:
- No per-token charges
- Unlimited usage once deployed
- No internet dependency
- Predictable infrastructure costs

Development Benefits:
- Offline development capability
- Consistent response times
- Customizable model behavior
- Integration with local development tools
```

### Model Selection Guidelines

```yaml
task_to_model_mapping:
  code_generation:
    primary: "code_llama:13b"
    fallback: "llama3.1:8b"

  code_review:
    primary: "code_llama:13b"
    secondary: "mistral:7b"

  documentation:
    primary: "llama3.1:8b"
    secondary: "gemma:7b"

  problem_solving:
    primary: "mistral:7b"
    secondary: "llama3.1:8b"

  arabic_integration:
    primary: "qwen:14b"
    secondary: "llama3.1:8b"
```

### Integration Patterns

#### Local API Integration

````python
import requests
import json

class OllamaClient:
    def __init__(self, base_url="http://localhost:11434"):
        self.base_url = base_url

    def generate_code(self, prompt, model="code_llama:13b"):
        """Generate code using local Ollama instance"""
        response = requests.post(
            f"{self.base_url}/api/generate",
            json={
                "model": model,
                "prompt": prompt,
                "stream": False,
                "options": {
                    "temperature": 0.1,  # Low temperature for code generation
                    "top_p": 0.9,
                    "num_ctx": 8192
                }
            }
        )
        return response.json()["response"]

    def review_code(self, code, model="code_llama:13b"):
        """Review code using local AI"""
        prompt = f"""
        Review this Dart/Flutter code for quality, performance, and best practices:

        ```dart
        {code}
        ```

        Provide specific improvement suggestions.
        """
        return self.generate_code(prompt, model)
````

#### VS Code Extension Integration

```json
{
  "ollama.models": [
    {
      "name": "code_llama:13b",
      "description": "Code generation and review",
      "temperature": 0.1
    },
    {
      "name": "llama3.1:8b",
      "description": "General development assistance",
      "temperature": 0.3
    }
  ],
  "ollama.autoComplete": {
    "enabled": true,
    "model": "code_llama:13b",
    "maxTokens": 100
  }
}
```

---

## Performance Optimization

### Resource Management

```yaml
system_requirements:
  minimum:
    ram: "8GB"
    gpu: "4GB VRAM (optional but recommended)"
    cpu: "4 cores"
    storage: "50GB for models"

  recommended:
    ram: "16GB"
    gpu: "8GB VRAM"
    cpu: "8 cores"
    storage: "100GB SSD"

optimization_tips:
  - Use smaller models for simple tasks
  - Enable GPU acceleration when available
  - Limit concurrent requests based on system capacity
  - Monitor memory usage and adjust accordingly
  - Use model quantization for better performance
```

### Batch Processing

```python
def batch_process_code_reviews(code_files, ollama_client):
    """Process multiple code reviews efficiently"""
    results = []

    for batch in chunk_files(code_files, batch_size=3):
        batch_results = []

        for file in batch:
            review = ollama_client.review_code(file.content)
            batch_results.append({
                'file': file.name,
                'review': review
            })

        results.extend(batch_results)

        # Brief pause between batches to prevent overload
        time.sleep(1)

    return results
```

---

**Usage Notes:**

- Install and configure Ollama locally for privacy and cost benefits
- Choose model size based on available system resources
- Use GPU acceleration when available for better performance
- Implement proper error handling for local service availability
- Consider model quantization for resource-constrained environments
- Monitor system resources and adjust concurrent usage accordingly
