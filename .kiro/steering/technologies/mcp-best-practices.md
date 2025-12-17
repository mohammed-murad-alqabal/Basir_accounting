**المشروع:** بصير MVP
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**المصدر:** مكيف من مصادر مجتمع Kiro المعتمدة
**التاريخ:** 10 December 2025

---

---

title: MCP (Model Context Protocol) Best Practices
inclusion: always

---

# MCP (Model Context Protocol) Best Practices

## Server Configuration

- Use workspace-level config (`.kiro/settings/mcp.json`) for project-specific servers
- Use user-level config (`~/.kiro/settings/mcp.json`) for global/cross-workspace servers
- Workspace config takes precedence over user config for server name conflicts
- Always specify exact versions or use `@latest` for stability

## Installation and Setup

- Use `uvx` command for Python-based MCP servers (requires `uv` package manager)
- Install `uv` via pip, homebrew, or follow: https://docs.astral.sh/uv/getting-started/installation/
- No separate installation needed for uvx servers - they download automatically
- Test servers immediately after configuration, don't wait for issues

## Security and Auto-Approval

- Use `autoApprove` sparingly and only for trusted, low-risk tools
- Review tool capabilities before adding to auto-approve list
- Regularly audit auto-approved tools for security implications
- Consider environment-specific auto-approve settings

## Error Handling and Debugging

- Set `FASTMCP_LOG_LEVEL: "ERROR"` to reduce noise in logs
- Use `disabled: false` to temporarily disable problematic servers
- Servers reconnect automatically on config changes
- Use MCP Server view in Kiro feature panel for manual reconnection

### Validation and Testing

**Before Adding New Servers:**

```bash
# Validate package exists
npm view <package-name>

# Test package installation
npx <package-name> --help

# Verify MCP server functionality
timeout 10 npx <package-name>
```

**Configuration Validation:**

- Always test new server configurations immediately
- Use `disabled: true` for experimental servers
- Add timeout and retry settings for unreliable servers
- Monitor logs for connection issues

## Common MCP Server Examples for Flutter Development

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "uvx",
      "args": ["mcp-server-filesystem@latest"],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "disabled": false,
      "autoApprove": ["read_file", "list_directory"]
    },
    "git": {
      "command": "uvx",
      "args": ["mcp-server-git@latest"],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "disabled": false,
      "autoApprove": ["git_status", "git_diff", "git_log"]
    },
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite@latest"],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "disabled": false,
      "autoApprove": ["read_query"]
    }
  }
}
```

## Testing MCP Tools

- Test MCP tools immediately after configuration
- Don't inspect configurations unless facing specific issues
- Use sample calls to verify tool behavior
- Test with various parameter combinations
- Document working examples for team reference

## Performance Optimization

- Disable unused servers to improve startup time
- Use specific tool names in auto-approve rather than wildcards
- Monitor server resource usage and adjust as needed
- Consider server-specific environment variables for optimization

## Development Workflow

- Add MCP servers incrementally, test each addition
- Use version pinning for production environments
- Document server purposes and usage in team documentation
- Create project-specific server collections for different use cases

## Troubleshooting

- Check server logs in Kiro's MCP Server view
- Verify `uv` and `uvx` installation if Python servers fail
- Test server connectivity outside of Kiro if needed
- Use command palette "MCP" commands for server management
- Restart servers via MCP Server view rather than restarting Kiro

### Common Package Issues

**Package Not Found Errors:**

- Verify package exists: `npm view <package-name>`
- Check correct package name (e.g., `@upstash/context7-mcp` not `context7-mcp-server`)
- Use exact package names from official documentation
- Clear npm cache if needed: `npm cache clean --force`

**Context7 MCP Server:**

- Correct package: `@upstash/context7-mcp@latest`
- Command: `npx -y @upstash/context7-mcp`
- If seeing "context7-mcp-server not found", update configuration to use correct package name

### Error Resolution Steps

1. **Identify the failing package** from error logs
2. **Verify package exists** using `npm view <package>`
3. **Check official documentation** for correct package name
4. **Update configuration** with correct package reference
5. **Clear caches** if package was previously cached incorrectly
6. **Restart MCP servers** via Kiro MCP Server view

## Best Practices for Tool Usage

- Understand tool capabilities before first use
- Use descriptive prompts when calling MCP tools
- Handle tool errors gracefully in workflows
- Combine multiple MCP tools for complex tasks
- Cache results when appropriate to avoid repeated calls

## Flutter Development Integration

- Use filesystem MCP server for project file management and analysis
- Leverage git MCP server for version control operations and history tracking
- Use sqlite MCP server for local database operations and testing
- Reference Flutter and Dart documentation through appropriate MCP servers
- Focus on MCP servers that support local-first development workflows
