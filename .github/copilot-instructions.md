# Repository Custom Instructions for GitHub Copilot

## Project Overview

This is a fork of `MicrosoftLearning/mslearn-ai-agents` — a hands-on training repo for building AI agents on Microsoft Azure using Azure AI Foundry, Azure AI Agent Service, Semantic Kernel, and the Microsoft Foundry SDK.

The repo is actively extended with additional exercises, solution files, and unit tests beyond the upstream content.

## Repository Structure

```
├── Instructions/          # Markdown exercise files (01-*.md, 02-*.md, etc.)
│   └── Media/             # Screenshots and images for exercises
├── Labfiles/              # Starter code organized by exercise number
│   ├── 01-agent-fundamentals/
│   ├── 02-build-ai-agent/
│   │   └── Python/        # Each exercise has a Python subfolder
│   │       ├── agent.py   # Starter code with placeholder comments
│   │       ├── .env       # Config template (PROJECT_ENDPOINT, MODEL_DEPLOYMENT_NAME)
│   │       ├── requirements.txt
│   │       └── data.txt   # Sample data files
│   ├── 03-ai-agent-functions/
│   ├── 03b-build-multi-agent-solution/
│   ├── 03c-use-agent-tools-with-mcp/
│   ├── 04-agent-framework/
│   └── 05-agent-orchestration/
├── index.md               # GitHub Pages landing page
├── _config.yml / _build.yml
└── .github/               # Copilot customizations (this directory)
```

## Exercise Format Conventions

### Instruction files (`Instructions/*.md`)

- Numbered sequentially: `01-`, `02-`, `03-`, `03b-`, `03c-`, `04-`, `05-`
- Written in second person ("you'll", "enter the following command")
- Include estimated completion time (typically 30 minutes)
- Structure: Overview → Azure setup → Clone repo → Configure → Add code blocks → Run → Clean up
- Code blocks are fenced with triple backticks and language identifier
- Comments in starter code serve as insertion points (e.g., `# Add references`)
- Tips use `> **Tip**: ...` blockquote format
- Notes use `> **Note**: ...` blockquote format

### Labfiles (starter code)

- Python 3.12+ required
- Each exercise folder contains a `Python/` subfolder
- Starter `.py` files have comment placeholders where students paste code blocks from instructions
- `.env` files use `your_project_endpoint` as placeholder
- `requirements.txt` lists pip dependencies
- Virtual environment pattern: `python -m venv labenv`

### Solution files convention

- Solution files go in `Labfiles/<exercise>/Python/solution/`
- They are the complete, working version with all code blocks applied
- Preserve all original comments for readability
- Include a header comment: `# SOLUTION FILE - All code blocks from Instructions/<exercise>.md applied`

## Key Azure AI Technologies

- **Azure AI Foundry** (portal at ai.azure.com) — project hub
- **Azure AI Agent Service** — managed agent hosting
- **Microsoft Foundry SDK** (`azure-ai-projects`, `azure-ai-agents`)
- **OpenAI SDK** via `project_client.get_openai_client()`
- **Semantic Kernel** (`semantic-kernel` package)
- **Agent Framework** (`agent-framework` package)
- **Code Interpreter Tool** — built-in sandboxed code execution
- **Custom Functions / Tool Calling** — function-based agent tools
- **Model Context Protocol (MCP)** — external tool integration
- **Multi-agent orchestration** — coordinating multiple specialized agents

## Coding Standards

- Python: PEP 8, type hints encouraged, f-strings for formatting
- Use `DefaultAzureCredential` for authentication (exclude environment + managed identity for local dev)
- Use context managers (`with` blocks) for SDK clients
- Always clean up agents and threads/conversations at the end
- Environment variables via `.env` files loaded with `python-dotenv`
- Error handling: check `response.status == "failed"` patterns

## Testing Conventions

- Tests go in `Labfiles/<exercise>/Python/tests/`
- Use `pytest` with `pytest-asyncio` for async tests
- Mock Azure SDK clients using `unittest.mock`
- Test file naming: `test_<exercise_name>.py`
- Test categories: unit tests (mocked), integration tests (require Azure), smoke tests (syntax/import)
- Mark integration tests with `@pytest.mark.integration`
- All tests should be runnable without Azure credentials by default (mocked)

## Build and Validation

- No CI pipeline currently — exercises are validated manually
- Python syntax check: `python -m py_compile <file>`
- Lint: `flake8` or `ruff`
- Test: `pytest Labfiles/<exercise>/Python/tests/`
- Docs build: Jekyll via `_config.yml` for GitHub Pages

## Important Notes

- The upstream repo (`MicrosoftLearning/mslearn-ai-agents`) is the source of truth for base exercises
- Custom extensions should not modify upstream files — create new files or folders
- Azure services require an active subscription with sufficient quota
- Model deployments (gpt-4.1, gpt-4o) may have regional availability constraints
- Some APIs are in preview and may change
