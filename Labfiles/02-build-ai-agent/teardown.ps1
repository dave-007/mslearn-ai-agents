#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Teardown script for Lab 02 - Build AI Agent
.DESCRIPTION
    Deletes all Azure resources created by setup.ps1:
    - Resource group (includes all contained resources)
    - Cleans up local state files
.PARAMETER Force
    Skip confirmation prompts
.EXAMPLE
    ./teardown.ps1
.EXAMPLE
    ./teardown.ps1 -Force
#>

[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Lab 02: Build AI Agent - Teardown Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if lab state exists
$statePath = Join-Path $PSScriptRoot ".labstate"
if (-not (Test-Path $statePath)) {
    Write-Host "⚠ No lab state file found (.labstate)" -ForegroundColor Yellow
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
    Write-Host "Loading lab state..." -ForegroundColor Yellow
    $labState = Get-Content $statePath -Raw | ConvertFrom-Json
    Write-Host "✓ Lab state loaded" -ForegroundColor Green
    Write-Host ""
}

# Display resources to be deleted
Write-Host "The following resources will be deleted:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Resource Group: $($labState.resourceGroup)" -ForegroundColor Red
if ($labState.hubName) {
    Write-Host "  - AI Foundry Hub: $($labState.hubName)" -ForegroundColor Red
}
if ($labState.modelDeployments) {
    Write-Host "  - Model Deployments: $($labState.modelDeployments -join ', ')" -ForegroundColor Red
}
Write-Host ""

# Confirmation
if (-not $Force) {
    $confirmation = Read-Host "Are you sure you want to delete these resources? (yes/no)"
    if ($confirmation -ne "yes") {
        Write-Host "Teardown cancelled." -ForegroundColor Gray
        exit 0
    }
}

# Check Azure CLI
try {
    az version --query '\"azure-cli\"' -o tsv 2>$null | Out-Null
} catch {
    Write-Error "Azure CLI not found. Please install: https://docs.microsoft.com/cli/azure/install-azure-cli"
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
    Write-Host "Setting subscription to: $($labState.subscriptionId)" -ForegroundColor Yellow
    az account set --subscription $labState.subscriptionId
}
Write-Host ""

# Delete resource group
Write-Host "Deleting resource group: $($labState.resourceGroup)..." -ForegroundColor Yellow
Write-Host "(This may take 5-10 minutes)" -ForegroundColor Gray

try {
    # Check if resource group exists
    $rgExists = az group exists --name $labState.resourceGroup
    
    if ($rgExists -eq "true") {
        # Delete resource group (this will delete all contained resources)
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
} catch {
    Write-Error "Failed to delete resource group: $_"
    exit 1
}
Write-Host ""

# Clean up local files
Write-Host "Cleaning up local files..." -ForegroundColor Yellow

# Remove .labstate
if (Test-Path $statePath) {
    Remove-Item $statePath -Force
    Write-Host "✓ Removed .labstate" -ForegroundColor Green
}

# Remove .env (optional - keep if user wants to reference it)
$envPath = Join-Path $PSScriptRoot "Python" ".env"
if (Test-Path $envPath) {
    $removeEnv = Read-Host "Remove Python/.env file? (yes/no) [default: yes]"
    if ($removeEnv -eq "" -or $removeEnv -eq "yes") {
        Remove-Item $envPath -Force
        Write-Host "✓ Removed Python/.env" -ForegroundColor Green
    } else {
        Write-Host "✓ Kept Python/.env" -ForegroundColor Green
    }
}
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Green
Write-Host "Teardown Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "✓ Resource group deletion initiated" -ForegroundColor Green
Write-Host "✓ Local files cleaned up" -ForegroundColor Green
Write-Host ""
Write-Host "Note: Resource deletion is asynchronous and may take" -ForegroundColor Gray
Write-Host "      5-10 minutes to complete in the background." -ForegroundColor Gray
Write-Host ""
Write-Host "To verify deletion:" -ForegroundColor Yellow
Write-Host "  az group show --name $($labState.resourceGroup)" -ForegroundColor Gray
Write-Host ""
