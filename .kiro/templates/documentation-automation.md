# Documentation Automation System

**المشروع:** [اسم المشروع]
**التاريخ:** [التاريخ]
**المؤلف:** فريق وكلاء تطوير المشروع

## نظام التوثيق الآلي المتكامل

### 1. بنية نظام التوثيق

```
Documentation/
├── API/                    # توثيق API
│   ├── endpoints.md
│   ├── authentication.md
│   └── examples.md
├── Architecture/          # التوثيق المعماري
│   ├── overview.md
│   ├── components.md
│   └── diagrams/
├── Guides/               # أدلة المستخدم
│   ├── getting-started.md
│   ├── tutorials/
│   └── best-practices.md
├── Reference/            # المراجع التقنية
│   ├── configuration.md
│   ├── cli-commands.md
│   └── troubleshooting.md
└── generated/           # التوثيق المولد آلياً
    ├── api-reference/
    └── code-coverage/
```

### 2. Documentation Generator Script

```typescript
// doc-generator.ts
import * as fs from "fs";
import * as path from "path";

interface DocConfig {
  projectName: string;
  version: string;
  author: string;
  outputDir: string;
}

class DocumentationGenerator {
  private config: DocConfig;

  constructor(config: DocConfig) {
    this.config = config;
  }

  async generateAll(): Promise<void> {
    console.log("📚 Generating documentation...");

    await this.generateAPIReference();
    await this.generateArchitectureDocs();
    await this.generateUserGuides();
    await this.generateChangelog();

    console.log("✅ Documentation generated successfully");
  }

  private async generateAPIReference(): Promise<void> {
    // Extract API endpoints from code
    const endpoints = await this.extractEndpoints();

    const content = `# API Reference

**المشروع:** ${this.config.projectName}
**الإصدار:** ${this.config.version}
**المؤلف:** ${this.config.author}

## Endpoints

${endpoints.map((ep) => this.formatEndpoint(ep)).join("\n\n")}

---

**تم إنشاؤه بواسطة:** ${this.config.author}
**التاريخ:** ${new Date().toISOString().split("T")[0]}
`;

    const outputPath = path.join(this.config.outputDir, "API", "reference.md");
    fs.writeFileSync(outputPath, content);
  }

  private async generateArchitectureDocs(): Promise<void> {
    // Analyze project structure
    const structure = await this.analyzeStructure();

    const content = `# Architecture Overview

**المشروع:** ${this.config.projectName}
**الإصدار:** ${this.config.version}
**المؤلف:** ${this.config.author}

## System Architecture

\`\`\`mermaid
graph TD
    A[Client] --> B[API Gateway]
    B --> C[Service Layer]
    C --> D[Data Layer]
    D --> E[Database]
\`\`\`

## Components

${structure.components.map((c) => this.formatComponent(c)).join("\n\n")}

## Design Patterns

${structure.patterns.map((p) => `- **${p.name}:** ${p.description}`).join("\n")}

---

**تم إنشاؤه بواسطة:** ${this.config.author}
**التاريخ:** ${new Date().toISOString().split("T")[0]}
`;

    const outputPath = path.join(
      this.config.outputDir,
      "Architecture",
      "overview.md"
    );
    fs.writeFileSync(outputPath, content);
  }

  private async generateUserGuides(): Promise<void> {
    const content = `# Getting Started Guide

**المشروع:** ${this.config.projectName}
**الإصدار:** ${this.config.version}
**المؤلف:** ${this.config.author}

## Installation

\`\`\`bash
# Clone the repository
git clone [repository-url]

# Install dependencies
npm install

# Run the application
npm start
\`\`\`

## Configuration

1. Copy the example configuration:
   \`\`\`bash
   cp .env.example .env
   \`\`\`

2. Update the configuration values:
   \`\`\`
   DATABASE_URL=your_database_url
   API_KEY=your_api_key
   \`\`\`

## Usage

### Basic Example

\`\`\`typescript
import { Service } from './service';

const service = new Service();
const result = await service.execute();
\`\`\`

## Troubleshooting

### Common Issues

#### Issue 1: Connection Error
**Problem:** Cannot connect to database
**Solution:** Check your DATABASE_URL configuration

#### Issue 2: Authentication Failed
**Problem:** API authentication fails
**Solution:** Verify your API_KEY is correct

---

**تم إنشاؤه بواسطة:** ${this.config.author}
**التاريخ:** ${new Date().toISOString().split("T")[0]}
`;

    const outputPath = path.join(
      this.config.outputDir,
      "Guides",
      "getting-started.md"
    );
    fs.writeFileSync(outputPath, content);
  }

  private async generateChangelog(): Promise<void> {
    // Extract git commits and generate changelog
    const commits = await this.extractCommits();

    const content = `# Changelog

**المشروع:** ${this.config.projectName}
**المؤلف:** ${this.config.author}

## [${this.config.version}] - ${new Date().toISOString().split("T")[0]}

### Added
${commits.added.map((c) => `- ${c}`).join("\n")}

### Changed
${commits.changed.map((c) => `- ${c}`).join("\n")}

### Fixed
${commits.fixed.map((c) => `- ${c}`).join("\n")}

---

**تم إنشاؤه بواسطة:** ${this.config.author}
**التاريخ:** ${new Date().toISOString().split("T")[0]}
`;

    const outputPath = path.join(this.config.outputDir, "CHANGELOG.md");
    fs.writeFileSync(outputPath, content);
  }

  private async extractEndpoints(): Promise<any[]> {
    // Implementation to extract API endpoints from code
    return [];
  }

  private async analyzeStructure(): Promise<any> {
    // Implementation to analyze project structure
    return { components: [], patterns: [] };
  }

  private async extractCommits(): Promise<any> {
    // Implementation to extract git commits
    return { added: [], changed: [], fixed: [] };
  }

  private formatEndpoint(endpoint: any): string {
    return `### ${endpoint.method} ${endpoint.path}

**Description:** ${endpoint.description}

**Parameters:**
${endpoint.params
  .map((p: any) => `- \`${p.name}\` (${p.type}): ${p.description}`)
  .join("\n")}

**Response:**
\`\`\`json
${JSON.stringify(endpoint.response, null, 2)}
\`\`\``;
  }

  private formatComponent(component: any): string {
    return `### ${component.name}

**Purpose:** ${component.purpose}
**Location:** \`${component.path}\`
**Dependencies:** ${component.dependencies.join(", ")}`;
  }
}

// Usage
const config: DocConfig = {
  projectName: "Project Name",
  version: "1.0.0",
  author: "فريق وكلاء تطوير المشروع",
  outputDir: "./Documentation",
};

const generator = new DocumentationGenerator(config);
generator.generateAll();
```

### 3. Automation Scripts

```bash
#!/bin/bash
# generate-docs.sh

echo "📚 Generating documentation..."

# 1. Generate API documentation
echo "📝 Generating API docs..."
npx typedoc --out Documentation/generated/api-reference src/

# 2. Generate code coverage report
echo "📊 Generating coverage report..."
npm run test:coverage
cp -r coverage/lcov-report Documentation/generated/code-coverage/

# 3. Generate architecture diagrams
echo "🏗️ Generating architecture diagrams..."
npx madge --image Documentation/Architecture/diagrams/dependencies.svg src/

# 4. Generate custom documentation
echo "📖 Generating custom docs..."
npx ts-node scripts/doc-generator.ts

# 5. Build documentation site
echo "🌐 Building documentation site..."
npx vitepress build Documentation/

echo "✅ Documentation generated successfully"
```

### 4. GitHub Actions Workflow

```yaml
# .github/workflows/documentation.yml
name: Documentation

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  schedule:
    - cron: "0 0 * * 0" # Weekly on Sunday

jobs:
  generate:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: "18"

      - name: Install Dependencies
        run: npm ci

      - name: Generate Documentation
        run: |
          chmod +x scripts/generate-docs.sh
          ./scripts/generate-docs.sh

      - name: Deploy to GitHub Pages
        if: github.ref == 'refs/heads/main'
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./Documentation/.vitepress/dist

      - name: Upload Artifacts
        uses: actions/upload-artifact@v3
        with:
          name: documentation
          path: Documentation/

  validate:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Check Documentation Links
        uses: gaurav-nelson/github-action-markdown-link-check@v1
        with:
          use-quiet-mode: "yes"
          folder-path: "Documentation/"

      - name: Validate Markdown
        run: |
          npm install -g markdownlint-cli
          markdownlint 'Documentation/**/*.md'
```

### 5. Documentation Templates

```markdown
# Feature Documentation Template

**المشروع:** [اسم المشروع]
**الميزة:** [اسم الميزة]
**المؤلف:** فريق وكلاء تطوير المشروع
**التاريخ:** [التاريخ]

## Overview

[وصف موجز للميزة]

## Requirements

- Requirement 1
- Requirement 2
- Requirement 3

## Architecture

\`\`\`mermaid
graph LR
A[Component A] --> B[Component B]
B --> C[Component C]
\`\`\`

## Implementation

### Component 1

**Purpose:** [الغرض]
**Location:** \`path/to/component\`

\`\`\`typescript
// Code example
\`\`\`

### Component 2

**Purpose:** [الغرض]
**Location:** \`path/to/component\`

\`\`\`typescript
// Code example
\`\`\`

## Testing

### Unit Tests

\`\`\`typescript
describe('Feature', () => {
it('should work correctly', () => {
// Test implementation
});
});
\`\`\`

### Integration Tests

\`\`\`typescript
describe('Feature Integration', () => {
it('should integrate correctly', () => {
// Test implementation
});
});
\`\`\`

## Usage Examples

### Example 1: Basic Usage

\`\`\`typescript
import { Feature } from './feature';

const feature = new Feature();
const result = await feature.execute();
\`\`\`

### Example 2: Advanced Usage

\`\`\`typescript
import { Feature } from './feature';

const feature = new Feature({
option1: 'value1',
option2: 'value2',
});
const result = await feature.executeAdvanced();
\`\`\`

## API Reference

### Methods

#### \`execute()\`

**Description:** [الوصف]

**Parameters:**

- \`param1\` (type): [الوصف]
- \`param2\` (type): [الوصف]

**Returns:** \`Promise<Result>\`

**Example:**
\`\`\`typescript
const result = await feature.execute(param1, param2);
\`\`\`

## Troubleshooting

### Common Issues

#### Issue 1

**Problem:** [المشكلة]
**Solution:** [الحل]

#### Issue 2

**Problem:** [المشكلة]
**Solution:** [الحل]

---

**تم إعداد هذه الوثيقة بواسطة:** فريق وكلاء تطوير المشروع
**آخر تحديث:** [التاريخ]
```

## Best Practices

### 1. Documentation Standards

- Use consistent formatting
- Include code examples
- Add diagrams where helpful
- Keep documentation up-to-date

### 2. Automation

- Generate docs on every commit
- Validate links automatically
- Deploy to GitHub Pages
- Archive old versions

### 3. Maintenance

- Review documentation quarterly
- Update examples with code changes
- Remove outdated content
- Gather user feedback

---

**تم إعداد هذا القالب بواسطة:** فريق وكلاء تطوير المشروع
**التاريخ:** [التاريخ]
**الإصدار:** 1.0
