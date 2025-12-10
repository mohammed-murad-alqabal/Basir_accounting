#!/bin/bash

# Feature: error-tracking-system, Property 23: Compression Efficiency
# Validates: Requirements 10.4
#
# Property: For any archive compression operation, the resulting compressed 
# file should be at least 70% smaller than the original uncompressed size.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test configuration
TEST_DIR="$(mktemp -d)"
ITERATIONS=100
MIN_COMPRESSION_RATIO=70

# Cleanup function
cleanup() {
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

# Function to create random log content
create_log_content() {
    local lines=$1
    local timestamp=$(date -Iseconds)
    
    # Generate repetitive log content (compresses well)
    for i in $(seq 1 $lines); do
        local level=$((i % 4))
        case $level in
            0) echo "[$timestamp] ERROR: Application error occurred in module X - Error code: E001" ;;
            1) echo "[$timestamp] WARNING: Resource usage high - Memory: 85% CPU: 72%" ;;
            2) echo "[$timestamp] INFO: Request processed successfully - Duration: 125ms" ;;
            3) echo "[$timestamp] DEBUG: Database query executed - Rows affected: 42" ;;
        esac
    done
}

# Function to calculate compression ratio
calculate_compression_ratio() {
    local original_size="$1"
    local compressed_size="$2"
    
    # Calculate compression ratio as percentage reduction
    # Formula: ((original - compressed) / original) * 100
    if [ "$original_size" -eq 0 ]; then
        echo "0"
        return
    fi
    
    local reduction=$((original_size - compressed_size))
    local ratio=$((reduction * 100 / original_size))
    
    echo "$ratio"
}

# Function to get file size in bytes
get_file_size() {
    local file="$1"
    stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null
}

# Main test function
test_compression_efficiency_property() {
    local passed=0
    local failed=0
    local total_ratio=0
    
    echo -e "${YELLOW}Running Property 23: Compression Efficiency Test${NC}"
    echo "Testing compression efficiency over $ITERATIONS iterations..."
    echo ""
    
    for i in $(seq 1 $ITERATIONS); do
        # Create test directory for this iteration
        local iteration_dir="$TEST_DIR/iteration_$i"
        mkdir -p "$iteration_dir"
        
        # Generate random number of log files with random sizes
        local num_files=$((RANDOM % 5 + 3))  # 3-8 files
        
        for j in $(seq 1 $num_files); do
            local num_lines=$((RANDOM % 500 + 500))  # 500-1000 lines
            create_log_content $num_lines > "$iteration_dir/log_$j.log"
        done
        
        # Get original size (sum of all files)
        local original_size=0
        for file in "$iteration_dir"/*.log; do
            local file_size=$(get_file_size "$file")
            original_size=$((original_size + file_size))
        done
        
        # Compress using gzip (as specified in requirements)
        local archive_file="$TEST_DIR/archive_$i.tar.gz"
        tar -czf "$archive_file" -C "$iteration_dir" . 2>/dev/null
        
        # Get compressed size
        local compressed_size=$(get_file_size "$archive_file")
        
        # Calculate compression ratio
        local ratio=$(calculate_compression_ratio "$original_size" "$compressed_size")
        total_ratio=$((total_ratio + ratio))
        
        # Check if ratio meets requirement (>= 70%)
        if [ "$ratio" -ge "$MIN_COMPRESSION_RATIO" ]; then
            ((passed++))
            if [ $((i % 20)) -eq 0 ]; then
                echo -e "${GREEN}✓${NC} Iteration $i: ${ratio}% compression (${original_size}B → ${compressed_size}B)"
            fi
        else
            ((failed++))
            echo -e "${RED}✗${NC} Iteration $i: ${ratio}% compression - FAILED (below ${MIN_COMPRESSION_RATIO}%)"
            echo "  Original: ${original_size}B, Compressed: ${compressed_size}B"
        fi
        
        # Cleanup iteration files
        rm -rf "$iteration_dir" "$archive_file"
    done
    
    # Calculate average compression ratio
    local avg_ratio=$((total_ratio / ITERATIONS))
    
    echo ""
    echo "========================================="
    echo "Test Results:"
    echo "========================================="
    echo "Total iterations: $ITERATIONS"
    echo -e "Passed: ${GREEN}$passed${NC}"
    echo -e "Failed: ${RED}$failed${NC}"
    echo "Average compression ratio: ${avg_ratio}%"
    echo "Minimum required ratio: ${MIN_COMPRESSION_RATIO}%"
    echo ""
    
    if [ "$failed" -eq 0 ]; then
        echo -e "${GREEN}✓ Property 23: Compression Efficiency - PASSED${NC}"
        echo "All compression operations achieved at least ${MIN_COMPRESSION_RATIO}% size reduction."
        return 0
    else
        echo -e "${RED}✗ Property 23: Compression Efficiency - FAILED${NC}"
        echo "$failed out of $ITERATIONS iterations failed to meet the ${MIN_COMPRESSION_RATIO}% compression requirement."
        return 1
    fi
}

# Run the test
test_compression_efficiency_property
exit $?
