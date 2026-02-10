# Lab Solutions Guide

This repository includes complete solution folders for each lab exercise. These solutions eliminate the need to paste code from instruction files, which can cause indentation errors and formatting issues.

## Purpose

Each lab module includes:
- **Python folder**: Partially written scripts with placeholder comments (for hands-on learning)
- **Solution folder**: Complete, ready-to-run scripts (for reference and troubleshooting)

## Available Solutions

### Lab 02: Build AI Agent
- **Location**: `Labfiles/02-build-ai-agent/Solution/`
- **Main File**: `agent.py`
- **Description**: Complete implementation of an AI agent using Azure AI Agent Service with Code Interpreter tool for data analysis

### Lab 03: AI Agent Functions
- **Location**: `Labfiles/03-ai-agent-functions/Solution/`
- **Main File**: `agent.py`
- **Description**: Technical support agent with custom function tools for ticket submission

### Lab 03b: Build Multi-Agent Solution
- **Location**: `Labfiles/03b-build-multi-agent-solution/Solution/`
- **Main File**: `agent_triage.py`
- **Description**: Multi-agent orchestration system with specialist agents for priority, team assignment, and effort estimation

### Lab 03c: Use Agent Tools with MCP
- **Location**: `Labfiles/03c-use-agent-tools-with-mcp/Solution/`
- **Main File**: `client.py`
- **Description**: MCP (Model Context Protocol) client that connects agents to external tools

### Lab 03d: Use Local MCP Server Tools
- **Location**: `Labfiles/03d-use-local-mcp-server-tools/Solution/`
- **Main Files**: `server.py`, `client.py`
- **Description**: Complete MCP server with inventory and sales tools, plus client implementation

### Lab 04: Agent Framework
- **Location**: `Labfiles/04-agent-framework/Solution/`
- **Main File**: `agent-framework.py`
- **Description**: Agent built using Microsoft Agent Framework SDK for expense claim processing

### Lab 05: Agent Orchestration
- **Location**: `Labfiles/05-agent-orchestration/Solution/`
- **Main File**: `agents.py`
- **Description**: Sequential multi-agent orchestration with summarizer, classifier, and action agents

### Lab 06: Build Remote Agents with A2A
- **Location**: `Labfiles/06-build-remote-agents-with-a2a/Solution/`
- **Main Files**: Multiple agent files in subdirectories
- **Description**: Complete A2A (Agent-to-Agent) protocol implementation with remote agent communication

### Lab 08: Build Workflow in Microsoft Foundry
- **Location**: `Labfiles/08-build-workflow-ms-foundry/Solution/`
- **Main File**: `workflow.py`
- **Description**: Workflow implementation using Microsoft Foundry's workflow API for ticket triage

### Lab 09: Integrate Agent with Foundry IQ
- **Location**: `Labfiles/09-integrate-agent-with-foundry-iq/Solution/`
- **Main File**: `agent_client.py`
- **Description**: Agent integrated with Foundry IQ knowledge base using MCP approval flow

## How to Use Solutions

### For Learning:
1. Start with the partial script in the **Python** folder
2. Follow the lab instructions to complete the exercise
3. If you encounter issues, refer to the **Solution** folder for the complete implementation

### For Quick Setup:
1. Navigate to the **Solution** folder for your lab
2. Copy the `.env.template` to `.env` (if present) or edit the `.env` file
3. Configure your Azure AI project endpoint and model deployment name
4. Install dependencies: `pip install -r requirements.txt`
5. Run the solution script

## Configuration

All solutions require an `.env` file with the following variables:
```
PROJECT_ENDPOINT=your_azure_ai_project_endpoint
MODEL_DEPLOYMENT_NAME=gpt-4.1
```

## Benefits of Using Solutions

✅ **No Copy-Paste Errors**: Eliminates indentation and formatting issues  
✅ **Proper Syntax**: All code is validated and properly formatted  
✅ **Complete Reference**: Full implementation with all required code  
✅ **Time Saving**: Skip debugging paste-related issues  
✅ **Learning Aid**: Compare your implementation with working code  

## Note

Lab 01 (Agent Fundamentals) does not include a Python implementation, so no solution folder is provided.

## Getting Help

If you encounter issues with any solution:
1. Verify your `.env` file is properly configured
2. Check that all dependencies are installed
3. Ensure you have sufficient Azure AI quota for model deployments
4. Review the lab instructions for any specific setup requirements

## Contributing

If you find issues with any solution or have improvements to suggest, please open an issue in the repository.
