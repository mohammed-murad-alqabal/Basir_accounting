# Comprehensive Error Handling Guide

**Project:** Basir MVP  
**Date:** December 6, 2025  
**Author:** Basir Project Agentic Development Team  
**Version:** 1.0  
**Status:** ✅ Active and Approved

---

## Overview

This guide explains how to use the Comprehensive Error Handling Library (`error_handler.sh`) across all scripts within the error tracking and logging ecosystem.

---

## Contents

1. [Loading and Initialization](#loading-and-initialization)
2. [Colorized Output Functions](#colorized-output-functions)
3. [Logging Functions](#logging-functions)
4. [Error Management](#error-management)
5. [Automatic Recovery](#automatic-recovery)
6. [Validation and Investigation](#validation-and-investigation)
7. [Cleanup](#cleanup)
8. [Practical Examples](#practical-examples)

---

## Loading and Initialization

### Basic Method

```bash
#!/bin/bash

# Determine script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load the error handling library
if [ -f "$SCRIPT_DIR/utils/error_handler.sh" ]; then
    source "$SCRIPT_DIR/utils/error_handler.sh"
else
    echo "Error: Error handling library not found" >&2
    exit 1
fi
```

### With Additional Settings

```bash
#!/bin/bash

set -o errexit   # Exit on any error
set -o nounset   # Exit on unset variables
set -o pipefail  # Pipeline fails if any command fails

# Load the library
source "$(dirname "$0")/utils/error_handler.sh"
```

---

## Colorized Output Functions

### Available Functions

| Function         | Color   | Usage                 |
| :--------------- | :------ | :-------------------- |
| `print_debug`    | Cyan    | Debugging messages    |
| `print_info`     | Blue    | General information   |
| `print_success`  | Green   | Successful operations |
| `print_warning`  | Yellow  | Warnings              |
| `print_error`    | Red     | Errors                |
| `print_critical` | Magenta | Critical failures     |

### Examples

```bash
# Informational messages
print_info "Starting script execution..."
print_debug "Variable value: $variable"

# Success messages
print_success "Operation completed successfully!"

# Warnings and Errors
print_warning "This is a warning - attention may be needed"
print_error "An error occurred during execution"
print_critical "Critical error - immediate intervention required!"
```

---

## Logging Functions

### Available Functions

| Function       | Level    | Description               |
| :------------- | :------- | :------------------------ |
| `log_debug`    | DEBUG    | Log debugging information |
| `log_info`     | INFO     | Log general information   |
| `log_warning`  | WARNING  | Log warnings              |
| `log_error`    | ERROR    | Log errors                |
| `log_critical` | CRITICAL | Log critical errors       |

### Log Format

```
[2025-12-06 10:30:45] [INFO] [script_name.sh] Log message
```

### Examples

```bash
# Logging information
log_info "Starting file processing..."
log_debug "File count: $file_count"

# Logging warnings and errors
log_warning "File not found: $file_path"
log_error "Command execution failed: $command"
log_critical "Critical system failure!"
```

### Log File Location

Default location: `logs/errors/error_YYYY-MM-DD.log`

Can be overridden:

```bash
export ERROR_LOG_FILE="custom/path/error.log"
```

---

## Error Management

### 1. General Error Handler

```bash
handle_error exit_code "Error message" [line_number] [function_name]
```

**Example:**

```bash
if ! some_command; then
    handle_error 1 "Failed to execute some_command" "$LINENO" "${FUNCNAME[0]}"
fi
```

### 2. Command Error Handler

```bash
handle_command_error "command" exit_code "error_output"
```

**Example:**

```bash
output=$(flutter analyze 2>&1)
exit_code=$?

if [ $exit_code -ne 0 ]; then
    handle_command_error "flutter analyze" $exit_code "$output"
fi
```

**Automatic Suggestions:**

- Code 1: Verify parameters
- Code 2: Verify permissions
- Code 126: Verify execution permissions
- Code 127: Command not found

### 3. File Error Handler

```bash
handle_file_error "operation" "file_path" "error_message"
```

**Supported Operations:**

- `read` - Read file
- `write` - Write file
- `delete` - Delete file
- `create` - Create file

**Example:**

```bash
if [ ! -f "$config_file" ]; then
    handle_file_error "read" "$config_file" "File does not exist"
fi
```

### 4. Network Error Handler

```bash
handle_network_error "operation" "url" "error_code"
```

**Example:**

```bash
if ! curl -f "$url" > /dev/null 2>&1; then
    handle_network_error "download" "$url" "timeout"
fi
```

---

## Automatic Recovery

### 1. Automatic Retry

```bash
retry_command max_attempts delay "command"
```

**Parameters:**

- `max_attempts`: Number of attempts (default: 3)
- `delay`: Delay between attempts in seconds (default: 2)
- `command`: Command to execute

**Example:**

```bash
# Attempt 3 times with 2-second delay
if retry_command 3 2 "curl -f https://example.com"; then
    print_success "Connection successful"
else
    log_error "Connection failed after 3 attempts"
fi
```

### 2. File Backup

```bash
backup_file "file_path" ["backup_dir"]
```

**Example:**

```bash
# Create backup before modification
if backup_file "config.yml" "backups"; then
    # Safely modify file
    echo "new_config" > config.yml
fi
```

### 3. Restore from Backup

```bash
restore_backup "backup_path" "target_path"
```

**Example:**

```bash
# Restore from backup
if restore_backup "backups/config.yml.backup.20251206" "config.yml"; then
    print_success "File restored"
fi
```

---

## Validation and Investigation

### 1. Command Verification

```bash
check_command "command_name"
```

**Example:**

```bash
# Verify requirements
if ! check_command "flutter"; then
    log_error "Flutter is not installed"
    exit 1
fi

if ! check_command "git"; then
    log_warning "Git is not installed - some features may not work"
fi
```

### 2. File and Directory Verification

```bash
check_file "file_path"
check_directory "dir_path"
```

**Example:**

```bash
# Verify structure
if ! check_directory "logs"; then
    log_info "Creating logs directory..."
    mkdir -p logs
fi

if check_file "config.yml"; then
    log_info "Loading configuration..."
    source config.yml
fi
```

### 3. Disk Space Verification

```bash
check_disk_space required_mb [path]
```

**Example:**

```bash
# Verify 500MB availability
if ! check_disk_space 500 "."; then
    log_error "Insufficient disk space"
    # Cleanup or archive
    cleanup_old_files
fi
```

### 4. Write Permission Verification

```bash
check_write_permission "path"
```

**Example:**

```bash
if ! check_write_permission "logs"; then
    log_error "No write permissions for logs"
    exit 1
fi
```

---

## Cleanup

### Temporary File Cleanup

```bash
cleanup_temp_files [temp_dir] [pattern]
```

**Parameters:**

- `temp_dir`: Temporary directory (default: /tmp)
- `pattern`: File pattern (default: basir\_\*)

**Example:**

```bash
# Cleanup at script end
cleanup_temp_files "/tmp" "my_script_*"
```

---

## Practical Examples

### Example 1: Simple Script with Error Handling

```bash
#!/bin/bash

# Load library
source "$(dirname "$0")/utils/error_handler.sh"

# Start execution
print_info "Starting data processing..."

# Verify requirements
check_command "flutter" || exit 1
check_directory "data" || mkdir -p data

# Execute operation
if flutter analyze > /dev/null 2>&1; then
    print_success "Analysis successful!"
else
    log_error "Analysis failed"
    exit 1
fi

print_info "Script completed successfully"
```

### Example 2: Script with Automatic Retry

```bash
#!/bin/bash

source "$(dirname "$0")/utils/error_handler.sh"

print_info "Downloading data from server..."

# Attempt download with retries
if retry_command 5 3 "curl -f https://api.example.com/data"; then
    print_success "Download successful"
else
    log_error "Download failed after 5 attempts"
    exit 1
fi
```

### Example 3: Script with Backup

```bash
#!/bin/bash

source "$(dirname "$0")/utils/error_handler.sh"

CONFIG_FILE="config.yml"

print_info "Updating configuration file..."

# Create backup
if ! backup_file "$CONFIG_FILE" "backups"; then
    log_error "Failed to create backup"
    exit 1
fi

# Update file
if ! update_config "$CONFIG_FILE"; then
    log_error "Update failed - restoring backup"

    # Restore from backup
    BACKUP=$(ls -t backups/config.yml.backup.* | head -1)
    restore_backup "$BACKUP" "$CONFIG_FILE"
    exit 1
fi

print_success "Update successful"
```

### Example 4: Comprehensive Script

```bash
#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Load library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/error_handler.sh"

# Main function
main() {
    print_info "═══ Starting Script ═══"

    # 1. Verify requirements
    print_info "Verifying requirements..."
    check_command "flutter" || exit 1
    check_command "git" || exit 1
    check_disk_space 100 "." || exit 1

    # 2. Create structure
    print_info "Creating structure..."
    mkdir -p logs/{archive,errors,reports}

    # 3. Execute operations
    print_info "Executing operations..."

    if retry_command 3 2 "flutter pub get"; then
        print_success "Dependencies downloaded"
    else
        log_error "Failed to download dependencies"
        return 1
    fi

    if flutter analyze > /dev/null 2>&1; then
        print_success "Analysis successful"
    else
        log_warning "Analysis found issues"
    fi

    # 4. Cleanup
    print_info "Cleaning up..."
    cleanup_temp_files

    print_success "═══ Script completed successfully ═══"
    return 0
}

# Execute
main "$@"
exit_code=$?

# Print summary
print_error_summary

exit $exit_code
```

---

## Best Practices

### 1. Use the Appropriate Level

```bash
# ✅ Good
log_debug "Variable value: $var"
log_info "Operation start..."
log_warning "File does not exist"
log_error "Command failed"
log_critical "Critical system error"

# ❌ Bad
log_error "Operation start..."  # Use log_info
log_info "Critical error!"      # Use log_critical
```

### 2. Provide Context for Errors

```bash
# ✅ Good
log_error "Failed to execute flutter analyze at line $LINENO"
log_error "File not found: $file_path"

# ❌ Bad
log_error "Error"
log_error "Failed"
```

### 3. Use Retries for Unstable Operations

```bash
# ✅ Good - Network operations
retry_command 3 2 "curl -f $url"

# ✅ Good - Operations that may transiently fail
retry_command 2 1 "git push"

# ❌ Bad - Stable local operations
retry_command 3 2 "ls -la"  # Unnecessary
```

### 4. Create Backups Before Critical Modifications

```bash
# ✅ Good
backup_file "$important_file" "backups"
modify_file "$important_file"

# ❌ Bad
modify_file "$important_file"  # No backup
```

### 5. Always Clean Up Resources

```bash
# ✅ Good
trap cleanup_temp_files EXIT

# Or at the end of the script
cleanup_temp_files
```

---

## Troubleshooting

### Problem: Library does not load

**Solution:**

```bash
# Verify path
ls -la scripts/utils/error_handler.sh

# Verify permissions
chmod +x scripts/utils/error_handler.sh
```

### Problem: Unable to write to log file

**Solution:**

```bash
# Verify directory existence
mkdir -p logs/errors

# Verify permissions
chmod 755 logs/errors
```

### Problem: Colors do not appear

**Solution:**

```bash
# Verify color support
echo -e "\033[0;31mTest\033[0m"

# Or disable colors
export NO_COLOR=1
```

---

## Quick Reference

### Printing Functions

- `print_debug` - Debugging
- `print_info` - Information
- `print_success` - Success
- `print_warning` - Warning
- `print_error` - Error
- `print_critical` - Critical

### Logging Functions

- `log_debug` - Log DEBUG
- `log_info` - Log INFO
- `log_warning` - Log WARNING
- `log_error` - Log ERROR
- `log_critical` - Log CRITICAL

### Error Handling

- `handle_error` - General handler
- `handle_command_error` - Command errors
- `handle_file_error` - File errors
- `handle_network_error` - Network errors

### Recovery

- `retry_command` - Retry command
- `backup_file` - Backup file
- `restore_backup` - Restore backup

### Verification

- `check_command` - Verify command
- `check_file` - Verify file
- `check_directory` - Verify directory
- `check_disk_space` - Verify space
- `check_write_permission` - Verify permissions

### Cleanup

- `cleanup_temp_files` - Clean temporary files
- `print_error_summary` - Print error summary

---

**This guide was prepared by:** Basir Project Agentic Development Team  
**Date:** December 6, 2025  
**Status:** ✅ Approved and Active
