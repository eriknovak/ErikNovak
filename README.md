# Erik Novak

**Data Scientist** at Event Registry

### Research Focus
Artificial Intelligence • Natural Language Processing • Cross-lingual Language Models • Semi-Automatic Text Processing • Data Visualization

**Connect:** [LinkedIn](https://www.linkedin.com/in/novakerik/) | [Homepage]

## Development Environment

This repository contains personal development environment configurations and dotfiles. To install, run:

```bash
./setup.sh
```

### Configuration Stack

- **Shell:** Bash with [Starship](https://starship.rs/) prompt featuring Catppuccin Mocha theme
- **Terminal Multiplexer:** Tmux with Catppuccin theme, vim-style key bindings, and TPM plugin management
- **Text Editors:** Nano and Vim configured with syntax highlighting and custom themes
- **Version Control:** Git with enhanced colorized output and productivity aliases (`lg`, `st`, `up`)
- **Python Environment:** UV package manager with convenient aliases
- **Node.js Runtime:** nvm (Node Version Manager) for version management

## Open Source Contributions

### Python Packages

| **Package** | **Description** | **GitHub Stars** | **PyPI** |
|-------------|-----------------|------------------|---------|
| [anonipy](https://github.com/eriknovak/anonipy) | Data anonymization library supporting multiple anonymization strategies and techniques | ![Stars](https://img.shields.io/github/stars/eriknovak/anonipy) | ![PyPi](https://img.shields.io/pypi/v/anonipy?color=%2334D058)  |
| [datachart](https://github.com/eriknovak/datachart) | Flexible data visualization library with simple API and extensive customization options | ![Stars](https://img.shields.io/github/stars/eriknovak/datachart) | ![PyPi](https://img.shields.io/pypi/v/datachart?color=%2334D058) |


### Research Datasets

| **Dataset** | **Description** | **GitHub Stars** | **Repository** |
|-------------|-----------------|------------------|----------------|
| [OG2021](https://github.com/E3-JSI/dataset-OG2021) | Comprehensive dataset from the 2021 Tokyo Olympics | ![Stars](https://img.shields.io/github/stars/E3-JSI/dataset-OG2021) | [Clarin.si](https://www.clarin.si/repository/xmlui/handle/11356/1921)  |
| [SloATOMIC 2020](https://github.com/E3-JSI/dataset-SloATOMIC-2020) | Slovene translation of the ATOMIC 2020 commonsense reasoning dataset | ![Stars](https://img.shields.io/github/stars/E3-JSI/dataset-SloATOMIC-2020) | [Clarin.si](https://www.clarin.si/repository/xmlui/handle/11356/1724) |

### Project Templates

#### Machine Learning with DVC

**[eriknovak/cookiecutter-ml-dvc](https://github.com/eriknovak/cookiecutter-ml-dvc)** — Template for machine learning experiments using [DVC] for version control and reproducibility (in development).

```bash
# Install pipx for running cookiecutter
pip install pipx
# Create a new project using the template
pipx run cookiecutter gh:eriknovak/cookiecutter-ml-dvc
```

#### Machine Learning on HPC Systems

**[eriknovak/cookiecutter-ml-hpc](https://github.com/eriknovak/cookiecutter-ml-hpc)** — Template for machine learning experiments on HPC clusters with [SLURM] workload manager (in development).

```bash
# Install pipx for running cookiecutter
pip install pipx
# Create a new project using the template
pipx run cookiecutter gh:eriknovak/cookiecutter-ml-hpc
```

[Homepage]: https://ailab.ijs.si/eriknovak/
[DVC]: https://dvc.org/
[SLURM]: https://www.schedmd.com/slurm/




