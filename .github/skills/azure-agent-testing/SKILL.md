---
name: azure-agent-testing
description: Specialized patterns for testing Azure AI Agent Service applications with pytest. Includes mock factories, assertion helpers, and common test scenarios for agent creation, tool calling, and conversation management.
---

# Azure AI Agent Testing Skill

## When to Use

Use this skill when writing or reviewing tests for any code that interacts with:
- `azure.ai.projects.AIProjectClient`
- `azure.ai.agents` classes
- OpenAI compatibility layer via `project_client.get_openai_client()`
- Agent tools (CodeInterpreter, custom functions, MCP)

## Mock Factory Patterns

### Mock a complete agent lifecycle

```python
from unittest.mock import MagicMock, patch, PropertyMock

def create_mock_agent_lifecycle():
    """Create a fully mocked agent lifecycle for testing."""
    # Credential
    mock_cred = MagicMock()

    # Project client
    mock_project = MagicMock()
    mock_agent = MagicMock(name="test-agent", version="1.0")
    mock_project.agents.create_version.return_value = mock_agent
    mock_project.agents.delete.return_value = None

    # OpenAI client
    mock_openai = MagicMock()
    mock_conversation = MagicMock(id="conv-123")
    mock_openai.conversations.create.return_value = mock_conversation

    mock_response = MagicMock()
    mock_response.status = "completed"
    mock_response.output_text = "Analysis complete: mean=42.5, std=3.2"
    mock_openai.responses.create.return_value = mock_response

    mock_project.get_openai_client.return_value.__enter__ = MagicMock(
        return_value=mock_openai
    )
    mock_project.get_openai_client.return_value.__exit__ = MagicMock(
        return_value=False
    )

    return mock_cred, mock_project, mock_openai, mock_agent, mock_conversation
```

### Assert agent was created with expected tools

```python
def assert_agent_has_tool(mock_project, tool_type_name):
    """Verify an agent was created with a specific tool type."""
    call_args = mock_project.agents.create_version.call_args
    definition = call_args.kwargs.get("definition") or call_args[1].get("definition")
    tool_types = [type(t).__name__ for t in definition.tools]
    assert tool_type_name in tool_types, (
        f"Expected {tool_type_name} in agent tools, found: {tool_types}"
    )
```

### Assert conversation cleanup happened

```python
def assert_cleanup_performed(mock_openai, mock_project, conversation_id, agent_name):
    """Verify both conversation and agent were properly cleaned up."""
    mock_openai.conversations.delete.assert_called_once_with(
        conversation_id=conversation_id
    )
    mock_project.agents.delete.assert_called_once()
    delete_call = mock_project.agents.delete.call_args
    assert delete_call.kwargs.get("agent_name") == agent_name
```

## Common Test Scenarios

### Test: Agent handles API failure gracefully

```python
def test_handles_failed_response(mock_env, mock_project_client):
    client, openai = mock_project_client
    response = MagicMock()
    response.status = "failed"
    response.error = "Rate limit exceeded"
    openai.responses.create.return_value = response

    # Run the agent code and verify it doesn't crash
    # Verify error message is surfaced to user
```

### Test: Custom function tool is registered correctly

```python
def test_custom_function_registered(mock_env, mock_project_client):
    client, openai = mock_project_client
    # Verify FunctionTool was created with correct schema
    # Verify function name and parameters match expected
```

### Test: File upload for Code Interpreter

```python
def test_file_uploaded_for_code_interpreter(mock_env, mock_project_client, tmp_path):
    client, openai = mock_project_client

    # Create a temp data file
    data_file = tmp_path / "data.txt"
    data_file.write_text("Product,Sales\nWidgets,100\nGadgets,200")

    # Verify openai.files.create was called with correct purpose
    openai.files.create.assert_called_once()
    call_args = openai.files.create.call_args
    assert call_args.kwargs.get("purpose") == "assistants"
```

## pytest Configuration

Add to `pyproject.toml` or `pytest.ini`:

```ini
[tool:pytest]
markers =
    integration: marks tests that require live Azure credentials (deselect with '-m "not integration"')
testpaths = ["tests"]
```

## Running Tests

```bash
# All non-integration tests (default)
pytest

# Include integration tests
pytest --run-integration

# Specific exercise
pytest Labfiles/02-build-ai-agent/Python/tests/

# With coverage
pytest --cov=. --cov-report=term-missing
```
