# GitHub Copilot Customizations for mslearn-ai-agents

This directory contains custom agents, instructions, prompts, and skills that supercharge GitHub Copilot for working with this Azure AI agents training repository.

## 🤖 Custom Agents (`.github/agents/`)

Select these from the agents dropdown in VS Code or assign to issues on GitHub.com.

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| **solution-builder** | Generates complete solution files from exercise instructions | "Build the solution for exercise 02" |
| **exercise-creator** | Creates new exercises matching the repo's format | "Create an exercise for file search RAG" |
| **test-writer** | Generates pytest test suites for exercises | "Write tests for exercise 03" |
| **capability-scout** | Researches Azure docs and suggests new exercises | "What capabilities aren't covered yet?" |
| **repo-updater** | Syncs upstream changes and manages custom content | "Sync with upstream and check for conflicts" |

## 📋 Instructions (`.github/instructions/`)

These apply automatically based on file patterns:

| File | Applies To | What It Does |
|------|-----------|--------------|
| `python-azure-agents.instructions.md` | `**/*.py` | Azure SDK coding patterns, auth, cleanup |
| `exercise-markdown.instructions.md` | `Instructions/**/*.md` | Exercise formatting and voice conventions |

## ⚡ Reusable Prompts (`.github/prompts/`)

Use with `/` commands in Copilot Chat:

| Prompt | Command | Description |
|--------|---------|-------------|
| `generate-solution` | `/generate-solution` | Build a solution for a specific exercise |
| `generate-tests` | `/generate-tests` | Create a test suite for a specific exercise |
| `suggest-exercises` | `/suggest-exercises` | Research and propose new exercises |

## 🛠 Skills (`.github/skills/`)

| Skill | Description |
|-------|-------------|
| `azure-agent-testing` | Mock patterns, assertion helpers, and pytest config for testing Azure AI agents |

## 📄 Other Files

| File | Purpose |
|------|---------|
| `copilot-instructions.md` | Base instructions applied to ALL Copilot interactions in this repo |
| `copilot-setup-steps.yml` | Pre-installs dependencies for Copilot coding agent environment |
| `CUSTOM_CONTENT.md` | Inventory of files added beyond the upstream repo |

## Getting Started

1. **Open the repo in VS Code** with GitHub Copilot extension installed
2. Agents will appear automatically in the agents dropdown
3. Instructions apply automatically when editing matching files
4. Use `/` in chat to access reusable prompts

## Typical Workflows

### "I want to study an exercise with the solution ready"
1. Select the **solution-builder** agent
2. Say: "Build the solution for exercise 02-build-ai-agent"
3. The agent reads the instructions, applies all code blocks, and saves the solution

### "I want to verify my solution works"
1. Select the **test-writer** agent
2. Say: "Write tests for exercise 02"
3. Run: `pytest Labfiles/02-build-ai-agent/Python/tests/ -v`

### "I want to create a new exercise"
1. Select the **capability-scout** agent first
2. Say: "What Azure AI agent capabilities aren't covered yet?"
3. Pick a topic from the suggestions
4. Switch to the **exercise-creator** agent
5. Say: "Create an exercise for [chosen topic]"

### "I need to sync with upstream"
1. Select the **repo-updater** agent
2. Say: "Sync with upstream and check for any conflicts with our custom content"
