#!/bin/bash

# Release Management Script for Basir ERP Development
# This script automates the creation and management of release branches
# 
# Author: فريق وكلاء تطوير مشروع بصير

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CURRENT_DATE=$(date +%Y-%m-%d)

# Function to display help
show_help() {
    echo -e "${BLUE}🚀 Basir ERP Release Management Script${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo "  $0 <command> [options]"
    echo ""
    echo -e "${YELLOW}Commands:${NC}"
    echo "  create <version> <type>     Create a new release branch"
    echo "  finalize <version>          Finalize and merge a release"
    echo "  list                        List all release branches"
    echo "  status <version>            Show status of a release branch"
    echo "  validate <version>          Validate version format"
    echo "  next <current> <type>       Calculate next version"
    echo ""
    echo -e "${YELLOW}Release Types:${NC}"
    echo "  major    - Breaking changes, new ERP modules (1.0.0 -> 2.0.0)"
    echo "  minor    - New features, enhancements (1.0.0 -> 1.1.0)"
    echo "  patch    - Bug fixes, security patches (1.0.0 -> 1.0.1)"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  $0 create v1.2.0 minor"
    echo "  $0 finalize v1.2.0"
    echo "  $0 list"
    echo "  $0 next v1.1.0 minor"
    echo ""
    echo -e "${YELLOW}ERP-Specific Guidelines:${NC}"
    echo "  • Major: New modules (HR, Payroll), breaking API changes"
    echo "  • Minor: Enhanced features, new reports, ZATCA updates"
    echo "  • Patch: Bug fixes, security patches, minor corrections"
}

# Function to validate version format
validate_version() {
    local version="$1"
    
    # Remove 'v' prefix if present
    local clean_version="${version#v}"
    
    # Check semantic version pattern
    if [[ ! $clean_version =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*)?$ ]]; then
        echo -e "${RED}❌ Invalid version format: $version${NC}"
        echo -e "${YELLOW}Expected format: v1.2.3 or v1.2.3-beta${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Valid version format: $version${NC}"
    return 0
}

# Function to check if branch exists
branch_exists() {
    local branch="$1"
    git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null
}

# Function to get current branch
get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Function to create release branch
create_release() {
    local version="$1"
    local release_type="$2"
    
    if [[ -z "$version" || -z "$release_type" ]]; then
        echo -e "${RED}❌ Error: Version and release type are required${NC}"
        echo "Usage: $0 create <version> <type>"
        return 1
    fi
    
    # Validate version
    if ! validate_version "$version"; then
        return 1
    fi
    
    # Validate release type
    case "$release_type" in
        major|minor|patch)
            ;;
        *)
            echo -e "${RED}❌ Invalid release type: $release_type${NC}"
            echo -e "${YELLOW}Valid types: major, minor, patch${NC}"
            return 1
            ;;
    esac
    
    local branch_name="release/$version"
    
    # Check if branch already exists
    if branch_exists "$branch_name"; then
        echo -e "${RED}❌ Release branch $branch_name already exists${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🚀 Creating release branch: $branch_name${NC}"
    echo -e "${YELLOW}📋 Release type: $release_type${NC}"
    
    # Ensure we're on development branch
    echo -e "${YELLOW}📍 Switching to development branch...${NC}"
    if ! git checkout development; then
        echo -e "${RED}❌ Failed to checkout development branch${NC}"
        return 1
    fi
    
    # Pull latest changes
    echo -e "${YELLOW}📥 Pulling latest changes...${NC}"
    if ! git pull origin development; then
        echo -e "${RED}❌ Failed to pull latest changes${NC}"
        return 1
    fi
    
    # Create release branch
    echo -e "${YELLOW}🌿 Creating release branch...${NC}"
    if ! git checkout -b "$branch_name"; then
        echo -e "${RED}❌ Failed to create release branch${NC}"
        return 1
    fi
    
    # Update version in pubspec.yaml
    echo -e "${YELLOW}📝 Updating version in pubspec.yaml...${NC}"
    local clean_version="${version#v}"
    if [[ -f "pubspec.yaml" ]]; then
        # Create backup
        cp pubspec.yaml pubspec.yaml.backup
        
        # Update version
        sed -i.tmp "s/^version:.*/version: $clean_version+1/" pubspec.yaml
        rm pubspec.yaml.tmp 2>/dev/null || true
        
        # Stage the change
        git add pubspec.yaml
        
        echo -e "${GREEN}✅ Version updated to $clean_version${NC}"
    else
        echo -e "${YELLOW}⚠️  pubspec.yaml not found, skipping version update${NC}"
    fi
    
    # Create release notes template
    echo -e "${YELLOW}📄 Creating release notes template...${NC}"
    create_release_notes_template "$version" "$release_type"
    
    # Create release checklist
    echo -e "${YELLOW}📋 Creating release checklist...${NC}"
    create_release_checklist "$version" "$release_type"
    
    # Initial commit
    git add .
    git commit -m "chore: initialize release $version

- Update version in pubspec.yaml
- Add release notes template
- Add release checklist

Release Type: $release_type
المؤلف: فريق وكلاء تطوير مشروع بصير"
    
    # Push branch
    echo -e "${YELLOW}📤 Pushing release branch...${NC}"
    if git push -u origin "$branch_name"; then
        echo -e "${GREEN}🎉 Release branch $branch_name created successfully!${NC}"
        echo ""
        echo -e "${BLUE}📋 Next steps:${NC}"
        echo "1. Complete development and testing on this branch"
        echo "2. Update RELEASE_NOTES_$version.md with actual changes"
        echo "3. Complete RELEASE_CHECKLIST_$version.md"
        echo "4. Run: $0 finalize $version"
        echo ""
        echo -e "${YELLOW}📁 Files created:${NC}"
        echo "  • RELEASE_NOTES_$version.md"
        echo "  • RELEASE_CHECKLIST_$version.md"
    else
        echo -e "${RED}❌ Failed to push release branch${NC}"
        return 1
    fi
}

# Function to create release notes template
create_release_notes_template() {
    local version="$1"
    local release_type="$2"
    
    local description=""
    case "$release_type" in
        major)
            description="Major version with breaking changes"
            ;;
        minor)
            description="Minor version with new features"
            ;;
        patch)
            description="Patch version with bug fixes"
            ;;
    esac
    
    cat > "RELEASE_NOTES_$version.md" << EOF
# Release Notes - $version

## Release Type: $description

## Changes in this Release

### New Features
- [ ] Feature 1
- [ ] Feature 2

### Bug Fixes
- [ ] Fix 1
- [ ] Fix 2

### Improvements
- [ ] Improvement 1
- [ ] Improvement 2

### ERP Module Updates
- [ ] Accounting: 
- [ ] Invoices: 
- [ ] Customers: 
- [ ] Vendors: 
- [ ] Inventory: 
- [ ] Reports: 

### ZATCA Compliance
- [ ] Compliance update 1
- [ ] Compliance update 2

### Breaking Changes
$(if [[ "$release_type" == "major" ]]; then
    echo "- [ ] Breaking change 1"
    echo "- [ ] Breaking change 2"
else
    echo "- None"
fi)

### Migration Guide
$(if [[ "$release_type" == "major" ]]; then
    echo "- [ ] Migration step 1"
    echo "- [ ] Migration step 2"
else
    echo "- No migration required"
fi)

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] Performance testing completed

## Documentation
- [ ] API documentation updated
- [ ] User guide updated
- [ ] Developer documentation updated

---
**Prepared by:** فريق وكلاء تطوير مشروع بصير
**Date:** $CURRENT_DATE
EOF
}

# Function to create release checklist
create_release_checklist() {
    local version="$1"
    local release_type="$2"
    
    local full_testing=""
    local doc_update=""
    
    if [[ "$release_type" == "major" || "$release_type" == "minor" ]]; then
        full_testing="- [ ] Full regression testing completed"
        doc_update="- [ ] Documentation updated"
    fi
    
    cat > "RELEASE_CHECKLIST_$version.md" << EOF
# Release Checklist - $version

## Pre-Release Checks
- [ ] All tests pass (flutter test)
- [ ] Code analysis passes (flutter analyze)
- [ ] No security vulnerabilities
- [ ] Performance benchmarks meet requirements
$full_testing
$doc_update

## ERP-Specific Checks
- [ ] Accounting equation integrity verified
- [ ] ZATCA compliance maintained
- [ ] Invoice generation tested
- [ ] Customer/Vendor management tested
- [ ] Inventory calculations verified
- [ ] Report generation tested

## Release Process
- [ ] Release branch created from development
- [ ] Version updated in pubspec.yaml
- [ ] Release notes prepared
- [ ] All changes committed and pushed
- [ ] Pull request created for main branch
- [ ] Code review completed
- [ ] CI/CD pipeline passes

## Post-Release
- [ ] Tag created and pushed
- [ ] Release notes published
- [ ] Changes merged back to development
- [ ] Release branch cleaned up
- [ ] Stakeholders notified

---
**Release Manager:** فريق وكلاء تطوير مشروع بصير
**Date:** $CURRENT_DATE
EOF
}

# Function to finalize release
finalize_release() {
    local version="$1"
    
    if [[ -z "$version" ]]; then
        echo -e "${RED}❌ Error: Version is required${NC}"
        echo "Usage: $0 finalize <version>"
        return 1
    fi
    
    local branch_name="release/$version"
    local current_branch=$(get_current_branch)
    
    # Check if we're on the correct release branch
    if [[ "$current_branch" != "$branch_name" ]]; then
        echo -e "${RED}❌ Must be on release branch $branch_name to finalize${NC}"
        echo -e "${YELLOW}Current branch: $current_branch${NC}"
        echo -e "${YELLOW}Run: git checkout $branch_name${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🏁 Finalizing release: $version${NC}"
    
    # Run pre-release checks
    echo -e "${YELLOW}🔍 Running pre-release checks...${NC}"
    
    # Flutter analyze
    echo -e "${YELLOW}  📊 Running flutter analyze...${NC}"
    if ! flutter analyze; then
        echo -e "${RED}❌ Flutter analyze failed${NC}"
        return 1
    fi
    
    # Flutter test
    echo -e "${YELLOW}  🧪 Running flutter test...${NC}"
    if ! flutter test; then
        echo -e "${RED}❌ Tests failed${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Pre-release checks passed${NC}"
    
    # Check if release notes exist and are updated
    if [[ -f "RELEASE_NOTES_$version.md" ]]; then
        if grep -q "Feature 1" "RELEASE_NOTES_$version.md"; then
            echo -e "${YELLOW}⚠️  Release notes appear to contain template content${NC}"
            echo -e "${YELLOW}Please update RELEASE_NOTES_$version.md before finalizing${NC}"
            read -p "Continue anyway? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                return 1
            fi
        fi
    fi
    
    # Merge to main
    echo -e "${YELLOW}🔄 Merging to main branch...${NC}"
    git checkout main
    git pull origin main
    
    if ! git merge --no-ff "$branch_name"; then
        echo -e "${RED}❌ Failed to merge to main${NC}"
        return 1
    fi
    
    # Push main
    if ! git push origin main; then
        echo -e "${RED}❌ Failed to push to main${NC}"
        return 1
    fi
    
    # Create and push tag
    echo -e "${YELLOW}🏷️  Creating tag...${NC}"
    local release_notes=""
    if [[ -f "RELEASE_NOTES_$version.md" ]]; then
        release_notes="Release $version - See RELEASE_NOTES_$version.md for details"
    else
        release_notes="Release $version"
    fi
    
    if ! git tag -a "$version" -m "$release_notes"; then
        echo -e "${RED}❌ Failed to create tag${NC}"
        return 1
    fi
    
    if ! git push origin "$version"; then
        echo -e "${RED}❌ Failed to push tag${NC}"
        return 1
    fi
    
    # Merge back to development
    echo -e "${YELLOW}🔄 Merging back to development...${NC}"
    git checkout development
    git pull origin development
    
    if ! git merge --no-ff "$branch_name"; then
        echo -e "${RED}❌ Failed to merge back to development${NC}"
        return 1
    fi
    
    if ! git push origin development; then
        echo -e "${RED}❌ Failed to push to development${NC}"
        return 1
    fi
    
    # Clean up release branch
    echo -e "${YELLOW}🧹 Cleaning up release branch...${NC}"
    git branch -d "$branch_name"
    git push origin --delete "$branch_name"
    
    echo -e "${GREEN}🎉 Release $version finalized successfully!${NC}"
    echo ""
    echo -e "${BLUE}📋 What happened:${NC}"
    echo "  ✅ Merged $branch_name to main"
    echo "  ✅ Created and pushed tag $version"
    echo "  ✅ Merged back to development"
    echo "  ✅ Cleaned up release branch"
    echo ""
    echo -e "${YELLOW}📋 Next steps:${NC}"
    echo "  • Publish release notes"
    echo "  • Notify stakeholders"
    echo "  • Update deployment"
}

# Function to list release branches
list_releases() {
    echo -e "${BLUE}📋 Release Branches${NC}"
    echo ""
    
    # List local release branches
    local local_branches=$(git branch | grep "release/" | sed 's/^[ *]*//')
    if [[ -n "$local_branches" ]]; then
        echo -e "${YELLOW}Local branches:${NC}"
        echo "$local_branches" | while read -r branch; do
            echo "  🌿 $branch"
        done
        echo ""
    fi
    
    # List remote release branches
    local remote_branches=$(git branch -r | grep "origin/release/" | sed 's/^[ *]*origin\///')
    if [[ -n "$remote_branches" ]]; then
        echo -e "${YELLOW}Remote branches:${NC}"
        echo "$remote_branches" | while read -r branch; do
            echo "  🌐 $branch"
        done
        echo ""
    fi
    
    # List tags
    local tags=$(git tag | grep -E "^v[0-9]+\.[0-9]+\.[0-9]+" | sort -V | tail -10)
    if [[ -n "$tags" ]]; then
        echo -e "${YELLOW}Recent tags (last 10):${NC}"
        echo "$tags" | while read -r tag; do
            echo "  🏷️  $tag"
        done
    fi
}

# Function to show release status
show_status() {
    local version="$1"
    
    if [[ -z "$version" ]]; then
        echo -e "${RED}❌ Error: Version is required${NC}"
        echo "Usage: $0 status <version>"
        return 1
    fi
    
    local branch_name="release/$version"
    
    echo -e "${BLUE}📊 Release Status: $version${NC}"
    echo ""
    
    # Check if branch exists
    if branch_exists "$branch_name"; then
        echo -e "${GREEN}✅ Release branch exists: $branch_name${NC}"
        
        # Show branch info
        local last_commit=$(git log -1 --format="%h %s" "$branch_name" 2>/dev/null)
        if [[ -n "$last_commit" ]]; then
            echo -e "${YELLOW}📝 Last commit: $last_commit${NC}"
        fi
        
        # Check if files exist
        if [[ -f "RELEASE_NOTES_$version.md" ]]; then
            echo -e "${GREEN}✅ Release notes exist${NC}"
        else
            echo -e "${RED}❌ Release notes missing${NC}"
        fi
        
        if [[ -f "RELEASE_CHECKLIST_$version.md" ]]; then
            echo -e "${GREEN}✅ Release checklist exists${NC}"
        else
            echo -e "${RED}❌ Release checklist missing${NC}"
        fi
    else
        echo -e "${RED}❌ Release branch does not exist: $branch_name${NC}"
    fi
    
    # Check if tag exists
    if git tag | grep -q "^$version$"; then
        echo -e "${GREEN}✅ Tag exists: $version${NC}"
    else
        echo -e "${YELLOW}⏳ Tag not created yet${NC}"
    fi
}

# Function to calculate next version
calculate_next_version() {
    local current="$1"
    local increment="$2"
    
    if [[ -z "$current" || -z "$increment" ]]; then
        echo -e "${RED}❌ Error: Current version and increment type are required${NC}"
        echo "Usage: $0 next <current> <type>"
        return 1
    fi
    
    # Validate current version
    if ! validate_version "$current"; then
        return 1
    fi
    
    # Remove 'v' prefix
    local clean_version="${current#v}"
    
    # Parse version components
    IFS='.' read -r major minor patch <<< "$clean_version"
    
    # Remove any pre-release suffix from patch
    patch="${patch%%-*}"
    
    case "$increment" in
        major)
            echo "v$((major + 1)).0.0"
            ;;
        minor)
            echo "v$major.$((minor + 1)).0"
            ;;
        patch)
            echo "v$major.$minor.$((patch + 1))"
            ;;
        *)
            echo -e "${RED}❌ Invalid increment type: $increment${NC}"
            echo -e "${YELLOW}Valid types: major, minor, patch${NC}"
            return 1
            ;;
    esac
}

# Main script logic
main() {
    # Check if we're in a Git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}❌ Error: Not in a Git repository${NC}"
        exit 1
    fi
    
    # Check if we're in the project root
    if [[ ! -f "pubspec.yaml" ]]; then
        echo -e "${RED}❌ Error: Not in Flutter project root (pubspec.yaml not found)${NC}"
        exit 1
    fi
    
    case "${1:-}" in
        create)
            create_release "$2" "$3"
            ;;
        finalize)
            finalize_release "$2"
            ;;
        list)
            list_releases
            ;;
        status)
            show_status "$2"
            ;;
        validate)
            validate_version "$2"
            ;;
        next)
            calculate_next_version "$2" "$3"
            ;;
        help|--help|-h)
            show_help
            ;;
        "")
            echo -e "${RED}❌ Error: No command specified${NC}"
            echo ""
            show_help
            exit 1
            ;;
        *)
            echo -e "${RED}❌ Error: Unknown command: $1${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"