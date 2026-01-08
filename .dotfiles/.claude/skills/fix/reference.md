# Bug Fix Skill - Reference Guide

## Overview

The `/fix` skill provides an interactive workflow for identifying, fixing, and validating bugs in Python and Node.js projects. It's designed to work with the user's existing test infrastructure and development tools.

## Detection Strategy

### Python Projects
The skill detects Python projects by looking for:
- `pyproject.toml` (modern Python projects)
- `setup.py` (traditional Python packages)
- `requirements.txt` (dependencies)
- `*.py` files in the project root

### Node.js Projects
The skill detects Node.js projects by looking for:
- `package.json` (all Node.js projects)
- `tsconfig.json` (TypeScript projects)

## Validation Tools

### Python
1. **pytest** - Unit and integration testing
   - Install: `uv pip install pytest`
   - Run: `pytest -v` for verbose output
   - Configuration: `pytest.ini` or `pyproject.toml`

2. **mypy** - Static type checking
   - Install: `uv pip install mypy`
   - Run: `mypy .` to check all files
   - Configuration: `mypy.ini` or `pyproject.toml`

3. **py_compile** - Syntax validation
   - Built into Python
   - Catches syntax errors before runtime

### Node.js/TypeScript
1. **npm test** - Runs test script from package.json
   - Common frameworks: jest, mocha, vitest
   - Install jest: `npm install --save-dev jest @types/jest`
   - Configure in `package.json` or `jest.config.js`

2. **tsc** - TypeScript compiler
   - Install: `npm install --save-dev typescript`
   - Run: `tsc --noEmit` to check without compiling
   - Configuration: `tsconfig.json`

3. **node --check** - JavaScript syntax validation
   - Built into Node.js
   - Validates syntax without execution

## Workflow Best Practices

### 1. Bug Identification Phase
- Review recent git changes: `git diff` or `git log -p`
- Check error logs and stack traces
- Run tests to reproduce the issue
- Identify the root cause, not just symptoms

### 2. Fix Planning Phase
- Consider multiple approaches
- Evaluate trade-offs (performance, readability, maintainability)
- Check for similar patterns in the codebase
- Plan tests to verify the fix

### 3. Fix Implementation Phase
- Make minimal, targeted changes
- Follow existing code style and patterns
- Add comments only where logic isn't obvious
- Update or add tests for the fixed bug

### 4. Validation Phase
- Run affected tests first
- Run full test suite if available
- Check for type errors
- Verify no new issues were introduced
- Test edge cases related to the bug

## Common Bug Patterns

### Python
- **NameError**: Undefined variable or typo
- **TypeError**: Wrong type passed to function
- **AttributeError**: Accessing non-existent attribute
- **ImportError**: Missing module or circular import
- **IndexError**: List/array index out of bounds

### JavaScript/Node.js
- **ReferenceError**: Undefined variable
- **TypeError**: Wrong type or null/undefined access
- **SyntaxError**: Invalid JavaScript syntax
- **Promise rejections**: Unhandled async errors
- **Module errors**: Import/export issues

## Integration with Development Workflow

### Git Integration
The skill works well with git workflows:
```bash
# Before fixing
git status          # Check for uncommitted changes
git diff           # Review recent changes

# After fixing
git add .          # Stage fixes
git commit -m "fix: resolve issue with ..."
```

### Testing Integration
The skill respects your existing test configuration:
- Python: Uses `pytest.ini`, `pyproject.toml`, or `.pytest.ini`
- Node.js: Uses test script from `package.json`
- Both: Respects `.gitignore` and test discovery patterns

### CI/CD Compatibility
The detection script exits with appropriate codes:
- `0` - All checks passed
- `1` - Issues found (tests failed, type errors, etc.)

This makes it compatible with CI/CD pipelines.

## Advanced Usage

### Custom Test Commands
You can modify the detection script to use custom test commands:
```bash
# For Python with specific pytest args
pytest -v --cov=src tests/

# For Node.js with specific jest args
npm test -- --coverage --verbose
```

### Multi-Language Projects
The skill automatically detects and validates both Python and Node.js code in the same repository.

### Focused Testing
For large projects, you can specify a subdirectory:
```bash
/fix path/to/module
```

## Troubleshooting

### Missing Tools
If tools are missing, the skill provides installation instructions:
- Python: Use `uv pip install <tool>`
- Node.js: Use `npm install --save-dev <tool>`

### Test Configuration
If tests aren't running correctly:
1. Check test discovery patterns
2. Verify test configuration files
3. Ensure dependencies are installed
4. Check for environment-specific settings

### Type Checking
If type checking reports false positives:
1. Review type annotations
2. Check mypy/tsc configuration
3. Consider adding type stubs for third-party libraries
4. Use type ignore comments sparingly

## Examples

### Example 1: Fixing a Failing Test
```
User: /fix
Skill: Running pytest...
       ✗ Tests failed in test_auth.py::test_login
       Error: AssertionError: expected 200, got 401

Claude: I found the issue in auth.py:42. The function is missing
        the authentication check. Let me fix it...
        [Makes fix]
        Running tests again... ✓ All tests pass
```

### Example 2: Fixing Type Errors
```
User: /fix
Skill: Running mypy...
       ✗ Type errors in models.py:15
       error: Argument 1 has incompatible type "str"; expected "int"

Claude: The issue is in models.py:15. The function expects an int
        but receives a string. Let me add proper type conversion...
        [Makes fix]
        Running mypy... ✓ No type errors found
```

### Example 3: Fixing Syntax Errors
```
User: /fix
Skill: Running node --check...
       ✗ Syntax errors in app.js
       SyntaxError: Unexpected token '}'

Claude: Found an extra closing brace in app.js:89. Removing it...
        [Makes fix]
        Running node --check... ✓ No syntax errors
```

## Tips for Effective Bug Fixing

1. **Start with Tests**: Write a failing test that reproduces the bug
2. **One Bug at a Time**: Focus on fixing one issue before moving to the next
3. **Root Cause Analysis**: Fix the underlying cause, not just symptoms
4. **Regression Prevention**: Add tests to prevent the bug from reoccurring
5. **Documentation**: Update comments or docs if the bug revealed unclear behavior

## Resources

- Python Testing: https://docs.pytest.org/
- Python Type Hints: https://mypy.readthedocs.io/
- Node.js Testing: https://jestjs.io/docs/getting-started
- TypeScript: https://www.typescriptlang.org/docs/handbook/intro.html
