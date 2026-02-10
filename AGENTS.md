# AGENTS.md — Azure AI Agents Training Repo

## Project Overview

This is a hands-on training repository for building AI agents on Microsoft Azure. It contains step-by-step exercises with instruction markdown files and corresponding starter code.

## Repository Structure

- `Instructions/*.md` — Exercise instructions with code blocks to paste into starter files
- `Labfiles/<number>-<slug>/Python/` — Starter code with comment placeholders
- `Labfiles/<number>-<slug>/Python/solution/` — Completed solution files (our additions)
- `Labfiles/<number>-<slug>/Python/tests/` — pytest test suites (our additions)
- `.github/` — Copilot customizations (agents, instructions, prompts, skills)

## Dev Environment

- Python 3.12+
- Virtual environments: `python -m venv labenv && source labenv/bin/activate`
- Install deps: `pip install -r requirements.txt`
- Config: `.env` files with `PROJECT_ENDPOINT` and `MODEL_DEPLOYMENT_NAME`

## Testing

- Framework: pytest with pytest-asyncio
- Run: `pytest Labfiles/<exercise>/Python/tests/`
- Integration tests need `--run-integration` flag and live Azure credentials
- Unit tests use mocked Azure SDK clients — no credentials needed

## Key Conventions

- Comment placeholders in starter code (e.g., `# Add references`) are insertion points for code from Instructions
- Solution files contain the complete code with all blocks applied
- Always use context managers (`with` blocks) for Azure SDK clients
- Always clean up agents and conversations at the end of exercises
- `.env` files use `your_project_endpoint` as placeholder value

## Common Commands

```bash
# Syntax check
python -m py_compile Labfiles/02-build-ai-agent/Python/agent.py

# Run tests
pytest Labfiles/02-build-ai-agent/Python/tests/ -v

# Lint
ruff check Labfiles/

# Build docs locally
bundle exec jekyll serve
```

## File Ownership

- Files from upstream `MicrosoftLearning/mslearn-ai-agents` should not be modified
- Custom content lives in `solution/`, `tests/`, and new exercise directories
- See `.github/CUSTOM_CONTENT.md` for inventory of our additions
