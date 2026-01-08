# Linting Reference Guide

Complete guide to linting tools for Python and Node.js/React projects.

## Python Linting

### Recommended Tool: ruff

**ruff** is the modern, extremely fast Python linter that replaces multiple tools (flake8, pylint, isort, etc.).

```bash
# Install with uv (recommended)
uv pip install ruff

# Run linting
ruff check .

# Auto-fix issues
ruff check --fix .

# Format code
ruff format .
```

#### Configuration

Create `pyproject.toml` or `ruff.toml`:

```toml
[tool.ruff]
line-length = 88
target-version = "py310"

[tool.ruff.lint]
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "B",   # flake8-bugbear
    "C4",  # flake8-comprehensions
    "UP",  # pyupgrade
]
ignore = []
```

### Alternative: flake8

Classic PEP 8 style checker:

```bash
# Install
uv pip install flake8

# Run
flake8 .

# Configuration in .flake8 or setup.cfg
```

Example `.flake8`:

```ini
[flake8]
max-line-length = 88
extend-ignore = E203, W503
exclude = .git,__pycache__,.venv
```

### Alternative: pylint

Comprehensive static analyzer:

```bash
# Install
uv pip install pylint

# Run
pylint src/

# Configuration in .pylintrc or pyproject.toml
```

### Code Formatting

Use **black** (or ruff format):

```bash
# Install
uv pip install black

# Check without modifying
black --check .

# Format files
black .
```

Configuration in `pyproject.toml`:

```toml
[tool.black]
line-length = 88
target-version = ['py310']
include = '\.pyi?$'
extend-exclude = '''
/(
  \.git
  | \.venv
  | build
  | dist
)/
'''
```

## JavaScript/Node.js/React Linting

### ESLint

Industry-standard JavaScript linter:

```bash
# Install
npm install --save-dev eslint

# Initialize configuration
npx eslint --init

# Run
npm run lint  # or eslint .
```

#### For React Projects

```bash
# Install React-specific plugins
npm install --save-dev \
  eslint-plugin-react \
  eslint-plugin-react-hooks \
  eslint-plugin-jsx-a11y
```

Example `.eslintrc.json`:

```json
{
  "env": {
    "browser": true,
    "es2021": true
  },
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended"
  ],
  "parserOptions": {
    "ecmaFeatures": {
      "jsx": true
    },
    "ecmaVersion": 12,
    "sourceType": "module"
  },
  "plugins": ["react", "react-hooks"],
  "rules": {
    "react/react-in-jsx-scope": "off",
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn"
  },
  "settings": {
    "react": {
      "version": "detect"
    }
  }
}
```

#### package.json Scripts

```json
{
  "scripts": {
    "lint": "eslint src/",
    "lint:fix": "eslint src/ --fix"
  }
}
```

### Prettier

Code formatter for JavaScript/TypeScript:

```bash
# Install
npm install --save-dev prettier

# Run
prettier --check .
prettier --write .
```

Configuration in `.prettierrc`:

```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2
}
```

### ESLint + Prettier Integration

```bash
# Install compatibility packages
npm install --save-dev \
  eslint-config-prettier \
  eslint-plugin-prettier
```

Update `.eslintrc.json`:

```json
{
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:prettier/recommended"
  ]
}
```

## Best Practices

### Python Projects

1. **Use ruff** for modern projects (replaces multiple tools)
2. **Configure in pyproject.toml** for centralized configuration
3. **Run linting in CI/CD** to enforce code quality
4. **Use pre-commit hooks** to lint before committing
5. **Type hints**: Use mypy for type checking

### Node.js/React Projects

1. **Configure ESLint** with React-specific rules
2. **Use Prettier** for consistent formatting
3. **Add lint scripts** to package.json
4. **Enable editor integration** for real-time feedback
5. **Run linters in CI/CD** pipeline

### General

1. **Version control config files** (.eslintrc, pyproject.toml, etc.)
2. **Document linting requirements** in README
3. **Fix issues incrementally** rather than all at once
4. **Use auto-fix sparingly** - review changes first
5. **Customize rules** to match team standards

## Integration with Your Workflow

Since you use `uv` for Python package management and prefer simple tools:

### Python Setup

```bash
# In any Python project
uv pip install ruff
echo "ruff" >> requirements.txt

# Run linting
ruff check .

# Auto-fix
ruff check --fix .
```

### Node.js Setup

```bash
# In any Node.js project
npm install --save-dev eslint prettier

# Add to package.json
{
  "scripts": {
    "lint": "eslint src/",
    "format": "prettier --write src/"
  }
}
```

## Editor Integration

### vim

For ruff (Python):
```vim
" Add to .vimrc
let g:ale_linters = {'python': ['ruff']}
let g:ale_fixers = {'python': ['ruff']}
```

For ESLint (JavaScript):
```vim
let g:ale_linters = {'javascript': ['eslint']}
let g:ale_fixers = {'javascript': ['eslint', 'prettier']}
```

### VS Code

Install extensions:
- Python: "ms-python.python" (includes linting)
- JavaScript: "dbaeumer.vscode-eslint"
- Prettier: "esbenp.prettier-vscode"

## Common Issues

### Python: Import Errors

If ruff/flake8 reports import errors:
1. Ensure virtual environment is activated
2. Check that packages are installed
3. Add `# noqa: F401` to suppress specific warnings

### Node.js: Config Not Found

If ESLint complains about missing config:
```bash
npx eslint --init
```
Follow the prompts to generate configuration.

### Performance Issues

If linting is slow:
- **Python**: Switch to ruff (10-100x faster than pylint)
- **JavaScript**: Use `eslint --cache` or configure ignore patterns

## References

- [ruff documentation](https://docs.astral.sh/ruff/)
- [flake8 documentation](https://flake8.pycqa.org/)
- [ESLint documentation](https://eslint.org/)
- [Prettier documentation](https://prettier.io/)
- [PEP 8 Style Guide](https://pep8.org/)
