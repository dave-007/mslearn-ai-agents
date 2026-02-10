# Lab 03: AI Agent with Custom Functions - Solution

This directory contains the complete solution for Lab 03 (ai-agent-functions).

## Files Included

- **agent.py**: Complete Python implementation of a technical support agent that uses custom functions
- **requirements.txt**: Python dependencies required to run the agent
- **.env**: Environment configuration file (requires user to set PROJECT_ENDPOINT)

## What This Solution Implements

The completed agent.py file includes:

1. **Import statements**: All necessary Azure AI and OpenAI libraries
2. **Custom function**: `submit_support_ticket()` that creates support ticket files
3. **Azure connection**: Connection to AI Foundry project using DefaultAzureCredential
4. **Function tool definition**: FunctionTool schema for the support ticket function
5. **Agent creation**: Technical support agent with instructions and function tool
6. **Conversation handling**: Message exchange and response processing
7. **Function call execution**: Automatic handling of function calls from the agent
8. **Cleanup**: Proper resource disposal (conversation and agent deletion)

## How to Use

1. Edit the `.env` file and replace `your_project_endpoint` with your actual Azure AI Foundry project endpoint
2. Install dependencies: `pip install -r requirements.txt`
3. Sign into Azure: `az login`
4. Run the agent: `python agent.py`
5. Interact with the agent by describing technical issues

## Example Interaction

```
Enter a prompt (or type 'quit' to exit): I have a technical problem
Agent response: I'm sorry to hear that. Could you please provide your email address and describe the issue?

Enter a prompt (or type 'quit' to exit): alex@contoso.com - my computer won't start
Agent response: Support ticket 3a7b9f submitted. The ticket file is saved as ticket-3a7b9f.txt
```

The agent will create ticket files in the format `ticket-XXXXXX.txt` in the same directory.
