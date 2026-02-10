#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Teardown shared Azure AI Foundry environment
.DESCRIPTION
    Deletes the shared Foundry project and all associated resources.
    Use this ONLY when completely done with ALL labs.
.PARAMETER Force
    Skip confirmation prompts
.PARAMETER DeleteResourceGroup
    Delete the entire resource group (default: true)
.EXAMPLE
    ./teardown-shared-environment.ps1
.EXAMPLE
    ./teardown-shared-environment.ps1 -Force
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$DeleteResourceGroup = $true
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Shared Lab Environment Teardown" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if lab state exists
$statePath = Join-Path $PSScriptRoot ".labstate.shared"
if (-not (Test-Path $statePath)) {
    Write-Host "⚠ No shared environment state file found (.labstate.shared)" -ForegroundColor Yellow
    Write-Host "Cannot determine which resources to delete." -ForegroundColor Yellow
    Write-Host ""
    $manualRg = Read-Host "Enter resource group name to delete (or press Enter to cancel)"
    if (-not $manualRg) {
        Write-Host "Teardown cancelled." -ForegroundColor Gray
        exit 0
    }
    $labState = @{ resourceGroup = $manualRg }
} else {
    # Load lab state
    Write-Host "Loading environment state..." -ForegroundColor Yellow
    $labState = Get-Content $statePath -Raw | ConvertFrom-Json
    Write-Host "✓ Environment state loaded" -ForegroundColor Green
    Write-Host ""
}

# Display resources to be deleted
Write-Host "========================================" -ForegroundColor Red
Write-Host "WARNING: This will delete your SHARED environment!" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""
Write-Host "The following resources will be deleted:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Resource Group: $($labState.resourceGroup)" -ForegroundColor Red
if ($labState.hubName) {
    Write-Host "  - AI Foundry Hub: $($labState.hubName)" -ForegroundColor Red
}
if ($labState.projectEndpoint) {
    Write-Host "  - Project Endpoint: $($labState.projectEndpoint)" -ForegroundColor Red
}
if ($labState.modelDeployments) {
    Write-Host "  - Model Deployments: $($labState.modelDeployments -join ', ')" -ForegroundColor Red
}
Write-Host ""
Write-Host "⚠ This affects ALL labs using this shared environment!" -ForegroundColor Yellow
Write-Host ""

# Confirmation
if (-not $Force) {
    Write-Host "Are you sure you want to delete the shared environment?" -ForegroundColor Yellow
    Write-Host "This cannot be undone." -ForegroundColor Red
    Write-Host ""
    $confirmation = Read-Host "Type 'DELETE SHARED ENVIRONMENT' to confirm"
    if ($confirmation -ne "DELETE SHARED ENVIRONMENT") {
        Write-Host "Teardown cancelled." -ForegroundColor Gray
        exit 0
    }
}

# Check Azure CLI
try {
    az version --query '\"azure-cli\"' -o tsv 2>$null | Out-Null
} catch {
    Write-Error "Azure CLI not found"
    exit 1
}

# Check if logged in
$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Host "Not logged into Azure. Running 'az login'..." -ForegroundColor Yellow
    az login
}

# Set subscription if stored in state
if ($labState.subscriptionId) {
    Write-Host "Setting subscription..." -ForegroundColor Yellow
    az account set --subscription $labState.subscriptionId
}
Write-Host ""

# Check for dependent labs
Write-Host "Checking for lab-specific resources..." -ForegroundColor Yellow
Write-Host "(Lab 09 may have additional Search/Storage resources)" -ForegroundColor Gray
Write-Host ""

if ($DeleteResourceGroup) {
    # Delete entire resource group
    Write-Host "Deleting resource group: $($labState.resourceGroup)..." -ForegroundColor Yellow
    Write-Host "(This may take 5-10 minutes)" -ForegroundColor Gray
    
    $rgExists = az group exists --name $labState.resourceGroup
    if ($rgExists -eq "true") {
        az group delete `
            --name $labState.resourceGroup `
            --yes `
            --no-wait `
            --output none
        
        Write-Host "✓ Resource group deletion initiated" -ForegroundColor Green
        Write-Host "  (Deletion will continue in the background)" -ForegroundColor Gray
    } else {
        Write-Host "✓ Resource group does not exist (already deleted)" -ForegroundColor Green
    }
} else {
    # Delete only the hub
    Write-Host "Deleting AI Foundry hub: $($labState.hubName)..." -ForegroundColor Yellow
    try {
        az ml workspace delete `
            --name $labState.hubName `
            --resource-group $labState.resourceGroup `
            --yes `
            --no-wait `
            --output none 2>$null
        Write-Host "✓ Hub deletion initiated" -ForegroundColor Green
    } catch {
        Write-Host "⚠ Hub not found or already deleted" -ForegroundColor Yellow
    }
}
Write-Host ""

# Clean up local files
Write-Host "Cleaning up local files..." -ForegroundColor Yellow

# Remove .labstate.shared
if (Test-Path $statePath) {
    Remove-Item $statePath -Force
    Write-Host "✓ Removed .labstate.shared" -ForegroundColor Green
}

# Remove .env.shared
$envPath = Join-Path $PSScriptRoot ".env.shared"
if (Test-Path $envPath) {
    if ($Force) {
        Remove-Item $envPath -Force
        Write-Host "✓ Removed .env.shared" -ForegroundColor Green
    } else {
        $removeEnv = Read-Host "Remove .env.shared file? (yes/no) [default: yes]"
        if ($removeEnv -eq "" -or $removeEnv -eq "yes") {
            Remove-Item $envPath -Force
            Write-Host "✓ Removed .env.shared" -ForegroundColor Green
        } else {
            Write-Host "✓ Kept .env.shared" -ForegroundColor Green
        }
    }
}
Write-Host ""

# Reminder about lab-specific environments
Write-Host "Note: If you used lab-specific setup scripts (not shared)," -ForegroundColor Yellow
Write-Host "      you need to run teardown.ps1 in those lab folders separately." -ForegroundColor Yellow
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Green
Write-Host "Teardown Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "✓ Shared environment deletion initiated" -ForegroundColor Green
Write-Host "✓ Local configuration files cleaned up" -ForegroundColor Green
Write-Host ""
Write-Host "Resource deletion is asynchronous and may take" -ForegroundColor Gray
Write-Host "5-10 minutes to complete in the background." -ForegroundColor Gray
Write-Host ""
Write-Host "To verify deletion:" -ForegroundColor Yellow
Write-Host "  az group show --name $($labState.resourceGroup)" -ForegroundColor Gray
Write-Host ""
Write-Host "To recreate the shared environment:" -ForegroundColor Yellow
Write-Host "  ./setup-shared-environment.ps1" -ForegroundColor Gray
Write-Host ""
