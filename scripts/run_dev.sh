#!/bin/bash

# Development Run Script
# يقوم بتشغيل التطبيق في وضع التطوير مع خيارات متقدمة

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default values
DEVICE=""
HOT_RELOAD=true
VERBOSE=false
PROFILE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--device)
            DEVICE="$2"
            shift 2
            ;;
        --no-hot-reload)
            HOT_RELOAD=false
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -p|--profile)
            PROFILE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -d, --device DEVICE    Run on specific device"
            echo "  --no-hot-reload        Disable hot reload"
            echo "  -v, --verbose          Verbose output"
            echo "  -p, --profile          Run in profile mode"
            echo "  -h, --help             Show this help"
            echo ""
            echo "Examples:"
            echo "  $0                     # Run on default device"
            echo "  $0 -d linux            # Run on Linux"
            echo "  $0 -d chrome           # Run on Chrome"
            echo "  $0 -p                  # Run in profile mode"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}🚀 تشغيل بصير MVP في وضع التطوير${NC}"
echo "=================================================="
echo ""

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter غير مثبت${NC}"
    exit 1
fi

# List available devices
echo -e "${YELLOW}📱 الأجهزة المتاحة:${NC}"
flutter devices
echo ""

# Build command
CMD="flutter run"

if [ -n "$DEVICE" ]; then
    CMD="$CMD -d $DEVICE"
fi

if [ "$HOT_RELOAD" = false ]; then
    CMD="$CMD --no-hot"
fi

if [ "$VERBOSE" = true ]; then
    CMD="$CMD -v"
fi

if [ "$PROFILE" = true ]; then
    CMD="$CMD --profile"
    echo -e "${YELLOW}⚠️  تشغيل في وضع Profile${NC}"
else
    CMD="$CMD --debug"
    echo -e "${GREEN}✅ تشغيل في وضع Debug${NC}"
fi

echo ""
echo -e "${BLUE}الأمر: $CMD${NC}"
echo ""

# Run the app
eval $CMD
