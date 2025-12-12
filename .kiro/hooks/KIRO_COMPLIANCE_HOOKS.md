# Kiro.dev Compliance Hooks

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 12 ديسمبر 2025

---

## Hooks المطلوبة للامتثال لـ Kiro.dev

### **1. Spec-Driven Development Hooks**

#### **Auto-Spec Creation Hook**

```json
{
  "enabled": true,
  "name": "Auto Spec Creation",
  "description": "Create spec structure when new feature requested",
  "when": {
    "type": "messageContains",
    "patterns": ["new feature", "add feature", "implement"]
  },
  "then": {
    "type": "askAgent",
    "prompt": "User is requesting a new feature. Guide them through spec-driven development: 1) Create requirements.md with EARS methodology, 2) Design architecture, 3) Break down into tasks. Ask if they want to start with requirements gathering."
  }
}
```

#### **Spec Validation Hook**

```json
{
  "enabled": true,
  "name": "Spec Validation",
  "description": "Validate spec completeness before implementation",
  "when": {
    "type": "fileEdited",
    "patterns": ["**/*tasks.md"]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Tasks file updated. Validate that: 1) Requirements exist and follow EARS, 2) Design is complete, 3) Tasks are properly broken down, 4) All requirements are covered by tasks."
  }
}
```

### **2. Background Task Delegation Hooks**

#### **Auto Documentation Update**

```json
{
  "enabled": true,
  "name": "Auto Documentation Update",
  "description": "Update documentation when code changes",
  "when": {
    "type": "fileEdited",
    "patterns": ["lib/**/*.dart"]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Dart code was modified. Check if documentation needs updating: 1) Update DartDoc comments, 2) Update README if public API changed, 3) Update architecture docs if structure changed."
  }
}
```

#### **Auto Test Generation**

```json
{
  "enabled": true,
  "name": "Auto Test Generation",
  "description": "Generate tests for new code",
  "when": {
    "type": "fileCreated",
    "patterns": ["lib/**/*.dart"]
  },
  "then": {
    "type": "askAgent",
    "prompt": "New Dart file created. Generate appropriate tests: 1) Unit tests for business logic, 2) Widget tests for UI components, 3) Integration tests for complete flows. Follow 70%+ coverage requirement."
  }
}
```

### **3. Quality Assurance Hooks**

#### **Code Quality Check**

```json
{
  "enabled": true,
  "name": "Code Quality Check",
  "description": "Check code quality before commit",
  "when": {
    "type": "beforeCommit"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Before committing, verify: 1) Code follows Flutter/Dart standards, 2) Tests pass, 3) No security issues, 4) Documentation updated, 5) Performance acceptable."
  }
}
```

#### **Security Scan Hook**

```json
{
  "enabled": true,
  "name": "Security Scan",
  "description": "Scan for security issues",
  "when": {
    "type": "fileEdited",
    "patterns": ["pubspec.yaml", "lib/**/*.dart"]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Code or dependencies changed. Run security checks: 1) Scan dependencies for vulnerabilities, 2) Check for hardcoded secrets, 3) Validate input sanitization, 4) Review authentication/authorization."
  }
}
```

### **4. Flutter-Specific Hooks**

#### **Flutter Performance Check**

```json
{
  "enabled": true,
  "name": "Flutter Performance Check",
  "description": "Check Flutter performance best practices",
  "when": {
    "type": "fileEdited",
    "patterns": ["lib/**/widgets/*.dart", "lib/**/screens/*.dart"]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Flutter UI code changed. Check performance: 1) Use const constructors, 2) Avoid rebuilds, 3) Optimize images, 4) Check for memory leaks, 5) Validate smooth animations."
  }
}
```

#### **Arabic RTL Validation**

```json
{
  "enabled": true,
  "name": "Arabic RTL Validation",
  "description": "Validate Arabic RTL support",
  "when": {
    "type": "fileEdited",
    "patterns": ["lib/**/widgets/*.dart", "lib/l10n/*.dart"]
  },
  "then": {
    "type": "askAgent",
    "prompt": "UI or localization changed. Validate Arabic RTL: 1) Text direction correct, 2) Layout mirrors properly, 3) Icons face correct direction, 4) Arabic text displays correctly."
  }
}
```

---

## Hook Installation Instructions

### **1. Copy hooks to appropriate directories:**

```bash
# Automatic hooks
cp hooks/auto-*.json .kiro/hooks/automatic/

# Manual hooks
cp hooks/manual-*.json .kiro/hooks/manual/

# Save hooks
cp hooks/save-*.json .kiro/hooks/on-save/

# Commit hooks
cp hooks/commit-*.json .kiro/hooks/on-commit/
```

### **2. Enable in Kiro IDE:**

1. Open Kiro IDE
2. Go to Settings → Hooks
3. Enable desired hooks
4. Configure triggers and actions
5. Test hook functionality

### **3. Customize for project:**

- Adjust file patterns for your structure
- Modify prompts for your workflow
- Add project-specific validations
- Configure notification preferences

---

## Hook Maintenance

### **Weekly Review:**

- Check hook performance
- Update patterns if needed
- Review triggered actions
- Optimize slow hooks

### **Monthly Audit:**

- Validate hook effectiveness
- Update prompts based on learnings
- Add new hooks for emerging needs
- Remove unused hooks

### **Quarterly Update:**

- Align with Kiro.dev updates
- Review compliance requirements
- Update documentation
- Train team on new hooks

---

**Status:** Ready for implementation  
**Priority:** High (Kiro.dev compliance)  
**Owner:** فريق وكلاء تطوير مشروع بصير
