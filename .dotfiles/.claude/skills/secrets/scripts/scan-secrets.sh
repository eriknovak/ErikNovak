#!/bin/bash

# Secrets Scanner for Claude Code
# Scans codebase for potential secret exposure issues

set -euo pipefail

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
CRITICAL=0
HIGH=0
MEDIUM=0
LOW=0

# Target directory (default: current)
TARGET_DIR="${1:-.}"

echo "=== Secrets Audit Report ==="
echo "Scanning: $(realpath "$TARGET_DIR")"
echo ""

# Check if we're in a git repo
if ! git -C "$TARGET_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${YELLOW}Warning: Not a git repository. Some checks will be skipped.${NC}"
    IN_GIT=false
else
    IN_GIT=true
fi

# --- Check 1: .env files in git ---
if $IN_GIT; then
    echo -e "${BLUE}[Check 1] Scanning for committed .env files...${NC}"
    ENV_FILES=$(git -C "$TARGET_DIR" ls-files | grep -E '\.env$|\.env\.' | grep -v '\.example' | grep -v '\.template' || true)
    if [ -n "$ENV_FILES" ]; then
        echo -e "${RED}CRITICAL: .env files committed to git:${NC}"
        echo "$ENV_FILES" | while read -r f; do
            echo "  - $f"
            ((CRITICAL++)) || true
        done
        echo "  Action: Remove from git, add to .gitignore, rotate secrets"
    else
        echo -e "${GREEN}  OK: No .env files committed${NC}"
    fi
    echo ""
fi

# --- Check 2: Gitignore patterns ---
echo -e "${BLUE}[Check 2] Checking .gitignore patterns...${NC}"
GITIGNORE="$TARGET_DIR/.gitignore"
MISSING_PATTERNS=()

REQUIRED_PATTERNS=(".env" "*.pem" "*.key" "credentials.json" "secrets.json" "*.tfstate")

if [ -f "$GITIGNORE" ]; then
    for pattern in "${REQUIRED_PATTERNS[@]}"; do
        if ! grep -qF "$pattern" "$GITIGNORE" 2>/dev/null; then
            MISSING_PATTERNS+=("$pattern")
        fi
    done

    if [ ${#MISSING_PATTERNS[@]} -gt 0 ]; then
        echo -e "${YELLOW}HIGH: Missing recommended .gitignore patterns:${NC}"
        for p in "${MISSING_PATTERNS[@]}"; do
            echo "  - $p"
            ((HIGH++)) || true
        done
        echo "  Action: Add these patterns to .gitignore"
    else
        echo -e "${GREEN}  OK: Essential patterns present in .gitignore${NC}"
    fi
else
    echo -e "${YELLOW}HIGH: No .gitignore file found${NC}"
    echo "  Action: Create .gitignore with secret-related patterns"
    ((HIGH++)) || true
fi
echo ""

# --- Check 3: .env.example existence ---
echo -e "${BLUE}[Check 3] Checking for .env.example template...${NC}"
if [ -f "$TARGET_DIR/.env" ] || [ -f "$TARGET_DIR/.env.local" ]; then
    if [ ! -f "$TARGET_DIR/.env.example" ] && [ ! -f "$TARGET_DIR/.env.template" ]; then
        echo -e "${YELLOW}MEDIUM: .env exists but no .env.example template${NC}"
        echo "  Action: Create .env.example with required keys (no values)"
        ((MEDIUM++)) || true
    else
        echo -e "${GREEN}  OK: .env.example template exists${NC}"
    fi
else
    echo -e "${GREEN}  OK: No .env file (or using alternative config)${NC}"
fi
echo ""

# --- Check 4: Hardcoded secrets in source ---
echo -e "${BLUE}[Check 4] Scanning for hardcoded secrets...${NC}"

# AWS Access Keys
AWS_KEYS=$(grep -rnE "AKIA[0-9A-Z]{16}" "$TARGET_DIR" \
    --include="*.py" --include="*.js" --include="*.ts" \
    --include="*.java" --include="*.go" --include="*.rb" \
    --include="*.php" --include="*.yaml" --include="*.yml" \
    --include="*.json" --include="*.xml" --include="*.conf" \
    2>/dev/null | grep -v node_modules | grep -v ".git" | head -10 || true)

if [ -n "$AWS_KEYS" ]; then
    echo -e "${RED}CRITICAL: Potential AWS Access Keys found:${NC}"
    echo "$AWS_KEYS" | while read -r line; do
        echo "  $line"
        ((CRITICAL++)) || true
    done
    echo "  Action: Rotate AWS credentials immediately"
fi

# Private key headers
PRIVATE_KEYS=$(grep -rnE "BEGIN.*PRIVATE KEY" "$TARGET_DIR" \
    --include="*.py" --include="*.js" --include="*.ts" \
    --include="*.java" --include="*.go" --include="*.rb" \
    --include="*.php" --include="*.yaml" --include="*.yml" \
    --include="*.json" --include="*.xml" \
    2>/dev/null | grep -v node_modules | grep -v ".git" | head -10 || true)

if [ -n "$PRIVATE_KEYS" ]; then
    echo -e "${RED}CRITICAL: Private key content found in source:${NC}"
    echo "$PRIVATE_KEYS" | while read -r line; do
        echo "  $line"
        ((CRITICAL++)) || true
    done
    echo "  Action: Remove and rotate the key"
fi

# GitHub tokens
GH_TOKENS=$(grep -rnE "ghp_[0-9a-zA-Z]{36}|github_pat_[0-9a-zA-Z_]{22,}" "$TARGET_DIR" \
    --include="*.py" --include="*.js" --include="*.ts" \
    --include="*.yaml" --include="*.yml" --include="*.json" \
    2>/dev/null | grep -v node_modules | grep -v ".git" | head -10 || true)

if [ -n "$GH_TOKENS" ]; then
    echo -e "${RED}CRITICAL: GitHub tokens found:${NC}"
    echo "$GH_TOKENS" | while read -r line; do
        echo "  $line"
        ((CRITICAL++)) || true
    done
    echo "  Action: Revoke and regenerate GitHub token"
fi

# Stripe keys
STRIPE_KEYS=$(grep -rnE "sk_live_[0-9a-zA-Z]{24,}" "$TARGET_DIR" \
    --include="*.py" --include="*.js" --include="*.ts" \
    --include="*.yaml" --include="*.yml" --include="*.json" \
    2>/dev/null | grep -v node_modules | grep -v ".git" | head -10 || true)

if [ -n "$STRIPE_KEYS" ]; then
    echo -e "${RED}CRITICAL: Stripe live keys found:${NC}"
    echo "$STRIPE_KEYS" | while read -r line; do
        echo "  $line"
        ((CRITICAL++)) || true
    done
    echo "  Action: Roll Stripe API keys immediately"
fi

# Generic password patterns
PASSWORDS=$(grep -rnE "[pP]assword\s*[=:]\s*['\"][^'\"]{8,}['\"]" "$TARGET_DIR" \
    --include="*.py" --include="*.js" --include="*.ts" \
    --include="*.java" --include="*.go" --include="*.rb" \
    --include="*.php" \
    2>/dev/null | grep -v node_modules | grep -v ".git" | grep -v "test" | grep -v "example" | head -10 || true)

if [ -n "$PASSWORDS" ]; then
    echo -e "${YELLOW}HIGH: Potential hardcoded passwords:${NC}"
    echo "$PASSWORDS" | while read -r line; do
        echo "  $line"
        ((HIGH++)) || true
    done
    echo "  Action: Move to environment variables"
fi

# If no issues in this check
if [ -z "$AWS_KEYS" ] && [ -z "$PRIVATE_KEYS" ] && [ -z "$GH_TOKENS" ] && [ -z "$STRIPE_KEYS" ] && [ -z "$PASSWORDS" ]; then
    echo -e "${GREEN}  OK: No obvious hardcoded secrets detected${NC}"
fi
echo ""

# --- Check 5: Sensitive files in repo ---
if $IN_GIT; then
    echo -e "${BLUE}[Check 5] Checking for sensitive files in git...${NC}"
    SENSITIVE=$(git -C "$TARGET_DIR" ls-files | grep -E '\.(pem|key|p12|pfx)$|credentials\.json|secrets\.(json|yaml|yml)$' || true)
    if [ -n "$SENSITIVE" ]; then
        echo -e "${RED}CRITICAL: Sensitive files committed:${NC}"
        echo "$SENSITIVE" | while read -r f; do
            echo "  - $f"
            ((CRITICAL++)) || true
        done
        echo "  Action: Remove from git history, rotate credentials"
    else
        echo -e "${GREEN}  OK: No sensitive file types committed${NC}"
    fi
    echo ""
fi

# --- Summary ---
echo "=== Summary ==="
TOTAL=$((CRITICAL + HIGH + MEDIUM + LOW))
if [ $TOTAL -eq 0 ]; then
    echo -e "${GREEN}No issues found. Secrets appear to be handled properly.${NC}"
else
    echo -e "Found issues:"
    [ $CRITICAL -gt 0 ] && echo -e "  ${RED}CRITICAL: $CRITICAL${NC}"
    [ $HIGH -gt 0 ] && echo -e "  ${YELLOW}HIGH: $HIGH${NC}"
    [ $MEDIUM -gt 0 ] && echo -e "  ${BLUE}MEDIUM: $MEDIUM${NC}"
    [ $LOW -gt 0 ] && echo -e "  LOW: $LOW"
fi
echo ""

# Exit with appropriate code
if [ $CRITICAL -gt 0 ]; then
    exit 2
elif [ $HIGH -gt 0 ]; then
    exit 1
else
    exit 0
fi
