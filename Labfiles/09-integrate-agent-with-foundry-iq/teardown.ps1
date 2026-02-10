#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Teardown script for Lab 09 - Integrate Agent with Foundry IQ
.DESCRIPTION
    Deletes all Azure resources created by setup.ps1:
    - AI Search service
    - Storage Account (with containers and data)
    - AI Foundry hub
    - Resource group (if empty or --DeleteResourceGroup specified)
    - Cleans up local state files
.PARAMETER Force
    Skip confirmation prompts
.PARAMETER DeleteResourceGroup
    Delete the entire resource group (default: false)
.EXAMPLE
    ./teardown.ps1
.EXAMPLE
    ./teardown.ps1 -Force -DeleteResourceGroup
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$DeleteResourceGroup
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Lab 09: Foundry IQ Integration - Teardown Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if lab state exists
$statePath = Join-Path $PSScriptRoot ".labstate"
if (-not (Test-Path $statePath)) {
    Write-Host "⚠ No lab state file found (.labstate)" -ForegroundColor Yellow
    Write-Host "Cannot determine which resources to delete." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Load lab state
Write-Host "Loading lab state..." -ForegroundColor Yellow
$labState = Get-Content $statePath -Raw | ConvertFrom-Json
Write-Host "✓ Lab state loaded" -ForegroundColor Green
Write-Host ""

# Display resources to be deleted
Write-Host "The following resources will be deleted:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Resource Group: $($labState.resourceGroup)" -ForegroundColor Red
Write-Host "  - AI Search Service: $($labState.searchService)" -ForegroundColor Red
Write-Host "  - Storage Account: $($labState.storageAccount)" -ForegroundColor Red
Write-Host "  - AI Foundry Hub: $($labState.hubName)" -ForegroundColor Red
if ($DeleteResourceGroup) {
    Write-Host "  - ALL OTHER RESOURCES IN RESOURCE GROUP" -ForegroundColor Red
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
    } else {
        Write-Host "✓ Resource group does not exist" -ForegroundColor Green
    }
} else {
    # Delete individual resources
    
    # Delete Storage Account
    Write-Host "Deleting Storage Account: $($labState.storageAccount)..." -ForegroundColor Yellow
    try {
        az storage account delete `
            --name $labState.storageAccount `
            --resource-group $labState.resourceGroup `
            --yes `
            --output none 2>$null
        Write-Host "✓ Storage account deleted" -ForegroundColor Green
    } catch {
        Write-Host "⚠ Storage account not found or already deleted" -ForegroundColor Yellow
    }
    
    # Delete AI Search Service
    Write-Host "Deleting AI Search service: $($labState.searchService)..." -ForegroundColor Yellow
    try {
        az search service delete `
            --name $labState.searchService `
            --resource-group $labState.resourceGroup `
            --yes `
            --output none 2>$null
        Write-Host "✓ AI Search service deleted" -ForegroundColor Green
    } catch {
        Write-Host "⚠ AI Search service not found or already deleted" -ForegroundColor Yellow
    }
    
    # Delete AI Foundry Hub
    Write-Host "Deleting AI Foundry hub: $($labState.hubName)..." -ForegroundColor Yellow
    try {
        az ml workspace delete `
            --name $labState.hubName `
            --resource-group $labState.resourceGroup `
            --yes `
            --no-wait `
            --output none 2>$null
        Write-Host "✓ AI Foundry hub deletion initiated" -ForegroundColor Green
    } catch {
        Write-Host "⚠ AI Foundry hub not found or already deleted" -ForegroundColor Yellow
    }
}
Write-Host ""

# Clean up local files
Write-Host "Cleaning up local files..." -ForegroundColor Yellow

if (Test-Path $statePath) {
    Remove-Item $statePath -Force
    Write-Host "✓ Removed .labstate" -ForegroundColor Green
}

$envPath = Join-Path $PSScriptRoot "Python" ".env"
if (Test-Path $envPath) {
    if ($Force) {
        Remove-Item $envPath -Force
        Write-Host "✓ Removed Python/.env" -ForegroundColor Green
    } else {
        $removeEnv = Read-Host "Remove Python/.env file? (yes/no) [default: yes]"
        if ($removeEnv -eq "" -or $removeEnv -eq "yes") {
            Remove-Item $envPath -Force
            Write-Host "✓ Removed Python/.env" -ForegroundColor Green
        }
    }
}
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Green
Write-Host "Teardown Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "✓ Resources deleted or deletion initiated" -ForegroundColor Green
Write-Host "✓ Local files cleaned up" -ForegroundColor Green
Write-Host ""
Write-Host "Note: Resource deletion may take 5-10 minutes" -ForegroundColor Gray
Write-Host "      to complete in the background." -ForegroundColor Gray
Write-Host ""
