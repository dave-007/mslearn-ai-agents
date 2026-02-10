# Custom Content Inventory

This document catalogs all files added to this fork beyond the upstream `MicrosoftLearning/mslearn-ai-agents` repository.

---

## 📄 Root-Level Documentation

- `AGENTS.md` — Overview of Azure AI Agents training repo structure and conventions
- `SOLUTIONS.md` — Documentation for solution files and testing framework
- `LAB_PREREQUISITES.md` — Setup guide for shared vs per-lab environments, authentication
- `AUTOMATION_QUICKSTART.md` — Quick start guide for lab automation scripts
- `.gitignore` — Git ignore patterns for Python, Azure, and lab-generated files

---

## 🧪 Solution Files

Complete, working implementations with all code blocks from exercises applied.

### Exercise 02: Build AI Agent
- `Labfiles/02-build-ai-agent/Solution/agent.py`
- `Labfiles/02-build-ai-agent/Solution/data.txt`
- `Labfiles/02-build-ai-agent/Solution/requirements.txt`

### Exercise 03: AI Agent Functions
- `Labfiles/03-ai-agent-functions/Solution/agent.py`
- `Labfiles/03-ai-agent-functions/Solution/requirements.txt`
- `Labfiles/03-ai-agent-functions/Solution/README.md`
- `Labfiles/03-ai-agent-functions/Solution/SOLUTION_NOTES.md`

### Exercise 03b: Build Multi-Agent Solution
- `Labfiles/03b-build-multi-agent-solution/Solution/agent_triage.py`
- `Labfiles/03b-build-multi-agent-solution/Solution/requirements.txt`
- `Labfiles/03b-build-multi-agent-solution/Solution/README.md`

### Exercise 03c: Use Agent Tools with MCP
- `Labfiles/03c-use-agent-tools-with-mcp/Solution/client.py`
- `Labfiles/03c-use-agent-tools-with-mcp/Solution/requirements.txt`

### Exercise 03d: Use Local MCP Server Tools
- `Labfiles/03d-use-local-mcp-server-tools/Solution/client.py`
- `Labfiles/03d-use-local-mcp-server-tools/Solution/server.py`
- `Labfiles/03d-use-local-mcp-server-tools/Solution/requirements.txt`

### Exercise 04: Agent Framework
- `Labfiles/04-agent-framework/Solution/agent-framework.py`
- `Labfiles/04-agent-framework/Solution/data.txt`

### Exercise 05: Agent Orchestration
- `Labfiles/05-agent-orchestration/Solution/agents.py`

### Exercise 06: Build Remote Agents with A2A
- `Labfiles/06-build-remote-agents-with-a2a/Solution/client.py`
- `Labfiles/06-build-remote-agents-with-a2a/Solution/requirements.txt`
- `Labfiles/06-build-remote-agents-with-a2a/Solution/run_all.py`
- `Labfiles/06-build-remote-agents-with-a2a/Solution/README.md`
- `Labfiles/06-build-remote-agents-with-a2a/Solution/COMPLETION_SUMMARY.md`
- `Labfiles/06-build-remote-agents-with-a2a/Solution/SOLUTION_COMPLETE.txt`
- `Labfiles/06-build-remote-agents-with-a2a/Solution/outline_agent/` (directory)
- `Labfiles/06-build-remote-agents-with-a2a/Solution/routing_agent/` (directory)
- `Labfiles/06-build-remote-agents-with-a2a/Solution/title_agent/` (directory)

### Exercise 08: Build Workflow MS Foundry
- `Labfiles/08-build-workflow-ms-foundry/Solution/workflow.py`
- `Labfiles/08-build-workflow-ms-foundry/Solution/requirements.txt`

### Exercise 09: Integrate Agent with Foundry IQ
- `Labfiles/09-integrate-agent-with-foundry-iq/Solution/agent_client.py`
- `Labfiles/09-integrate-agent-with-foundry-iq/Solution/requirements.txt`
- `Labfiles/09-integrate-agent-with-foundry-iq/Solution/data/contoso-backpacks-guide.pdf`
- `Labfiles/09-integrate-agent-with-foundry-iq/Solution/data/contoso-backpacks-guide.md`
- `Labfiles/09-integrate-agent-with-foundry-iq/Solution/data/contoso-camping-accessories.pdf`
- `Labfiles/09-integrate-agent-with-foundry-iq/Solution/data/contoso-camping-accessories.md`
- `Labfiles/09-integrate-agent-with-foundry-iq/Solution/data/contoso-tents-catalog.pdf`
- `Labfiles/09-integrate-agent-with-foundry-iq/Solution/data/contoso-tents-catalog.md`
- `Labfiles/09-integrate-agent-with-foundry-iq/Solution/data/contoso-products.zip`

---

## 🧪 Test Suites

*Note: Test suites are planned but not yet implemented. Future additions will include:*

- `Labfiles/*/Python/tests/test_*.py` — pytest test files for each exercise
- `Labfiles/*/Python/tests/conftest.py` — shared test fixtures and configuration

---

## 🤖 Lab Automation Scripts

Automated setup and teardown scripts to provision Azure resources without manual portal work.

### Documentation
- `Labfiles/AUTOMATION_README.md` — Complete guide to automation scripts
- `Labfiles/_templates/README.md` — Template customization guide

### Shared Environment Scripts
- `Labfiles/setup-shared-environment.ps1` — Creates one Foundry project for all labs (recommended)
- `Labfiles/teardown-shared-environment.ps1` — Cleans up shared environment
- `Labfiles/.env.shared` — Shared configuration (auto-generated, gitignored)
- `Labfiles/.labstate.shared` — Shared state tracking (auto-generated, gitignored)

### Per-Lab Automation

#### Lab 02: Build AI Agent
- `Labfiles/02-build-ai-agent/setup.ps1` — Provisions project and model
- `Labfiles/02-build-ai-agent/teardown.ps1` — Cleans up resources

#### Lab 09: Integrate Agent with Foundry IQ
- `Labfiles/09-integrate-agent-with-foundry-iq/setup.ps1` — Provisions project, Search, Storage, uploads data
- `Labfiles/09-integrate-agent-with-foundry-iq/teardown.ps1` — Cleans up all resources

### Templates for Other Labs
- `Labfiles/_templates/setup-template.ps1` — Starter template for new lab setup scripts
- `Labfiles/_templates/teardown-template.ps1` — Starter template for new lab teardown scripts

### Auto-generated Files (gitignored)
- `Labfiles/*/.labstate` — JSON state file tracking provisioned resources
- `Labfiles/*/Python/.env` — Environment configuration (auto-populated by setup scripts)

**Note:** Each lab's .labstate and .env files are gitignored to prevent credential leakage.

---

## 🤖 GitHub Copilot Customizations

### Base Configuration
- `.github/copilot-instructions.md` — Base instructions for all Copilot interactions
- `.github/copilot-setup-steps.yml` — Pre-install dependencies for Copilot coding agent
- `.github/README.md` — Documentation for all Copilot customizations

### Custom Agents (`.github/agents/`)
- `.github/agents/solution-builder.agent.md` — Generates solution files from instructions
- `.github/agents/exercise-creator.agent.md` — Creates new exercises matching repo format
- `.github/agents/test-writer.agent.md` — Generates pytest test suites
- `.github/agents/capability-scout.agent.md` — Researches Azure docs for new exercise ideas
- `.github/agents/repo-updater.agent.md` — Syncs upstream changes, manages custom content
- `.github/agents/README.md` — Agent directory index

### Instructions (`.github/instructions/`)
- `.github/instructions/python-azure-agents.instructions.md` — Python Azure SDK coding patterns
  - **Applies to:** `**/*.py`
- `.github/instructions/exercise-markdown.instructions.md` — Exercise formatting conventions
  - **Applies to:** `Instructions/**/*.md`

### Reusable Prompts (`.github/prompts/`)
- `.github/prompts/generate-solution.prompt.md` — Build solution for specific exercise
- `.github/prompts/generate-tests.prompt.md` — Create test suite for specific exercise
- `.github/prompts/suggest-exercises.prompt.md` — Research and propose new exercises

### Skills (`.github/skills/`)
- `.github/skills/azure-agent-testing/SKILL.md` — Pytest patterns for Azure AI agents
- `.github/skills/azure-agent-testing/conftest_template.py` — Reusable test fixtures

---

## 📋 Ownership Rules

### Never Modify (Upstream Files)
Files in the following locations should **never be modified** as they come from upstream:

- `Instructions/*.md` (except additions, not edits)
- `Labfiles/*/Python/*.py` (starter code)
- `Labfiles/*/Python/requirements.txt` (starter dependencies)
- `Labfiles/*/Python/.env` (starter config templates)
- `Labfiles/*/Python/data.txt` (sample data)
- Root-level files: `index.md`, `_config.yml`, `_build.yml`, `LICENSE`, `readme.md`

### Safe to Modify (Custom Content)
All files listed in this document are **custom additions** and can be freely modified:

- Anything in `Solution/` folders
- Anything in `tests/` folders (when created)
- Anything in `.github/` except standard templates
- `AGENTS.md` and `SOLUTIONS.md`

---

## 🔄 Sync Strategy

When syncing with upstream `MicrosoftLearning/mslearn-ai-agents`:

1. **Always preserve:**
   - All `Solution/` folders
   - All `tests/` folders
   - All `.github/` customizations
   - `AGENTS.md` and `SOLUTIONS.md`

2. **Flag for review:**
   - Changes to `Instructions/*.md` that might affect solution files
   - Changes to starter code that might break existing solutions
   - New exercises in upstream that need solution files

3. **Auto-merge:**
   - Updates to `index.md`
   - Changes to Jekyll configuration
   - Media file additions
   - README updates (except conflicting content)

---

**Last Updated:** February 10, 2026  
**Maintainer:** Repository fork owner  
**Upstream:** `MicrosoftLearning/mslearn-ai-agents`
