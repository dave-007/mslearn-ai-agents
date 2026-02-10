---
applyTo: "**/*.py"
---

# Python Coding Guidelines for Azure AI Agent Exercises

## SDK Import Conventions

Always import in this order:
1. Standard library (`os`, `json`, `asyncio`)
2. Third-party (`dotenv`)
3. Azure Identity (`azure.identity`)
4. Azure AI SDK (`azure.ai.projects`, `azure.ai.agents`)
5. OpenAI compatibility layer

## Authentication Pattern

```python
from azure.identity import DefaultAzureCredential

# For local development (Cloud Shell, VS Code)
credential = DefaultAzureCredential(
    exclude_environment_credential=True,
    exclude_managed_identity_credential=True
)
```

## Client Lifecycle

Always use context managers for SDK clients:
```python
with (
    DefaultAzureCredential(...) as credential,
    AIProjectClient(endpoint=endpoint, credential=credential) as project_client,
    project_client.get_openai_client() as openai_client
):
    # All agent operations here
```

## Cleanup Pattern

Always clean up at the end:
```python
# Delete conversation
openai_client.conversations.delete(conversation_id=conversation.id)

# Delete agent
project_client.agents.delete(agent_name=agent.name, agent_version=agent.version)
```

## Error Handling

Check response status after agent runs:
```python
if response.status == "failed":
    print(f"Response failed: {response.error}")
```

## Environment Variables

Load from `.env` with defaults:
```python
load_dotenv()
project_endpoint = os.getenv("PROJECT_ENDPOINT")
model_deployment = os.getenv("MODEL_DEPLOYMENT_NAME", "gpt-4.1")
```
