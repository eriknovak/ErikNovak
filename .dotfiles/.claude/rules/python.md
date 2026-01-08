# Python Development Rules

This file defines rules and preferences for Python development that Claude Code should follow.

## Package Management

### Preferred: uv Scripts
Use **uv** for Python package management and script execution when creating new projects or scripts:

```python
#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#   "requests",
#   "pandas",
# ]
# ///

import requests
import pandas as pd
```

### Bash Script Compatibility
When writing bash scripts that invoke Python, support both uv and default python:

```bash
#!/bin/bash

# Detect if uv is available and use it, otherwise fall back to python
if command -v uv &> /dev/null; then
    uv run script.py "$@"
else
    python3 script.py "$@"
fi
```

For virtual environment activation in bash scripts:
```bash
# Prefer uv venv creation
if command -v uv &> /dev/null; then
    uv venv
else
    python3 -m venv .venv
fi

source .venv/bin/activate
```

## Coding Style: Google Python Style Guide

Follow the [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html) for all Python code.

### Key Style Points

#### Imports
- Standard library imports first, then third-party, then local imports
- Separate groups with blank lines
- Alphabetize within groups

```python
import os
import sys

import numpy as np
import pandas as pd

from mypackage import mymodule
```

#### Line Length
- Maximum 80 characters per line
- Maximum 100 characters for comments/docstrings if it improves readability

#### Indentation
- 4 spaces per indentation level
- Hanging indents should align wrapped elements vertically

#### Naming Conventions
- `module_name`
- `package_name`
- `ClassName`
- `method_name`
- `function_name`
- `GLOBAL_CONSTANT_NAME`
- `global_var_name`
- `instance_var_name`
- `function_parameter_name`
- `local_var_name`

### Docstrings: Google Style

All public modules, functions, classes, and methods should have docstrings.

#### Function/Method Docstrings
```python
def function_with_types_in_docstring(param1, param2):
    """Summary line (one sentence).

    Extended description of function (optional).

    Args:
        param1 (int): Description of param1.
        param2 (str): Description of param2.

    Returns:
        bool: Description of return value.

    Raises:
        ValueError: Description of when this error is raised.
    """
    return True
```

#### Class Docstrings
```python
class SampleClass:
    """Summary of class here.

    Longer class information...

    Attributes:
        likes_spam (bool): A boolean indicating if we like SPAM or not.
        eggs (int): An integer count of the eggs we have laid.
    """

    def __init__(self, likes_spam=False):
        """Initializes SampleClass with preference for spam.

        Args:
            likes_spam (bool): Defines if we like SPAM or not.
        """
        self.likes_spam = likes_spam
        self.eggs = 0
```

#### Module Docstrings
```python
"""One line summary of module.

Extended description of module (optional).
"""
```

### Type Hints

Use type hints for all function signatures, class attributes, and variables where clarity is needed.

#### Typing Module Types (Required)

**Always use `typing` module types for collections, not built-in types:**

- Use `List` instead of `list`
- Use `Dict` instead of `dict`
- Use `Set` instead of `set`
- Use `Tuple` instead of `tuple`
- Use `Optional[T]` for optional values (equivalent to `Union[T, None]`)
- Use `Union` for multiple possible types
- Use `Callable` for function types
- Use `Any` sparingly when type is truly dynamic

This ensures compatibility across all currently maintained Python versions (3.9+).

```python
from typing import (
    Any,
    Callable,
    Dict,
    List,
    Optional,
    Set,
    Tuple,
    Union,
)

def greeting(name: str) -> str:
    """Returns a greeting message.

    Args:
        name (str): The name to greet.

    Returns:
        str: The greeting message.
    """
    return f"Hello {name}"
```

#### Complex Type Examples

```python
from typing import Dict, List, Optional, Set, Tuple, Union

def process_data(
    items: List[Dict[str, Union[int, str]]],
    config: Optional[Dict[str, str]] = None
) -> bool:
    """Process data items with optional configuration.

    Args:
        items (List[Dict[str, Union[int, str]]]): Data items to process.
        config (Optional[Dict[str, str]]): Optional configuration dict.

    Returns:
        bool: True if processing succeeded.
    """
    pass


def get_coordinates() -> Tuple[float, float]:
    """Returns latitude and longitude coordinates.

    Returns:
        Tuple[float, float]: Latitude and longitude pair.
    """
    return (37.7749, -122.4194)


def get_unique_ids(data: List[int]) -> Set[int]:
    """Extracts unique IDs from data.

    Args:
        data (List[int]): List of IDs.

    Returns:
        Set[int]: Unique IDs.
    """
    return set(data)


def create_processor(
    mode: str
) -> Callable[[List[int]], List[int]]:
    """Factory function that returns a data processor.

    Args:
        mode (str): Processing mode.

    Returns:
        Callable[[List[int]], List[int]]: Processor function.
    """
    def processor(data: List[int]) -> List[int]:
        return data
    return processor
```

#### Class Attributes with Type Hints

```python
from typing import Dict, List, Optional

class DataProcessor:
    """Processes data with configurable options.

    Attributes:
        data (List[int]): Input data to process.
        cache (Dict[str, int]): Cache for processed results.
        threshold (Optional[float]): Optional processing threshold.
    """

    data: List[int]
    cache: Dict[str, int]
    threshold: Optional[float]

    def __init__(
        self,
        data: List[int],
        threshold: Optional[float] = None
    ):
        """Initializes DataProcessor.

        Args:
            data (List[int]): Input data.
            threshold (Optional[float]): Optional threshold value.
        """
        self.data = data
        self.cache = {}
        self.threshold = threshold
```

### Error Handling

Use specific exceptions rather than bare `except`:

```python
try:
    value = collection[key]
except KeyError:
    # Handle missing key
    pass
```

Document raised exceptions in docstrings.

### Main Guard

Always use main guard for executable scripts:

```python
def main():
    """Main function."""
    pass


if __name__ == "__main__":
    main()
```

### Comments

- Use inline comments sparingly
- Keep comments up-to-date with code
- Write complete sentences
- Block comments should be indented to the same level as code

```python
# We use a weighted dictionary search to find out where i is in
# the array. We extrapolate position based on the largest num
# in the array and the array size and then do binary search to
# get the exact number.
```

## Testing

### Framework
Prefer **pytest** for testing:

```python
def test_function_name():
    """Test description following Google style.

    Tests should verify specific behavior and edge cases.
    """
    result = function_name(input_value)
    assert result == expected_value
```

### Test Organization
- Place tests in `tests/` directory
- Name test files `test_*.py`
- Mirror source structure in tests directory
- One test file per source module

## Project Structure

Standard Python project layout:
```
project/
├── src/
│   └── package/
│       ├── __init__.py
│       └── module.py
├── tests/
│   └── test_module.py
├── pyproject.toml
├── README.md
└── .gitignore
```

## uv Configuration

For projects using uv, include in `pyproject.toml`:

```toml
[project]
name = "project-name"
version = "0.1.0"
description = "Project description"
dependencies = [
    "requests>=2.31.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "mypy>=1.0.0",
    "ruff>=0.1.0",
]

[tool.ruff]
line-length = 80
target-version = "py311"

[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
```

## Summary Checklist

When writing Python code, ensure:
- [ ] Google Style Guide formatting (80 char lines, proper naming)
- [ ] Google-style docstrings for all public functions/classes
- [ ] Type hints on function signatures using `typing` module
- [ ] Use `List`, `Dict`, `Set`, `Tuple` from typing (not built-in types)
- [ ] uv script headers for standalone scripts
- [ ] Bash scripts detect uv and fall back to python3
- [ ] Proper import organization (stdlib, third-party, local)
- [ ] pytest for testing
- [ ] Main guard for executable scripts
- [ ] Specific exception handling (no bare except)
