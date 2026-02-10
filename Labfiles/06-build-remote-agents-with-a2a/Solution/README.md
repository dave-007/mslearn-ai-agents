# Lab 06 Solution: Build Remote Agents with A2A Protocol

This directory contains the complete solution for Lab 06 - Connect to remote agents with A2A protocol.

## Solution Structure

```
Solution/
├── title_agent/
│   ├── agent.py              # Complete title agent implementation
│   ├── agent_executor.py     # Complete A2A executor for title agent
│   └── server.py            # Complete A2A server for title agent
├── outline_agent/
│   ├── agent.py              # Complete outline agent implementation
│   ├── agent_executor.py     # Complete A2A executor for outline agent
│   └── server.py            # Complete A2A server for outline agent
├── routing_agent/
│   ├── agent.py              # Complete routing agent implementation
│   └── server.py            # Complete server for routing agent
├── client.py                 # Client to interact with routing agent
├── run_all.py               # Script to launch all servers and client
├── .env                     # Environment configuration file
└── requirements.txt         # Python dependencies
```

## Key Components Completed

### Title Agent (title_agent/)
- **agent.py**: Creates an Azure AI Agent that generates catchy blog post titles
- **agent_executor.py**: Implements the AgentExecutor interface for A2A protocol compatibility
- **server.py**: Defines agent skills, creates agent card, and sets up A2A server

### Outline Agent (outline_agent/)
- **agent.py**: Creates an Azure AI Agent that generates blog post outlines (4-6 sections)
- **agent_executor.py**: Implements the AgentExecutor interface for A2A protocol compatibility
- **server.py**: Defines agent skills, creates agent card, and sets up A2A server

### Routing Agent (routing_agent/)
- **agent.py**: Orchestrates communication between user and remote agents
- **server.py**: FastAPI server that exposes the routing agent functionality

## Code Snippets Added

### Title Agent (agent.py)
1. Created AgentsClient with Azure credentials
2. Created the title agent with appropriate instructions
3. Created thread for chat session
4. Sent user message to the thread
5. Created and processed the agent run

### Title Agent (server.py)
1. Defined agent skills for title generation
2. Created agent card with metadata
3. Created agent executor
4. Created request handler
5. Created A2A application

### Title Agent (agent_executor.py)
1. Retrieved the title agent instance
2. Updated task status to "working"
3. Ran the agent conversation
4. Updated task with responses
5. Marked task as complete
6. Processed the request in execute method

### Routing Agent (agent.py)
1. Retrieved remote agent's A2A client
2. Constructed payload for remote agent
3. Wrapped payload in SendMessageRequest
4. Sent message and awaited response

## Usage

1. Configure the `.env` file with your Azure AI Foundry project endpoint
2. Install dependencies: `pip install -r requirements.txt azure-ai-projects azure-ai-agents a2a-sdk`
3. Sign into Azure: `az login`
4. Run the solution: `python run_all.py`
5. Enter prompts like: "Create a title and outline for an article about React programming"
6. Type `quit` to exit

## Features

- **A2A Protocol**: All agents are discoverable and communicate using the Agent-to-Agent protocol
- **Remote Communication**: Routing agent discovers and communicates with title and outline agents over HTTP
- **Task Management**: Agent executors manage task lifecycle (submit, working, complete)
- **Azure AI Integration**: Uses Azure AI Agent Service for LLM capabilities
- **Multi-Agent Orchestration**: Routing agent intelligently delegates tasks to specialized agents

## Notes

- The solution uses async/await patterns for efficient I/O operations
- All agents run as separate servers on different ports (10007, 10008, 10009)
- The routing agent uses function calling to interact with remote agents
- Error handling is implemented at multiple levels
