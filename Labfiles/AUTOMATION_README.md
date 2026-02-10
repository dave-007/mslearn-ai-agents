# Lab Automation Scripts

This directory contains automated setup and teardown scripts for each lab, eliminating the need for manual Azure portal configuration.

## Overview

Each lab folder now includes:
- **`setup.ps1`** - PowerShell script to provision Azure resources
- **`setup.sh`** - Bash script to provision Azure resources (optional)
- **`teardown.ps1`** - PowerShell script to clean up resources
- **`teardown.sh`** - Bash script to clean up resources (optional)
- **`.labstate`** - Auto-generated state file tracking created resources

## Prerequisites

- Azure CLI installed and authenticated (`az login`)
- Appropriate Azure subscription permissions
- PowerShell 7+ (for .ps1 scripts) or Bash (for .sh scripts)
- Sufficient quota for required models in chosen region

## Quick Start

### Setup a Lab

```powershell
# Navigate to the lab folder
cd Labfiles/02-build-ai-agent

# Run setup (PowerShell)
./setup.ps1

# Or run setup (Bash)
./setup.sh
```

The setup script will:
1. Create Azure resource group
2. Create Foundry project/hub
3. Deploy required AI models
4. Create any additional resources (storage, search, etc.)
5. Generate `.env` file with all required values
6. Save resource IDs to `.labstate` for cleanup

### Teardown a Lab

```powershell
# From the same lab folder
./teardown.ps1

# Or
./teardown.sh
```

The teardown script will:
1. Read `.labstate` to identify resources
2. Delete all created Azure resources
3. Clean up local state files

## Common Parameters

All setup scripts support the following parameters:

```powershell
# PowerShell
./setup.ps1 `
    -SubscriptionId "your-subscription-id" `
    -ResourceGroup "rg-ai-agents-lab02" `
    -Location "eastus" `
    -ProjectName "lab02-project"

# Bash
./setup.sh \
    --subscription-id "your-subscription-id" \
    --resource-group "rg-ai-agents-lab02" \
    --location "eastus" \
    --project-name "lab02-project"
```

### Default Values

If not specified, scripts use defaults:
- **Subscription**: Current Azure CLI default
- **Resource Group**: `rg-ai-agents-{lab-name}`
- **Location**: `eastus` (or first available region with quota)
- **Project Name**: `{lab-name}-project`

## Lab-Specific Requirements

### Labs with New Foundry Experience (Projects)
- 01, 02, 03, 04, 05, 07, 08, 09

These create Foundry **projects** and deploy models directly.

### Labs with Classic Foundry Experience (Hubs)
- 03b, 03c, 03d, 06

These create Foundry **hubs** using the classic API.

### Labs with Additional Resources

**Lab 09** (Foundry IQ) also creates:
- AI Search service
- Storage Account
- Uploads sample data to blob storage
- Creates knowledge base

## State File Format

The `.labstate` file stores JSON with resource details:

```json
{
  "subscriptionId": "...",
  "resourceGroup": "...",
  "location": "...",
  "projectId": "...",
  "projectEndpoint": "...",
  "modelDeployments": ["gpt-4.1"],
  "additionalResources": {
    "searchService": "...",
    "storageAccount": "..."
  },
  "timestamp": "2026-02-10T10:30:00Z"
}
```

## Troubleshooting

### Quota Errors

If you encounter quota errors:

```powershell
# Try a different region
./setup.ps1 -Location "westus"
```

### Authentication Issues

```powershell
# Ensure you're logged in
az login

# Check current subscription
az account show

# Set subscription if needed
az account set --subscription "your-subscription-id"
```

### Cleanup Failed Resources

If teardown fails, manually delete the resource group:

```powershell
az group delete --name rg-ai-agents-lab02 --yes --no-wait
```

## Advanced Usage

### Skip Model Deployment

Some labs may want to reuse existing model deployments:

```powershell
./setup.ps1 -SkipModelDeployment -ExistingProjectEndpoint "https://..."
```

### Keep Resources After Lab

```powershell
# Run the lab code without calling teardown
# Resources remain for later use
```

### Batch Setup Multiple Labs

```powershell
# Setup all basic labs
$labs = @("02-build-ai-agent", "03-ai-agent-functions", "04-agent-framework")
foreach ($lab in $labs) {
    cd "Labfiles/$lab"
    ./setup.ps1
    cd ../..
}
```

## Contributing

When adding new labs, copy the template scripts from `Labfiles/_templates/` and modify:

1. **Resource requirements** - Add any lab-specific resources
2. **Model deployments** - Specify which models are needed
3. **Environment variables** - Update .env generation
4. **State tracking** - Ensure all resources are tracked for cleanup

## Security Notes

- `.env` files contain secrets and are gitignored
- `.labstate` files are gitignored
- Never commit credentials or connection strings
- Teardown scripts help prevent resource sprawl and unexpected costs

## Cost Management

Approximate costs per lab (USD per hour):
- Basic labs (02-05): ~$0.50-1.00/hr
- Multi-agent labs (03b, 06): ~$1.00-2.00/hr
- Foundry IQ lab (09): ~$2.00-3.00/hr (includes Search + Storage)

**Always run teardown when finished** to avoid unnecessary charges.

## Support

For issues with automation scripts:
1. Check the troubleshooting section above
2. Review Azure CLI output for specific errors
3. File an issue in this repository with:
   - Lab number
   - Error message
   - Contents of `.labstate` (redact subscription IDs)
