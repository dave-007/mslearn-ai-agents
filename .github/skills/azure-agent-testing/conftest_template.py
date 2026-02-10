"""
Shared pytest fixtures for Azure AI Agent exercise tests.
Copy this file to Labfiles/<exercise>/Python/tests/conftest.py
"""
import os
import pytest
from unittest.mock import MagicMock, patch


def pytest_addoption(parser):
    parser.addoption(
        "--run-integration",
        action="store_true",
        default=False,
        help="Run integration tests that require live Azure credentials",
    )


def pytest_collection_modifyitems(config, items):
    if not config.getoption("--run-integration"):
        skip_integration = pytest.mark.skip(reason="Need --run-integration to run")
        for item in items:
            if "integration" in item.keywords:
                item.add_marker(skip_integration)


@pytest.fixture
def mock_env(monkeypatch):
    """Set up mock environment variables matching .env template."""
    monkeypatch.setenv("PROJECT_ENDPOINT", "https://test-project.cognitiveservices.azure.com/")
    monkeypatch.setenv("MODEL_DEPLOYMENT_NAME", "gpt-4.1")


@pytest.fixture
def mock_credential():
    """Mock DefaultAzureCredential as a context manager."""
    with patch("azure.identity.DefaultAzureCredential") as mock_cls:
        cred_instance = MagicMock()
        mock_cls.return_value = cred_instance
        cred_instance.__enter__ = MagicMock(return_value=cred_instance)
        cred_instance.__exit__ = MagicMock(return_value=False)
        yield cred_instance


@pytest.fixture
def mock_project_client():
    """
    Mock AIProjectClient with nested OpenAI client.

    Returns (project_client, openai_client) tuple.
    """
    with patch("azure.ai.projects.AIProjectClient") as mock_cls:
        project = MagicMock()
        mock_cls.return_value = project
        project.__enter__ = MagicMock(return_value=project)
        project.__exit__ = MagicMock(return_value=False)

        # Agent operations
        mock_agent = MagicMock()
        mock_agent.name = "test-agent"
        mock_agent.version = "1.0"
        project.agents.create_version.return_value = mock_agent
        project.agents.delete.return_value = None

        # OpenAI client (nested context manager)
        openai = MagicMock()
        openai_cm = MagicMock()
        openai_cm.__enter__ = MagicMock(return_value=openai)
        openai_cm.__exit__ = MagicMock(return_value=False)
        project.get_openai_client.return_value = openai_cm

        # Conversation
        mock_conv = MagicMock()
        mock_conv.id = "conv-test-123"
        openai.conversations.create.return_value = mock_conv

        # Response
        mock_response = MagicMock()
        mock_response.status = "completed"
        mock_response.output_text = "Test response from agent"
        openai.responses.create.return_value = mock_response

        # File upload
        mock_file = MagicMock()
        mock_file.id = "file-test-456"
        mock_file.filename = "data.txt"
        openai.files.create.return_value = mock_file

        yield project, openai


@pytest.fixture
def exercise_path():
    """Return the path to the exercise's Python directory (parent of tests/)."""
    return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
