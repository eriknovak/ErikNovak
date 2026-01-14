# Secrets Handling Reference

Detailed patterns and remediation steps for secret management.

## Secret Patterns

### API Keys

| Provider | Pattern | Example |
|----------|---------|---------|
| AWS Access Key | `AKIA[0-9A-Z]{16}` | AKIAIOSFODNN7EXAMPLE |
| AWS Secret Key | `[A-Za-z0-9/+=]{40}` | wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY |
| Google API | `AIza[0-9A-Za-z-_]{35}` | AIzaSyC-example-key-here |
| Stripe | `sk_live_[0-9a-zA-Z]{24,}` | sk_live_51H3kExampleKey |
| Stripe | `pk_live_[0-9a-zA-Z]{24,}` | pk_live_51H3kExampleKey |
| GitHub | `ghp_[0-9a-zA-Z]{36}` | ghp_xxxxxxxxxxxxxxxxxxxx |
| GitHub | `github_pat_[0-9a-zA-Z_]{22,}` | github_pat_xxx |
| Slack | `xox[baprs]-[0-9a-zA-Z-]{10,}` | xoxb-example-token |
| Twilio | `SK[0-9a-fA-F]{32}` | SK0123456789abcdef |
| SendGrid | `SG\.[0-9A-Za-z-_]{22}\.[0-9A-Za-z-_]{43}` | SG.xxx.xxx |
| Mailchimp | `[0-9a-f]{32}-us[0-9]{1,2}` | abc123-us14 |

### Tokens

| Type | Pattern |
|------|---------|
| JWT | `eyJ[A-Za-z0-9-_]+\.eyJ[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+` |
| Bearer | `Bearer [A-Za-z0-9-_]+` |
| Basic Auth | `Basic [A-Za-z0-9+/=]+` |
| Generic Token | `[tT]oken['":\s]+[A-Za-z0-9-_]{20,}` |

### Private Keys

| Type | Indicator |
|------|-----------|
| RSA Private | `-----BEGIN RSA PRIVATE KEY-----` |
| OpenSSH Private | `-----BEGIN OPENSSH PRIVATE KEY-----` |
| EC Private | `-----BEGIN EC PRIVATE KEY-----` |
| PGP Private | `-----BEGIN PGP PRIVATE KEY BLOCK-----` |
| Generic Private | `-----BEGIN PRIVATE KEY-----` |

### Database Credentials

| Type | Pattern |
|------|---------|
| MongoDB | `mongodb(\+srv)?://[^:]+:[^@]+@` |
| PostgreSQL | `postgres(ql)?://[^:]+:[^@]+@` |
| MySQL | `mysql://[^:]+:[^@]+@` |
| Redis | `redis://:[^@]+@` |

### Other Secrets

| Type | Pattern |
|------|---------|
| Password in URL | `://[^:]+:[^@]+@` |
| Password field | `[pP]assword['":\s]+[^\s'"]{8,}` |
| Secret field | `[sS]ecret['":\s]+[^\s'"]{8,}` |
| Private key file | `.*\.(pem|key|p12|pfx)$` |

## Gitignore Patterns

Essential patterns for `.gitignore`:

```gitignore
# Environment files
.env
.env.*
!.env.example
!.env.template

# Credentials
credentials.json
secrets.json
secrets.yaml
secrets.yml
**/service-account*.json
**/*serviceaccount*.json

# Private keys
*.pem
*.key
*.p12
*.pfx
id_rsa
id_rsa.pub
id_ed25519
id_ed25519.pub

# Cloud provider configs (if copied to project)
.aws/
.kube/

# Terraform state
*.tfstate
*.tfstate.*
.terraform/

# IDE/Editor secrets
.idea/**/dataSources/
.idea/**/dataSources.local.xml

# OS files that might contain secrets
.DS_Store
Thumbs.db

# Logs that might contain secrets
*.log
logs/
```

## .env.example Template

Create `.env.example` alongside `.env`:

```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
DATABASE_POOL_SIZE=5

# Authentication
JWT_SECRET=your-256-bit-secret-here
SESSION_SECRET=random-session-secret

# Third-party APIs
STRIPE_SECRET_KEY=sk_test_xxx
STRIPE_PUBLISHABLE_KEY=pk_test_xxx
SENDGRID_API_KEY=SG.xxx

# AWS (optional)
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=us-east-1

# Feature flags
DEBUG=false
LOG_LEVEL=info
```

## Remediation Steps

### If Secrets Are Committed

1. **Rotate the secret immediately** - assume it's compromised
2. **Remove from git history**:
   ```bash
   # Using git-filter-repo (recommended)
   pip install git-filter-repo
   git filter-repo --path secrets.json --invert-paths

   # Or using BFG Repo Cleaner
   bfg --delete-files secrets.json
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   ```
3. **Force push** (coordinate with team):
   ```bash
   git push --force --all
   ```
4. **Notify team** to re-clone repository

### Secret Management Best Practices

1. **Use environment variables** - never hardcode
2. **Use secret managers in production**:
   - HashiCorp Vault
   - AWS Secrets Manager
   - GCP Secret Manager
   - Azure Key Vault
   - 1Password/Doppler for teams
3. **Rotate secrets regularly**
4. **Use different secrets per environment**
5. **Audit access logs**

### Pre-commit Hooks

Install git-secrets or detect-secrets:

```bash
# git-secrets
git secrets --install
git secrets --register-aws

# detect-secrets
pip install detect-secrets
detect-secrets scan > .secrets.baseline
```

Add to `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
```

## Scanning Commands

Quick scans to run manually:

```bash
# Find .env files not in gitignore
git ls-files | grep -E '\.env'

# Search for potential API keys in code
grep -rn "AKIA" --include="*.py" --include="*.js" .
grep -rn "sk_live_" --include="*.py" --include="*.js" .

# Find private key headers
grep -rn "BEGIN.*PRIVATE KEY" .

# Find hardcoded passwords
grep -rn -E "[pP]assword\s*=\s*['\"][^'\"]+['\"]" .

# Check git history for secrets (recent commits)
git log -p --all -S "password" -- "*.py" "*.js" | head -100
```

## Risk Assessment

| Severity | Examples | Response Time |
|----------|----------|---------------|
| CRITICAL | AWS keys, database creds in code | Immediate rotation |
| HIGH | .env committed, API keys in history | Same day rotation |
| MEDIUM | Missing .gitignore patterns | Fix within sprint |
| LOW | Placeholder secrets, test keys | Fix when convenient |
