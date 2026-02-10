# Lab Prerequisites and Shared Setup

This guide helps you create a **shared Azure AI Foundry environment** that can be used across multiple labs, saving time and reducing costs.

## 🎯 Two Approaches

### Option 1: Shared Environment (Recommended)
Create one Foundry project and reuse it across labs.
- ✅ **Faster** - Setup once, use for all labs
- ✅ **Cheaper** - One project, one set of model deployments
- ✅ **Cleaner** - Less resource sprawl
- ⚠️ Must manually clean up when completely done

### Option 2: Per-Lab Environments (Current Default)
Each lab creates its own project.
- ✅ **Isolated** - Labs don't affect each other
- ✅ **Clean** - Each lab's teardown is complete
- ❌ **Slower** - 5-10 min setup per lab
- ❌ **More expensive** - Multiple projects and deployments

---

## 🚀 Quick Start: Shared Environment Setup

### Prerequisites

- Azure subscription with sufficient permissions
- Azure CLI installed and updated
- PowerShell 7+ (or Bash)
- Sufficient quota for AI models in your region

### Option A: Automated Setup (Fastest)

```powershell
# Run the shared environment setup
cd Labfiles
./setup-shared-environment.ps1

# This creates:
# - One AI Foundry project
# - GPT-4.1 deployment (for most labs)
# - GPT-4o deployment (for multi-agent labs)
# - text-embedding-3-small (for Lab 09)
# - Saves credentials to .env.shared
```

### Option B: Manual Portal Setup

If you prefer using the Azure portal:

#### 1. Create Your Foundry Project

1. Navigate to [https://ai.azure.com](https://ai.azure.com)
2. Sign in with your Azure credentials
3. Toggle **New Foundry** to **On**
4. Click **Create a new project**
5. Configure:
   ```
   Project name: ai-agents-shared
   Resource group: rg-ai-agents-shared
   Location: eastus (or your preferred region)
   ```
6. Click **Create** and wait 3-5 minutes

#### 2. Deploy Required Models

Deploy these models for lab compatibility:

**GPT-4.1** (Labs 02, 03, 04, 05, 08, 09)
- Navigate to **Build** > **Models** > **Deploy a base model**
- Search for "gpt-4.1"
- Click **Deploy**
- Deployment name: `gpt-4.1`

**GPT-4o** (Labs 03b, 03c, 03d, 06)
- Repeat above steps
- Deployment name: `gpt-4o`

**text-embedding-3-small** (Lab 09 only)
- Search for "text-embedding-3-small"
- Click **Deploy**
- Deployment name: `text-embedding-3-small`

#### 3. Get Your Configuration

From the project **Overview** page, copy:
- **Project endpoint** - You'll use this in every lab

---

## 🔧 Configure Labs to Use Shared Environment

### For Labs with Automation Scripts

Edit the `.env` file in each lab's Python folder:

```bash
# Labfiles/02-build-ai-agent/Python/.env
PROJECT_ENDPOINT=https://eastus.api.azureml.ms/...  # Your shared project endpoint
MODEL_DEPLOYMENT_NAME=gpt-4.1
```

**Skip running setup.ps1** - you already have the shared environment!

### For Labs Without Automation

When following the lab instructions:
1. **Skip the "Create a Foundry project" section**
2. **Skip model deployment steps** (already done)
3. **Use your shared project endpoint** when configuring .env files

---

## 📋 Lab-Specific Requirements

### Labs Using Foundry Projects (New Experience)

These labs work with shared environment **as-is**:
- ✅ Lab 02 - Build AI Agent
- ✅ Lab 03 - Agent Functions
- ✅ Lab 04 - Agent Framework
- ✅ Lab 05 - Agent Orchestration
- ✅ Lab 07 - VS Code Extension
- ✅ Lab 08 - Build Workflow

### Labs Using Foundry Hubs (Classic Experience)

These need hub-based setup (different):
- ⚠️ Lab 03b - Multi-Agent Solution
- ⚠️ Lab 03c - MCP Remote Tools
- ⚠️ Lab 03d - MCP Local Tools
- ⚠️ Lab 06 - A2A Protocol

**For hub-based labs**: Create a separate shared hub or use per-lab setup.

### Labs with Additional Resources

**Lab 09 - Foundry IQ**
This lab needs extra resources even with shared project:
- AI Search service
- Storage Account
- Knowledge base data

Run Lab 09's setup script even if using shared project:
```powershell
cd Labfiles/09-integrate-agent-with-foundry-iq
./setup.ps1 -ExistingProjectEndpoint "your-shared-endpoint"
```

---

## 🔐 Authentication

### One-Time Azure Login

```powershell
# Login to Azure CLI
az login

# Set your default subscription
az account set --subscription "Your Subscription Name"

# Verify
az account show
```

This persists across terminal sessions. You won't need to login again unless:
- You switch subscriptions
- Your token expires (after ~90 days)
- You explicitly logout

### For Python Code

Labs use `DefaultAzureCredential` which automatically uses your Azure CLI login:

```python
from azure.identity import DefaultAzureCredential
credential = DefaultAzureCredential()
```

No additional authentication needed!

---

## 💰 Cost Comparison

### Shared Environment (9 labs)
- **1 Foundry project**: ~$0.50/hour
- **3 model deployments**: ~$1.50/hour
- **Total**: ~$2/hour active use
- **Estimated for all labs**: $15-20 total

### Per-Lab Environments (9 labs)
- **9 Foundry projects**: ~$4.50/hour each active
- **Duplicate deployments**: Additional costs
- **Total**: $50-100+ total (if not cleaned up well)

**Savings: 60-80% with shared environment**

---

## 🧹 Cleanup

### After Completing All Labs

```powershell
# Option 1: Use automated cleanup
cd Labfiles
./teardown-shared-environment.ps1

# Option 2: Delete via portal
# Navigate to Azure portal > Resource groups
# Delete: rg-ai-agents-shared
```

### Cleanup Per-Lab Resources (If not using shared)

```powershell
# From each lab folder
./teardown.ps1
```

---

## 🎓 Recommended Lab Sequence

### For Shared Environment Users

**Phase 1: Core Agent Development** (Use shared project)
1. Lab 02 - Build AI Agent
2. Lab 03 - Agent Functions
3. Lab 04 - Agent Framework
4. Lab 05 - Agent Orchestration

**Phase 2: Multi-Agent (Requires hub or separate setup)**
1. Lab 03b - Multi-Agent Solution
2. Lab 03c - MCP Remote
3. Lab 03d - MCP Local
4. Lab 06 - A2A Protocol

**Phase 3: Advanced Integration**
1. Lab 07 - VS Code Extension (use shared project)
2. Lab 08 - Build Workflow (use shared project)
3. Lab 09 - Foundry IQ (needs additional resources)

---

## ❓ FAQ

### Do I need a separate project for each lab?
**No.** One project works for Labs 02, 03, 04, 05, 07, 08. Labs 03b, 03c, 03d, 06 need hub-based setup.

### Can I use the free tier?
**Some services:**
- AI Foundry project: No free tier
- AI Search (Lab 09): Free tier available (1 per subscription)
- Storage (Lab 09): Very cheap (~$0.01/GB)

### What if I get quota errors?
```powershell
# Try a different region
./setup-shared-environment.ps1 -Location "westus2"
```

### Can I pause and resume later?
**Yes.** Your project persists. Just:
1. Stop when done with a session
2. Resume later - project and deployments remain
3. Only pay for active usage (charged by token)

### Should I delete after each lab session?
**Shared environment**: No, keep it across labs. Delete only when completely done.
**Per-lab environments**: Yes, delete after each lab to avoid costs.

---

## 🆘 Troubleshooting

### "Project endpoint not found"
- Verify you copied the full endpoint URL
- Check you're using the correct project (not hub) endpoint
- Format: `https://{region}.api.azureml.ms/...`

### "Model deployment not found"
- Verify model deployment name matches exactly (case-sensitive)
- Check model is deployed in your project (not someone else's)
- In portal: Navigate to project > Models > Deployments

### Authentication failures
```powershell
# Re-login to Azure
az login --use-device-code

# Clear credential cache
az account clear
az login
```

### Rate limit exceeded
- Wait a few minutes between requests
- Consider deploying additional model capacity
- Check quota limits in portal

---

## 📚 Additional Resources

- [Azure AI Foundry Documentation](https://learn.microsoft.com/azure/ai-studio/)
- [Model Deployment Guide](https://learn.microsoft.com/azure/ai-studio/how-to/deploy-models)
- [Cost Management](https://azure.microsoft.com/pricing/details/cognitive-services/)
- [Quota Management](https://learn.microsoft.com/azure/ai-studio/how-to/quota)

---

**Ready to start?** Choose your approach above and begin with Lab 02!
