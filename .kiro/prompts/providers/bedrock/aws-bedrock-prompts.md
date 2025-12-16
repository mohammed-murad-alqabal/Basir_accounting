# AWS Bedrock AI Prompts

**Provider:** AWS Bedrock (Claude 3.5 Sonnet, Claude 3 Opus, Titan, Llama 2/3)  
**Context Limit:** Varies by model (200K for Claude, 32K for Llama)  
**Strengths:** Enterprise integration, AWS ecosystem, cost optimization

---

## Claude on Bedrock

### Enterprise Code Review

```
You are an enterprise-grade code reviewer analyzing Flutter/Dart code for a business-critical application.

<code_context>
Application: Baseer MVP - Invoice Management System
Environment: AWS Bedrock Enterprise
Compliance: SOC 2, GDPR considerations for Saudi market
</code_context>

<code>
[CODE_BLOCK]
</code>

<review_criteria>
1. Enterprise security standards
2. Performance at scale
3. Maintainability for enterprise teams
4. Compliance with data protection regulations
5. AWS integration readiness
6. Cost optimization considerations
</review_criteria>

Provide enterprise-focused recommendations with specific AWS service integration suggestions where applicable.
```

### AWS Integration Planning

```
Design an AWS integration strategy for our Flutter mobile application.

<application_context>
- Baseer MVP: Local-first invoice management
- Target: Saudi small businesses
- Current: Local Isar database
- Future: Optional cloud sync and backup
</application_context>

<aws_requirements>
- Cost-effective for small business users
- GDPR/Saudi data protection compliance
- Scalable architecture
- Disaster recovery capabilities
- Multi-region support (Middle East focus)
</aws_requirements>

<integration_scope>
1. Data synchronization and backup
2. User authentication and authorization
3. File storage for invoice attachments
4. Analytics and reporting
5. Push notifications
6. Monitoring and logging
</integration_scope>

Recommend specific AWS services with cost estimates and implementation roadmap.
```

## Titan Models

### Business Logic Generation

```
Generate robust business logic for an invoice management system using AWS Titan's capabilities.

Business Requirements:
- Saudi Arabian tax calculations (15% VAT)
- Arabic invoice numbering system
- Multi-currency support (SAR primary)
- Payment terms and due date calculations
- Discount and tax handling

Technical Context:
- Flutter/Dart implementation
- Local-first with AWS sync
- Enterprise-grade error handling
- Audit trail requirements

Generate clean, well-documented Dart code with comprehensive error handling and business rule validation.
```

### Data Processing and Analysis

```
Analyze invoice data patterns for business insights using Titan's analytical capabilities.

<data_context>
Invoice Management System Data:
- Customer transaction patterns
- Payment behavior analysis
- Revenue trend identification
- Tax compliance reporting
- Business performance metrics
</data_context>

<analysis_requirements>
1. Identify key business metrics
2. Suggest automated reporting features
3. Recommend data visualization approaches
4. Propose predictive analytics opportunities
5. Design data export formats for accounting software
</analysis_requirements>

Focus on practical business value for small business owners in Saudi Arabia.
```

## Llama Models on Bedrock

### Open Source Integration

```
Leverage Llama's open-source strengths for cost-effective development solutions.

<development_context>
- Budget-conscious small business app
- Open-source friendly architecture
- Community-driven development approach
- Cost optimization priority
</development_context>

<task>
[SPECIFIC_DEVELOPMENT_TASK]
</task>

<constraints>
- Minimize AWS costs
- Leverage open-source libraries
- Maintain enterprise security standards
- Support offline-first architecture
</constraints>

Provide cost-effective solutions with open-source alternatives where appropriate.
```

### Community-Driven Development

```
Generate community-friendly documentation and contribution guidelines.

<project>
Baseer MVP - Open Source Invoice Management
Target: Arabic-speaking developer community
Goal: Encourage contributions and adoption
</project>

<documentation_needs>
1. Developer onboarding guide
2. Contribution guidelines
3. Architecture documentation
4. API reference
5. Deployment instructions
6. Community support channels
</documentation_needs>

Create comprehensive, welcoming documentation that encourages community participation.
```

---

## Bedrock-Specific Optimizations

### Cost Optimization Strategies

```json
{
  "model_selection": {
    "claude_3_5_sonnet": "Complex analysis and architecture decisions",
    "claude_3_haiku": "Quick code generation and simple tasks",
    "titan_text": "Business logic and data processing",
    "llama_2_70b": "Cost-effective general development tasks"
  },
  "usage_patterns": {
    "batch_processing": "Group similar requests to minimize API calls",
    "caching": "Cache common responses to reduce costs",
    "model_switching": "Use appropriate model for task complexity"
  }
}
```

### Enterprise Integration Patterns

```yaml
bedrock_integration:
  authentication:
    - IAM roles and policies
    - Cross-account access patterns
    - Service-to-service authentication

  monitoring:
    - CloudWatch metrics and alarms
    - Cost tracking and optimization
    - Performance monitoring

  security:
    - VPC endpoints for private access
    - Encryption in transit and at rest
    - Audit logging with CloudTrail

  scalability:
    - Auto-scaling based on demand
    - Multi-region deployment
    - Load balancing strategies
```

### Compliance and Governance

```
Design a compliance framework for AI usage in enterprise applications.

<compliance_requirements>
- Data residency (Saudi Arabia/Middle East)
- GDPR Article 22 (Automated decision-making)
- SOC 2 Type II compliance
- ISO 27001 alignment
- Saudi Data Protection Law compliance
</compliance_requirements>

<ai_usage_context>
- Invoice data processing
- Business analytics and insights
- Automated categorization
- Fraud detection capabilities
- Customer behavior analysis
</ai_usage_context>

<governance_framework>
1. AI model selection criteria
2. Data handling and privacy protection
3. Audit trail and logging requirements
4. Human oversight and intervention points
5. Risk assessment and mitigation
6. Regular compliance reviews
</governance_framework>

Provide a comprehensive compliance strategy for AI-powered business applications.
```

---

## Model-Specific Prompt Patterns

### Claude on Bedrock

```xml
<enterprise_context>
[Business and compliance context]
</enterprise_context>

<technical_requirements>
[Specific technical needs]
</technical_requirements>

<aws_integration>
[AWS service integration requirements]
</aws_integration>

<deliverables>
[Expected outputs and formats]
</deliverables>
```

### Titan Prompts

```
Business Context: [BUSINESS_DOMAIN]
Technical Stack: [TECHNOLOGY_DETAILS]
AWS Environment: [AWS_SERVICES_IN_USE]

Task: [SPECIFIC_TASK]

Requirements:
- Enterprise-grade quality
- Cost optimization
- AWS best practices
- Scalability considerations

Generate practical, implementable solutions with AWS service recommendations.
```

### Llama Prompts

```
Open Source Development Context:
Project: [PROJECT_NAME]
Community: [TARGET_COMMUNITY]
Budget: Cost-conscious
Approach: Community-driven

Task: [DEVELOPMENT_TASK]

Focus on:
- Open source best practices
- Community contribution friendly
- Cost-effective solutions
- Documentation and knowledge sharing

Provide solutions that encourage community participation and adoption.
```

---

## Integration with AWS Services

### Bedrock + Lambda Integration

```python
import boto3
import json

def lambda_handler(event, context):
    """
    AWS Lambda function for Bedrock AI integration
    Optimized for Flutter app backend services
    """

    bedrock = boto3.client('bedrock-runtime')

    # Model selection based on task complexity
    model_id = select_optimal_model(event['task_type'])

    # Prepare prompt with enterprise context
    prompt = prepare_enterprise_prompt(
        event['user_input'],
        event['business_context']
    )

    # Call Bedrock with cost optimization
    response = bedrock.invoke_model(
        modelId=model_id,
        body=json.dumps({
            'prompt': prompt,
            'max_tokens': calculate_optimal_tokens(event['task_type']),
            'temperature': get_optimal_temperature(event['task_type'])
        })
    )

    return process_bedrock_response(response)
```

### Cost Monitoring and Optimization

```yaml
cost_optimization:
  monitoring:
    - CloudWatch dashboards for Bedrock usage
    - Cost alerts and budgets
    - Usage pattern analysis

  optimization_strategies:
    - Model selection based on task complexity
    - Batch processing for similar requests
    - Response caching for common queries
    - Request deduplication

  governance:
    - Usage quotas per application
    - Approval workflows for high-cost operations
    - Regular cost review and optimization
```

---

**Usage Notes:**

- Choose models based on task complexity and cost requirements
- Leverage AWS integration for enterprise features
- Implement proper monitoring and cost controls
- Use IAM policies for fine-grained access control
- Consider data residency and compliance requirements
- Optimize for both performance and cost
