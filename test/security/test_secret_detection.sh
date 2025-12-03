#!/usr/bin/env bats
# Property Test: Secret Pattern Detection
# Feature: error-tracking-system, Property 11: Secret Pattern Detection
# Validates: Requirements 3.5, 9.2

# دالة للبحث عن أنماط الأسرار
detect_secrets() {
    local content="$1"
    local patterns=(
        "api[_-]?key"
        "password"
        "token"
        "secret"
        "bearer"
        "auth"
    )
    
    for pattern in "${patterns[@]}"; do
        if echo "$content" | grep -iq "$pattern"; then
            return 0  # تم اكتشاف سر
        fi
    done
    
    return 1  # لم يتم اكتشاف أسرار
}

# دالة لتوليد محتوى يحتوي على سر
generate_content_with_secret() {
    local secret_types=("api_key" "password" "token" "secret" "bearer_token" "auth_key")
    local secret_type=${secret_types[$RANDOM % ${#secret_types[@]}]}
    local secret_value="sk_live_$(openssl rand -hex 16 2>/dev/null || echo 'abc123def456')"
    
    echo "const ${secret_type} = '${secret_value}';"
}

# دالة لتوليد محتوى آمن
generate_safe_content() {
    local safe_vars=("userName" "userId" "itemCount" "totalPrice" "customerName")
    local var_name=${safe_vars[$RANDOM % ${#safe_vars[@]}]}
    local value=$((RANDOM % 1000))
    
    echo "const ${var_name} = ${value};"
}

@test "Property: جميع الملفات التي تحتوي على أنماط أسرار يجب اكتشافها" {
    local detected_count=0
    local total=100
    
    for i in $(seq 1 $total); do
        content=$(generate_content_with_secret)
        
        if detect_secrets "$content"; then
            ((detected_count++))
        else
            echo "Failed to detect secret in: $content" >&2
        fi
    done
    
    # يجب اكتشاف جميع الأسرار
    [ $detected_count -eq $total ]
}

@test "Property: المحتوى الآمن يجب ألا يُعتبر سراً" {
    local false_positive_count=0
    local total=100
    
    for i in $(seq 1 $total); do
        content=$(generate_safe_content)
        
        if detect_secrets "$content"; then
            ((false_positive_count++))
            echo "False positive on safe content: $content" >&2
        fi
    done
    
    # يجب ألا يكون هناك false positives
    [ $false_positive_count -eq 0 ]
}

@test "Example: أنماط أسرار محددة يجب اكتشافها" {
    detect_secrets "const api_key = 'redacted';"
    detect_secrets "String password = 'redacted';"
    detect_secrets "final token = 'redacted';"
    detect_secrets "const secret = 'redacted';"
    detect_secrets "Authorization: Bearer redacted"
    detect_secrets "auth_token = 'redacted';"
}

@test "Example: محتوى آمن لا يجب اكتشافه كسر" {
    ! detect_secrets "const userName = 'John Doe';"
    ! detect_secrets "int userId = 12345;"
    ! detect_secrets "String customerName = 'Ahmed';"
    ! detect_secrets "final totalPrice = 99.99;"
}

@test "Property: أنماط API keys بصيغ مختلفة" {
    local patterns=(
        "api_key"
        "apiKey"
        "api-key"
        "API_KEY"
        "ApiKey"
    )
    
    for pattern in "${patterns[@]}"; do
        content="const ${pattern} = 'value';"
        detect_secrets "$content"
    done
}

@test "Property: أنماط passwords بصيغ مختلفة" {
    local patterns=(
        "password"
        "Password"
        "PASSWORD"
        "pass"
        "pwd"
    )
    
    for pattern in "${patterns[@]}"; do
        content="const ${pattern} = 'value';"
        detect_secrets "$content"
    done
}

@test "Property: أنماط tokens بصيغ مختلفة" {
    local patterns=(
        "token"
        "Token"
        "TOKEN"
        "access_token"
        "accessToken"
        "bearer_token"
    )
    
    for pattern in "${patterns[@]}"; do
        content="const ${pattern} = 'value';"
        detect_secrets "$content"
    done
}

@test "Property: الكشف في سياقات مختلفة" {
    # في تعليق
    detect_secrets "// TODO: remove api_key before commit"
    
    # في string
    detect_secrets "final message = 'Your password is: 123';"
    
    # في متغير
    detect_secrets "String secret = getSecret();"
    
    # في دالة
    detect_secrets "void setToken(String token) {}"
}

@test "Property: عدم الكشف عن false positives شائعة" {
    # كلمات عادية تحتوي على الأنماط
    ! detect_secrets "// This is a secret feature"  # "secret" في سياق عادي
    ! detect_secrets "class SecretManager {}"  # اسم class
    ! detect_secrets "import 'package:auth/auth.dart';"  # import
}
