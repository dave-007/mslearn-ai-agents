# Lab Automation Quick Start

This guide will help you quickly set up and tear down Azure resources for any lab without using the portal.

## 🎯 Two Approaches

### ⭐ **Recommended: Shared Environment**

Create **one** Foundry project and reuse it across all compatible labs:

```powershell
# One-time setup (5-10 minutes)
cd Labfiles
./setup-shared-environment.ps1

# Configure each lab to use the shared project:
# Copy PROJECT_ENDPOINT from Labfiles/.env.shared 
# to each lab's Python/.env file

# Run your labs (skip individual setup.ps1)
cd 02-build-ai-agent/Python
python agent.py

# When completely done with ALL labs:
cd ../..
./teardown-shared-environment.ps1
```

**Benefits:**
- 💰 **60-80% cheaper** - One project vs many
- 🚀 **Much faster** - Setup once, use everywhere
- 🎯 **Cleaner** - Less resource sprawl

**Works for:** Labs 02, 03, 04, 05, 07, 08, 09*  
*Lab 09 needs additional resources but can use shared project

### Alternative: Per-Lab Environments

Each lab creates its own isolated environment:

```powershell
# Setup - Creates all Azure resources
cd Labfiles/02-build-ai-agent
./setup.ps1

# Run your lab exercises
cd Python
python agent.py

# Teardown - Deletes all Azure resources
cd ..
./teardown.ps1
```

**Use when:**
- You want complete lab isolation
- Testing lab automation scripts
- Only running 1-2 labs

## 🚀 Quick Commands

### For Labs with Automation (Lab 02, Lab 09)

```powershell
# Setup - Creates all Azure resources
cd Labfiles/02-build-ai-agent
./setup.ps1

# Run your lab exercises
cd Python
python agent.py

# Teardown - Deletes all Azure resources
cd ..
./teardown.ps1
```

### For Labs Without Automation Yet

1. See `Labfiles/_templates/` for starter scripts
2. Copy and customize for your lab
3. Or continue using the portal instructions in `Instructions/`

## 📋 What Automation Does

### Setup Script
- ✅ Creates Azure resource group
- ✅ Provisions AI Foundry project/hub
- ✅ Deploys required AI models
- ✅ Creates additional resources (Search, Storage, etc.)
- ✅ Generates `.env` file with all configurations
- ✅ Saves state in `.labstate` for cleanup

### Teardown Script
- ✅ Reads `.labstate` to identify resources
- ✅ Deletes all created Azure resources
- ✅ Cleans up local configuration files
- ✅ Prevents orphaned resources and unexpected costs

## 🎯 Benefits

- **No Portal Clicks** - Everything via command line
- **Reproducible** - Same setup every time
- **Fast** - Setup in 5-10 minutes vs 15-20 manually
- **Safe** - Guaranteed cleanup with teardown
- **Cost-Effective** - Easy to tear down when not in use

## 📊 Lab Status Matrix

| Lab | Setup | Teardown | Status |
|-----|-------|----------|--------|
| 01 - Agent Fundamentals | ⏳ | ⏳ | Portal only |
| **02 - Build AI Agent** | ✅ | ✅ | **Automated** |
| 03 - Agent Functions | ⏳ | ⏳ | Portal only |
| 03b - Multi-Agent | ⏳ | ⏳ | Portal only |
| 03c - MCP Remote | ⏳ | ⏳ | Portal only |
| 03d - MCP Local | ⏳ | ⏳ | Portal only |
| 04 - Agent Framework | ⏳ | ⏳ | Portal only |
| 05 - Orchestration | ⏳ | ⏳ | Portal only |
| 06 - A2A Protocol | ⏳ | ⏳ | Portal only |
| 07 - VS Code Extension | ⏳ | ⏳ | Portal only |
| 08 - Workflows | ⏳ | ⏳ | Portal only |
| **09 - Foundry IQ** | ✅ | ✅ | **Automated** |

✅ = Automated | ⏳ = Coming soon / Use portal

## 🔧 Customization Options

### Change Resource Names
```powershell
./setup.ps1 -ResourceGroup "my-lab-rg" -ProjectName "my-project"
```

### Use Different Region
```powershell
./setup.ps1 -Location "westus"
```

### Skip Confirmation Prompts
```powershell
./teardown.ps1 -Force
```

### Delete Entire Resource Group
```powershell
./teardown.ps1 -DeleteResourceGroup
```

## 🆘 Troubleshooting

### Quota Errors
```powershell
# Try a different region
./setup.ps1 -Location "westus2"
```

### Authentication Failed
```powershell
# Log in to Azure
az login

# Verify subscription
az account show
```

### Setup Failed Midway
```powershell
# Run teardown to clean up partial setup
./teardown.ps1

# Fix the issue and retry
./setup.ps1
```

### Can't Find .labstate
```powershell
# If .labstate is missing, delete resources manually
az group delete --name rg-ai-agents-labXX --yes
```

## 💡 Best Practices

1. **Always run teardown** when finished to avoid costs
2. **Use unique resource names** to avoid conflicts
3. **Save .labstate** while lab is in use (auto-created, don't delete)
4. **Don't commit .env or .labstate** to git (already gitignored)
5. **Test in a sandbox subscription** before production

## 🎓 Learn More

- Full documentation: `Labfiles/AUTOMATION_README.md`
- Template guide: `Labfiles/_templates/README.md`
- Example scripts: `Labfiles/02-build-ai-agent/` and `Labfiles/09-integrate-agent-with-foundry-iq/`

## 🤝 Contributing

Want to automate more labs? See `Labfiles/_templates/README.md` for:
- Template scripts you can copy
- Customization guide
- Testing checklist
- Common patterns

---

**Questions?** File an issue in this repository.
