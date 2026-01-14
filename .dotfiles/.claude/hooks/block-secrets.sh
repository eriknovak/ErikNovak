#!/bin/bash

# Block Secrets Hook for Claude Code
# Purpose: Prevent reading or editing files that contain secrets
# Type: PreToolUse (blocking)

# Read JSON input from stdin
INPUT=$(cat)

# Extract file path using jq
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)

# If no file path, allow the operation
if [ -z "$FILE" ]; then
    exit 0
fi

# Get basename and dirname for pattern matching
BASENAME=$(basename "$FILE" 2>/dev/null)
DIRNAME=$(dirname "$FILE" 2>/dev/null)

# Patterns for secret files (case-insensitive matching where appropriate)
is_secret_file() {
    local file="$1"
    local name="$2"
    local dir="$3"
    local name_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')

    # Environment files
    [[ "$name" == ".env" ]] && return 0
    [[ "$name" == .env.* ]] && return 0
    [[ "$name" == "*.env" ]] && return 0

    # Credential/secret JSON/YAML files
    [[ "$name_lower" == "credentials.json" ]] && return 0
    [[ "$name_lower" == "secrets.json" ]] && return 0
    [[ "$name_lower" == "secrets.yaml" ]] && return 0
    [[ "$name_lower" == "secrets.yml" ]] && return 0
    [[ "$name_lower" == *"service-account"*".json" ]] && return 0
    [[ "$name_lower" == *"serviceaccount"*".json" ]] && return 0

    # Private keys
    [[ "$name" == *.pem ]] && return 0
    [[ "$name" == *.key ]] && return 0
    [[ "$name" == *.p12 ]] && return 0
    [[ "$name" == *.pfx ]] && return 0
    [[ "$name" == "id_rsa" ]] && return 0
    [[ "$name" == "id_rsa.pub" ]] && return 0
    [[ "$name" == "id_ed25519" ]] && return 0
    [[ "$name" == "id_ed25519.pub" ]] && return 0
    [[ "$name" == "id_ecdsa" ]] && return 0
    [[ "$name" == "id_dsa" ]] && return 0

    # SSH directory files
    [[ "$dir" == *"/.ssh" ]] && return 0
    [[ "$dir" == *"/.ssh/"* ]] && return 0

    # AWS credentials
    [[ "$file" == *"/.aws/credentials" ]] && return 0
    [[ "$file" == *"/.aws/config" ]] && return 0

    # Kubernetes secrets
    [[ "$name_lower" == *"kubeconfig"* ]] && return 0
    [[ "$file" == *"/.kube/config" ]] && return 0

    # GPG keys
    [[ "$dir" == *"/.gnupg" ]] && return 0
    [[ "$dir" == *"/.gnupg/"* ]] && return 0

    # Netrc (contains passwords)
    [[ "$name" == ".netrc" ]] && return 0

    # Token files
    [[ "$name_lower" == *"token"* ]] && [[ "$name" == *.json || "$name" == *.txt ]] && return 0

    # API key files
    [[ "$name_lower" == *"apikey"* ]] && return 0
    [[ "$name_lower" == *"api_key"* ]] && return 0
    [[ "$name_lower" == *"api-key"* ]] && return 0

    # Password files
    [[ "$name_lower" == *"password"* ]] && return 0

    # Auth/secret config
    [[ "$name_lower" == ".htpasswd" ]] && return 0
    [[ "$name_lower" == "auth.json" ]] && return 0

    # NPM auth
    [[ "$name" == ".npmrc" ]] && return 0

    # Docker auth
    [[ "$file" == *"/.docker/config.json" ]] && return 0

    # Terraform state (may contain secrets)
    [[ "$name" == "terraform.tfstate" ]] && return 0
    [[ "$name" == *.tfstate ]] && return 0

    return 1
}

# Check if file matches secret patterns
if is_secret_file "$FILE" "$BASENAME" "$DIRNAME"; then
    # Output JSON to block the operation
    echo '{"decision": "block", "reason": "File appears to contain secrets or credentials. Access blocked for security."}'
    exit 0
fi

# Allow the operation
exit 0
