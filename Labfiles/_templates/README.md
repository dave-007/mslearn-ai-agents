# Lab Automation Templates

This folder contains template scripts for creating setup/teardown automation for new labs.

## Usage

1. Copy `setup-template.ps1` and `teardown-template.ps1` to your lab folder
2. Rename them to `setup.ps1` and `teardown.ps1`
3. Customize the resource provisioning logic for your specific lab requirements
4. Test thoroughly before committing

## Template Customization Guide

### Setup Script Customization

1. **Update script header**
   - Change the `.SYNOPSIS` and `.DESCRIPTION` to match your lab
   - Update the example section

2. **Modify default parameters**
   ```powershell
   [string]$ResourceGroup = "rg-ai-agents-labXX",    # Change labXX
   [string]$ProjectName = "labXX-your-name",          # Change name
   ```

3. **Add lab-specific resources**
   - Copy resource creation blocks from examples (Lab 02, Lab 09)
   - AI Search: See Lab 09
   - Storage Account: See Lab 09
   - Additional services: Use `az <service> create` patterns

4. **Update .env generation**
   - Add all environment variables your lab needs
   - Match variable names to what's in the starter code

5. **Update lab state**
   - Track all resources that need cleanup
   - Include resource names and IDs

### Teardown Script Customization

1. **Update script header** (same as setup)

2. **Add resource deletion blocks**
   - For each resource created in setup, add a deletion block
   - Use `2>$null` to suppress "not found" errors gracefully

3. **Order of deletion**
   - Delete child resources before parents
   - Example: Delete deployments before workspace

## Example Resource Patterns

### AI Foundry Hub/Project
```powershell
$hub = az ml workspace create `
    --kind hub `
    --name $hubName `
    --resource-group $ResourceGroup `
    --location $Location `
    --output json | ConvertFrom-Json
```

### Model Deployment
```powershell
# Note: Model deployment typically requires AI Foundry SDK or portal
# Azure CLI support is limited for model deployments
# Consider documenting manual steps or using REST API
```

### AI Search Service
```powershell
$search = az search service create `
    --name $serviceName `
    --resource-group $ResourceGroup `
    --location $Location `
    --sku free `
    --output json | ConvertFrom-Json
```

### Storage Account
```powershell
$storage = az storage account create `
    --name $storageAccountName `
    --resource-group $ResourceGroup `
    --location $Location `
    --sku Standard_LRS `
    --kind StorageV2 `
    --output json | ConvertFrom-Json
```

### Blob Container
```powershell
az storage container create `
    --name $containerName `
    --account-name $storageAccountName `
    --account-key $storageKey `
    --output none
```

## Testing Checklist

Before committing your automation scripts, verify:

- [ ] Setup script runs successfully in a clean subscription
- [ ] All resources are created correctly
- [ ] .env file is generated with all required variables
- [ ] .labstate file contains all resource identifiers
- [ ] The lab exercises work using the auto-generated configuration
- [ ] Teardown script deletes all resources
- [ ] Teardown script handles missing resources gracefully
- [ ] No orphaned resources are left after teardown
- [ ] Scripts work in both PowerShell on Windows and Cloud Shell

## Common Issues and Solutions

### Issue: Model deployment not supported via CLI
**Solution:** Document manual steps or use Azure AI SDK/REST API

### Issue: Resource names must be globally unique
**Solution:** Use timestamp suffix or generate random strings

### Issue: Quota not available in default region
**Solution:** Add region fallback logic or document alternative regions

### Issue: Dependencies between resources
**Solution:** Add appropriate `Start-Sleep` delays or poll for resource status

## Support

For questions about automation templates, refer to:
- Lab 02 setup.ps1 - Simple example with project + model
- Lab 09 setup.ps1 - Complex example with multiple services
- `Labfiles/AUTOMATION_README.md` - General automation documentation
