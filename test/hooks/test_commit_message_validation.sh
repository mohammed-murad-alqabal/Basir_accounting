#!/usr/bin/env bats
# Property Test: Commit Message Format Validation
# Feature: error-tracking-system, Property 10: Commit Message Format Validation
# Validates: Requirements 3.3

# دالة مساعدة للتحقق من رسالة commit
validate_commit_message() {
    local message="$1"
    local pattern="^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert|audit)(\(.+\))?: .{1,}"
    
    # تجاهل رسائل merge و revert
    if echo "$message" | grep -qE "^(Merge|Revert)"; then
        return 0
    fi
    
    if echo "$message" | grep -qE "$pattern"; then
        return 0
    else
        return 1
    fi
}

# دالة لتوليد رسالة commit عشوائية صحيحة
generate_valid_commit_message() {
    local types=("feat" "fix" "docs" "style" "refactor" "test" "chore" "perf" "ci" "build" "audit")
    local scopes=("auth" "invoice" "customer" "core" "ui" "api" "db")
    local descriptions=("add new feature" "fix bug" "update docs" "improve performance" "refactor code")
    
    local type=${types[$RANDOM % ${#types[@]}]}
    local scope=${scopes[$RANDOM % ${#scopes[@]}]}
    local desc=${descriptions[$RANDOM % ${#descriptions[@]}]}
    
    # 50% احتمال إضافة scope
    if [ $((RANDOM % 2)) -eq 0 ]; then
        echo "${type}(${scope}): ${desc}"
    else
        echo "${type}: ${desc}"
    fi
}

# دالة لتوليد رسالة commit عشوائية خاطئة
generate_invalid_commit_message() {
    local invalid_types=("feature" "bugfix" "update" "change" "modify")
    local type=${invalid_types[$RANDOM % ${#invalid_types[@]}]}
    local desc="some description"
    
    echo "${type}: ${desc}"
}

@test "Property: جميع رسائل الـ commit الصحيحة يجب أن تُقبل" {
    local success_count=0
    local total=100
    
    for i in $(seq 1 $total); do
        message=$(generate_valid_commit_message)
        
        if validate_commit_message "$message"; then
            ((success_count++))
        else
            echo "Failed on valid message: $message" >&2
        fi
    done
    
    # يجب أن تنجح جميع الرسائل الصحيحة
    [ $success_count -eq $total ]
}

@test "Property: جميع رسائل الـ commit الخاطئة يجب أن تُرفض" {
    local failure_count=0
    local total=100
    
    for i in $(seq 1 $total); do
        message=$(generate_invalid_commit_message)
        
        if ! validate_commit_message "$message"; then
            ((failure_count++))
        else
            echo "Accepted invalid message: $message" >&2
        fi
    done
    
    # يجب أن تفشل جميع الرسائل الخاطئة
    [ $failure_count -eq $total ]
}

@test "Property: رسائل Merge يجب أن تُقبل دائماً" {
    local merge_messages=(
        "Merge branch 'feature/auth'"
        "Merge pull request #123"
        "Merge remote-tracking branch 'origin/main'"
    )
    
    for message in "${merge_messages[@]}"; do
        validate_commit_message "$message"
    done
}

@test "Property: رسائل Revert يجب أن تُقبل دائماً" {
    local revert_messages=(
        "Revert \"feat: add login\""
        "Revert commit abc123"
    )
    
    for message in "${revert_messages[@]}"; do
        validate_commit_message "$message"
    done
}

@test "Example: رسائل صحيحة محددة" {
    validate_commit_message "feat(auth): add login functionality"
    validate_commit_message "fix(invoice): correct tax calculation"
    validate_commit_message "docs: update README"
    validate_commit_message "chore(logs): update logs [skip ci]"
    validate_commit_message "refactor: simplify code structure"
    validate_commit_message "audit: record control findings"
    validate_commit_message "audit(ledger): verify posting controls"
}

@test "Example: رسائل خاطئة محددة" {
    ! validate_commit_message "feature: add something"
    ! validate_commit_message "bugfix: fix issue"
    ! validate_commit_message "update: change file"
    ! validate_commit_message "feat:"
    ! validate_commit_message "random message"
}

@test "Property: رسائل مع scope يجب أن تُقبل" {
    local success_count=0
    local total=50
    
    for i in $(seq 1 $total); do
        local types=("feat" "fix" "docs")
        local type=${types[$RANDOM % ${#types[@]}]}
        message="${type}(scope): description"
        
        if validate_commit_message "$message"; then
            ((success_count++))
        fi
    done
    
    [ $success_count -eq $total ]
}

@test "Property: رسائل بدون scope يجب أن تُقبل" {
    local success_count=0
    local total=50
    
    for i in $(seq 1 $total); do
        local types=("feat" "fix" "docs")
        local type=${types[$RANDOM % ${#types[@]}]}
        message="${type}: description"
        
        if validate_commit_message "$message"; then
            ((success_count++))
        fi
    done
    
    [ $success_count -eq $total ]
}
