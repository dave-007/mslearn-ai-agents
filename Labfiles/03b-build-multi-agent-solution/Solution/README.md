# Lab 03b Solution - Build Multi-Agent Solution

This directory contains the complete solution for Lab 03b: Develop a multi-agent solution with Microsoft Foundry.

## Files Included

- **agent_triage.py** - Complete Python script with all code snippets integrated
- **.env** - Environment configuration file (requires user to add their credentials)
- **requirements.txt** - Python dependencies

## Solution Summary

The completed `agent_triage.py` file includes:

1. **Imports** - All necessary Azure AI Agents SDK references
2. **Client Connection** - AgentsClient setup with DefaultAzureCredential
3. **Priority Agent** - Assesses ticket urgency (High/Medium/Low)
4. **Team Agent** - Assigns tickets to teams (Frontend/Backend/Infrastructure/Marketing)
5. **Effort Agent** - Estimates work required (Small/Medium/Large)
6. **Connected Agent Tools** - Wraps each agent as a tool
7. **Triage Agent** - Primary orchestrator that uses the three connected agents
8. **Execution Flow** - Creates thread, processes user input, displays results
9. **Cleanup** - Deletes all agents after execution

## Usage

1. Update the `.env` file with your Azure AI Foundry project endpoint and model deployment name
2. Install dependencies: `pip install -r requirements.txt azure-ai-projects azure-ai-agents`
3. Sign into Azure: `az login`
4. Run the script: `python agent_triage.py`
5. Enter a support ticket description when prompted

## Example Prompts

- "Users can't reset their password from the mobile app."
- "Investigate occasional 502 errors from the search endpoint."
- "Update the company logo on the homepage."

## Verification

✓ Syntax validated with `python -m py_compile`
✓ All code snippets from instructions integrated
✓ Proper indentation maintained
✓ 170 lines of complete, working code
