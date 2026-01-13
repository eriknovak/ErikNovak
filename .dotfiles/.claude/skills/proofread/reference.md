# Proofreading Reference Guide

Detailed guidelines for the proofreading skill. Reference the `scientific-papers.md` rules file for comprehensive scientific writing standards.

## Quick Reference: Common Errors

### Grammar Fixes

| Wrong | Right | Rule |
|-------|-------|------|
| "in order to" | "to" | Wordiness |
| "due to the fact that" | "because" | Wordiness |
| "a number of" | "several" or specific number | Vague |
| "utilize" | "use" | Pretentious |
| "very unique" | "unique" | Unique is absolute |
| "methodology" | "method" | Unless discussing study of methods |

### LaTeX Symbol Fixes

| Wrong (ASCII) | Right (LaTeX) | Rendered |
|---------------|---------------|----------|
| `->` | `\rightarrow` | → |
| `>=` | `\geq` | ≥ |
| `<=` | `\leq` | ≤ |
| `!=` | `\neq` | ≠ |
| `~=` | `\approx` | ≈ |
| `alpha` | `\alpha` | α |
| `sum` | `\sum` | ∑ |
| `inf` | `\infty` | ∞ |
| `in` | `\in` | ∈ |
| `sqrt(x)` | `\sqrt{x}` | √x |

### Citation Spacing

```latex
% Wrong
as shown in\cite{smith2024}
as shown in [1]

% Right
as shown in~\cite{smith2024}
as shown by Smith~\cite{smith2024}
```

### Reference Commands

```latex
% Good practice with cleveref
\cref{sec:intro}      % → section 1
\Cref{sec:intro}      % → Section 1
\cref{fig:arch}       % → figure 1
\cref{eq:loss}        % → equation (1)

% Standard refs need type prefix
Section~\ref{sec:intro}
Figure~\ref{fig:arch}
Equation~\ref{eq:loss}
```

## Tense Guidelines

| Section | Tense | Example |
|---------|-------|---------|
| Methods | Past | "We trained the model..." |
| Results | Past | "The model achieved..." |
| General truths | Present | "Neural networks are..." |
| Contributions | Present | "We propose...", "This paper presents..." |

## Abstract Checklist

1. **Context** (1-2 sentences): Sets up the problem area
2. **Gap** (1 sentence): What's missing in current work
3. **Approach** (2-3 sentences): Your solution
4. **Results** (2-3 sentences): Key quantitative findings
5. **Impact** (1 sentence): Significance or availability

**Violations to flag:**
- Citations in abstract
- Undefined acronyms
- Mathematical notation (unless essential)
- More than 250 words

## Structure Red Flags

### Introduction
- [ ] Starts too narrow (should be broad → specific)
- [ ] Missing clear problem statement
- [ ] No explicit contributions list
- [ ] Contributions buried in middle of section

### Related Work
- [ ] Organized chronologically (should be thematic)
- [ ] No comparison to your work
- [ ] Missing recent work (last 2-3 years)

### Results
- [ ] Results without baseline comparison
- [ ] Missing statistical significance
- [ ] Figures/tables not referenced in text
- [ ] Cherry-picked results

### Conclusion
- [ ] Introduces new information
- [ ] Missing limitations
- [ ] No future work suggestions

## Notation Consistency Checks

Flag when paper uses:
- Both `\mathbf{x}` and `\vec{x}` for vectors
- Inconsistent subscript style (`x_i` vs `x_{i}`)
- Symbol used before defined
- Same symbol for different meanings

## Sentence-Level Issues

### Run-on Sentences
```
% Wrong
The model performs well it achieves high accuracy.

% Right
The model performs well. It achieves high accuracy.
% or
The model performs well, achieving high accuracy.
```

### Comma Splices
```
% Wrong
The results are promising, they exceed the baseline.

% Right
The results are promising; they exceed the baseline.
% or
The results are promising. They exceed the baseline.
```

### Dangling Modifiers
```
% Wrong
Using the proposed method, accuracy improved.

% Right
Using the proposed method, we improved accuracy.
```

## Overclaiming Detector

Flag these words/phrases:
- "revolutionary"
- "breakthrough"
- "novel" (unless truly novel)
- "significantly better" (without p-value)
- "outperforms all existing methods" (unless proven)
- "first to" (verify claim)
- "state-of-the-art" (without evidence)

## Reproducibility Checklist

Flag if missing:
- [ ] Dataset details (size, splits)
- [ ] Hyperparameters
- [ ] Hardware specs
- [ ] Training time
- [ ] Random seeds or variance
- [ ] Code availability

## Output Template

```markdown
# Proofreading Report

**Document:** [filename]
**Type:** [LaTeX paper / Markdown / Plain text]
**Word Count:** [X words]
**Overall Assessment:** [1-2 sentence summary]

---

## Critical Issues (X found)

### Issue 1: [Category]
**Location:** [Line/Section]
**Problem:** [Description]
**Current:** `[text]`
**Suggested:** `[text]`
**Reason:** [Explanation]

---

## Recommendations (Y found)

### Issue 1: [Category]
...

---

## Style Suggestions (Z found)

### Issue 1: [Category]
...

---

## Summary Statistics
| Category | Count |
|----------|-------|
| Critical | X |
| Recommendations | Y |
| Style | Z |
| **Total** | **N** |

## Positive Notes
[What the document does well - optional]
```
