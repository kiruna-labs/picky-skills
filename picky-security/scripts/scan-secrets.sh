#!/bin/bash
# scan-secrets.sh - Comprehensive secret scanning script
# Run from project root: ./scan-secrets.sh [directory]

set -euo pipefail

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCAN_DIR="${1:-.}"
FINDINGS=0

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   SECRET SCANNER - Ultra Thorough Edition${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo -e "Scanning directory: ${SCAN_DIR}"
echo -e "Timestamp: $(date)"
echo ""

# Function to scan and count findings
scan_pattern() {
    local pattern="$1"
    local description="$2"
    local severity="$3"

    local results
    results=$(grep -rn "$pattern" "$SCAN_DIR" \
        --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" \
        --include="*.py" --include="*.rb" --include="*.php" --include="*.go" \
        --include="*.java" --include="*.cs" --include="*.json" --include="*.yml" \
        --include="*.yaml" --include="*.toml" --include="*.xml" --include="*.env*" \
        --include="*.config.*" --include="*.conf" --include="*.ini" \
        --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=dist \
        --exclude-dir=build --exclude-dir=__pycache__ --exclude-dir=.venv \
        --exclude-dir=vendor --exclude-dir=.next --exclude-dir=coverage \
        2>/dev/null || true)

    if [ -n "$results" ]; then
        local count
        count=$(echo "$results" | wc -l | tr -d ' ')
        FINDINGS=$((FINDINGS + count))

        if [ "$severity" = "CRITICAL" ]; then
            echo -e "${RED}[CRITICAL]${NC} $description"
        elif [ "$severity" = "HIGH" ]; then
            echo -e "${YELLOW}[HIGH]${NC} $description"
        else
            echo -e "${BLUE}[MEDIUM]${NC} $description"
        fi

        echo "$results" | head -10
        if [ "$count" -gt 10 ]; then
            echo "  ... and $((count - 10)) more"
        fi
        echo ""
    fi
}

echo -e "${RED}=== CRITICAL SEVERITY ===${NC}"
echo ""

# AWS Credentials
echo "Checking for AWS credentials..."
scan_pattern "AKIA[0-9A-Z]\{16\}" "AWS Access Key ID found" "CRITICAL"
scan_pattern "aws_secret_access_key\s*[=:]\s*['\"][^'\"]\{20,\}" "AWS Secret Access Key found" "CRITICAL"

# Private Keys
echo "Checking for private keys..."
scan_pattern "BEGIN.*PRIVATE KEY" "Private key found" "CRITICAL"
scan_pattern "BEGIN RSA PRIVATE KEY" "RSA private key found" "CRITICAL"
scan_pattern "BEGIN EC PRIVATE KEY" "EC private key found" "CRITICAL"
scan_pattern "BEGIN OPENSSH PRIVATE KEY" "OpenSSH private key found" "CRITICAL"

# Database Connection Strings with Passwords
echo "Checking for database connection strings..."
scan_pattern "postgres://[^:]*:[^@]*@" "PostgreSQL connection with password" "CRITICAL"
scan_pattern "mongodb://[^:]*:[^@]*@" "MongoDB connection with password" "CRITICAL"
scan_pattern "mysql://[^:]*:[^@]*@" "MySQL connection with password" "CRITICAL"
scan_pattern "redis://:[^@]*@" "Redis connection with password" "CRITICAL"

# Stripe Live Keys
echo "Checking for Stripe keys..."
scan_pattern "sk_live_[0-9a-zA-Z]\{24,\}" "Stripe live secret key" "CRITICAL"
scan_pattern "rk_live_[0-9a-zA-Z]\{24,\}" "Stripe live restricted key" "CRITICAL"

# GitHub/GitLab Tokens
echo "Checking for Git platform tokens..."
scan_pattern "ghp_[0-9a-zA-Z]\{36\}" "GitHub personal access token" "CRITICAL"
scan_pattern "gho_[0-9a-zA-Z]\{36\}" "GitHub OAuth access token" "CRITICAL"
scan_pattern "ghu_[0-9a-zA-Z]\{36\}" "GitHub user-to-server token" "CRITICAL"
scan_pattern "ghs_[0-9a-zA-Z]\{36\}" "GitHub server-to-server token" "CRITICAL"
scan_pattern "glpat-[0-9a-zA-Z_\-]\{20\}" "GitLab personal access token" "CRITICAL"

# Google Cloud
echo "Checking for Google Cloud credentials..."
scan_pattern "AIza[0-9A-Za-z_\-]\{35\}" "Google API key" "CRITICAL"

# Slack
echo "Checking for Slack tokens..."
scan_pattern "xox[baprs]-[0-9]\{10,13\}-[0-9a-zA-Z]\{24\}" "Slack token" "CRITICAL"

echo -e "${YELLOW}=== HIGH SEVERITY ===${NC}"
echo ""

# Generic API Keys
echo "Checking for generic API keys..."
scan_pattern "api[_-]?key\s*[=:]\s*['\"][^'\"]\{16,\}['\"]" "Generic API key" "HIGH"
scan_pattern "apikey\s*[=:]\s*['\"][^'\"]\{16,\}['\"]" "Generic API key (alt)" "HIGH"

# Generic Secrets
echo "Checking for generic secrets..."
scan_pattern "secret[_-]?key\s*[=:]\s*['\"][^'\"]\{16,\}['\"]" "Generic secret key" "HIGH"
scan_pattern "client[_-]?secret\s*[=:]\s*['\"][^'\"]\{16,\}['\"]" "Client secret" "HIGH"

# JWT/Token Secrets
echo "Checking for JWT secrets..."
scan_pattern "jwt[_-]?secret\s*[=:]\s*['\"][^'\"]\{16,\}['\"]" "JWT secret" "HIGH"
scan_pattern "token[_-]?secret\s*[=:]\s*['\"][^'\"]\{16,\}['\"]" "Token secret" "HIGH"

# Password in Config
echo "Checking for passwords in config..."
scan_pattern "password\s*[=:]\s*['\"][^'\"]\{8,\}['\"]" "Hardcoded password" "HIGH"
scan_pattern "passwd\s*[=:]\s*['\"][^'\"]\{8,\}['\"]" "Hardcoded passwd" "HIGH"

# SendGrid
echo "Checking for SendGrid keys..."
scan_pattern "SG\.[0-9a-zA-Z_\-]\{22\}\.[0-9a-zA-Z_\-]\{43\}" "SendGrid API key" "HIGH"

# Twilio
echo "Checking for Twilio credentials..."
scan_pattern "SK[0-9a-fA-F]\{32\}" "Twilio API key" "HIGH"
scan_pattern "AC[0-9a-fA-F]\{32\}" "Twilio Account SID" "HIGH"

# Mailgun
echo "Checking for Mailgun keys..."
scan_pattern "key-[0-9a-zA-Z]\{32\}" "Mailgun API key" "HIGH"

# Firebase
echo "Checking for Firebase credentials..."
scan_pattern "firebase[_-]?api[_-]?key" "Firebase API key reference" "HIGH"

# Bearer Tokens
echo "Checking for Bearer tokens..."
scan_pattern "Bearer\s\+[A-Za-z0-9_\.\-]\{30,\}" "Bearer token" "HIGH"
scan_pattern "Authorization.*Bearer" "Authorization Bearer header" "HIGH"

echo -e "${BLUE}=== MEDIUM SEVERITY ===${NC}"
echo ""

# Test/Development Keys (might be committed accidentally)
echo "Checking for test keys that might be production..."
scan_pattern "sk_test_[0-9a-zA-Z]\{24,\}" "Stripe test key (verify not in prod)" "MEDIUM"
scan_pattern "pk_test_[0-9a-zA-Z]\{24,\}" "Stripe test publishable key" "MEDIUM"

# OAuth Secrets
echo "Checking for OAuth secrets..."
scan_pattern "oauth.*secret" "OAuth secret reference" "MEDIUM"
scan_pattern "GOOGLE_SECRET" "Google OAuth secret" "MEDIUM"
scan_pattern "GITHUB_SECRET" "GitHub OAuth secret" "MEDIUM"
scan_pattern "FACEBOOK_SECRET" "Facebook OAuth secret" "MEDIUM"

# Encryption Keys
echo "Checking for encryption keys..."
scan_pattern "encryption[_-]?key" "Encryption key reference" "MEDIUM"
scan_pattern "aes[_-]?key" "AES key reference" "MEDIUM"

# Session Secrets
echo "Checking for session secrets..."
scan_pattern "session[_-]?secret" "Session secret reference" "MEDIUM"
scan_pattern "cookie[_-]?secret" "Cookie secret reference" "MEDIUM"

echo -e "${GREEN}=== SCAN COMPLETE ===${NC}"
echo ""
echo "================================================"
echo "Total potential secrets found: $FINDINGS"
echo "================================================"
echo ""

if [ "$FINDINGS" -gt 0 ]; then
    echo -e "${RED}ACTION REQUIRED: Review the findings above${NC}"
    echo ""
    echo "For each finding:"
    echo "  1. Determine if it's a real secret or false positive"
    echo "  2. If real, rotate the secret immediately"
    echo "  3. Remove from code and use environment variables"
    echo "  4. Check git history for exposure"
    echo "  5. If committed, consider the secret compromised"
    echo ""
    echo "To check git history for a secret:"
    echo '  git log -p --all -S "YOUR_SECRET" -- "*.ts" "*.js"'
    echo ""
    exit 1
else
    echo -e "${GREEN}No obvious secrets found!${NC}"
    echo ""
    echo "Note: This scan uses pattern matching and may miss:"
    echo "  - Obfuscated secrets"
    echo "  - Secrets in binary files"
    echo "  - Secrets with unusual naming"
    echo "  - Secrets in git history"
    echo ""
    echo "Consider also running:"
    echo "  - truffleHog"
    echo "  - git-secrets"
    echo "  - detect-secrets"
    echo "  - gitleaks"
    exit 0
fi
