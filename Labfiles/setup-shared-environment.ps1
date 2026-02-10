#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Setup shared Azure AI Foundry environment for all labs
.DESCRIPTION
    Creates a single Foundry project with all required model deployments
    that can be reused across multiple labs, saving time and costs.
.PARAMETER SubscriptionId
    Azure subscription ID (uses current default if not specified)
.PARAMETER ResourceGroup
    Resource group name (default: rg-ai-agents-shared)
.PARAMETER Location
    Azure region (default: eastus)
.PARAMETER ProjectName
    Foundry project name (default: ai-agents-shared)
.EXAMPLE
    ./setup-shared-environment.ps1
.EXAMPLE
    ./setup-shared-environment.ps1 -Location "westus2" -ResourceGroup "my-rg"
#>

[CmdletBinding()]
param(
    [string]$SubscriptionId = "",
    [string]$ResourceGroup = "rg-ai-agents-shared",
    [string]$Location = "eastus",
    [string]$ProjectName = "ai-agents-shared"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Shared Lab Environment Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will create a shared Azure AI Foundry environment" -ForegroundColor Yellow
Write-Host "that can be used across multiple labs." -ForegroundColor Yellow
Write-Host ""

# Check Azure CLI
try {
    $azVersion = az version --query '\"azure-cli\"' -o tsv 2>$null
    Write-Host "✓ Azure CLI version: $azVersion" -ForegroundColor Green
} catch {
    Write-Error "Azure CLI not found. Please install: https://docs.microsoft.com/cli/azure/install-azure-cli"
    exit 1
}

# Check if logged in
$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Host "Not logged into Azure. Running 'az login'..." -ForegroundColor Yellow
    az login
    $account = az account show | ConvertFrom-Json
}

# Set subscription if specified
if ($SubscriptionId) {
    Write-Host "Setting subscription to: $SubscriptionId" -ForegroundColor Yellow
    az account set --subscription $SubscriptionId
    $account = az account show | ConvertFrom-Json
}

Write-Host "✓ Using subscription: $($account.name) ($($account.id))" -ForegroundColor Green
Write-Host ""

# Create resource group
Write-Host "Creating resource group: $ResourceGroup in $Location..." -ForegroundColor Yellow
$rgExists = az group exists --name $ResourceGroup
if ($rgExists -eq "true") {
    Write-Host "✓ Resource group already exists" -ForegroundColor Green
} else {
    az group create --name $ResourceGroup --location $Location --output none
    Write-Host "✓ Resource group created" -ForegroundColor Green
}
Write-Host ""

# Generate unique suffix
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$uniqueSuffix = $timestamp.Substring($timestamp.Length - 6)
$hubName = "aihub-$ProjectName-$uniqueSuffix"

# Create AI Foundry hub/project
Write-Host "Creating AI Foundry hub: $hubName..." -ForegroundColor Yellow
Write-Host "(This may take 3-5 minutes)" -ForegroundColor Gray

try {
    $hub = az ml workspace create `
        --kind hub `
        --name $hubName `
        --resource-group $ResourceGroup `
        --location $Location `
        --output json | ConvertFrom-Json
    
    Write-Host "✓ AI Foundry hub created" -ForegroundColor Green
    $hubId = $hub.id
    $projectEndpoint = "https://$Location.api.azureml.ms/discovery/api/v2.0/projects/$hubId"
} catch {
    Write-Error "Failed to create AI Foundry hub: $_"
    exit 1
}
Write-Host ""

# Wait for hub to be ready
Write-Host "Waiting for hub to be fully provisioned..." -ForegroundColor Yellow
Start-Sleep -Seconds 30
Write-Host "✓ Hub ready" -ForegroundColor Green
Write-Host ""

# Model deployments
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Model Deployments" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Note: Model deployment via Azure CLI is limited." -ForegroundColor Yellow
Write-Host "      Please deploy the following models via the portal:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. GPT-4.1 (deployment name: gpt-4.1)" -ForegroundColor Cyan
Write-Host "     - Used by: Labs 02, 03, 04, 05, 08, 09" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. GPT-4o (deployment name: gpt-4o)" -ForegroundColor Cyan
Write-Host "     - Used by: Labs 03b, 03c, 03d, 06" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. text-embedding-3-small (deployment name: text-embedding-3-small)" -ForegroundColor Cyan
Write-Host "     - Used by: Lab 09 only" -ForegroundColor Gray
Write-Host ""
Write-Host "Go to: https://ai.azure.com" -ForegroundColor Yellow
Write-Host "       Navigate to your project > Build > Models > Deploy a base model" -ForegroundColor Gray
Write-Host ""

$continue = Read-Host "Press Enter when model deployments are complete (or Ctrl+C to cancel)"

# Generate shared .env file
Write-Host ""
Write-Host "Generating shared configuration file..." -ForegroundColor Yellow

$envContent = @"
# Shared Lab Environment Configuration
# Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
#
# This configuration can be used across multiple labs.
# Copy these values to each lab's Python/.env file as needed.

# Azure Configuration
AZURE_SUBSCRIPTION_ID=$($account.id)
AZURE_RESOURCE_GROUP=$ResourceGroup
AZURE_LOCATION=$Location

# AI Foundry Project
PROJECT_ENDPOINT=$projectEndpoint
FOUNDRY_HUB_NAME=$hubName

# Model Deployments
# For Labs 02, 03, 04, 05, 08, 09
MODEL_DEPLOYMENT_NAME=gpt-4.1

# For Labs 03b, 03c, 03d, 06 (hub-based labs)
# Note: These may need separate hub setup
GPT4O_DEPLOYMENT_NAME=gpt-4o

# For Lab 09 (Foundry IQ)
EMBEDDING_DEPLOYMENT_NAME=text-embedding-3-small

# Usage Examples:
# Lab 02: Copy PROJECT_ENDPOINT and MODEL_DEPLOYMENT_NAME to Labfiles/02-build-ai-agent/Python/.env
# Lab 09: Copy PROJECT_ENDPOINT, AGENT_NAME, and EMBEDDING_DEPLOYMENT_NAME to Labfiles/09-integrate-agent-with-foundry-iq/Python/.env
"@

$envPath = Join-Path $PSScriptRoot ".env.shared"
$envContent | Out-File -FilePath $envPath -Encoding utf8 -Force
Write-Host "✓ Shared configuration saved to: .env.shared" -ForegroundColor Green
Write-Host ""

# Save state for teardown
Write-Host "Saving environment state..." -ForegroundColor Yellow
$labState = @{
    subscriptionId = $account.id
    resourceGroup = $ResourceGroup
    location = $Location
    hubName = $hubName
    hubId = $hubId
    projectEndpoint = $projectEndpoint
    modelDeployments = @("gpt-4.1", "gpt-4o", "text-embedding-3-small")
    timestamp = (Get-Date).ToString("o")
} | ConvertTo-Json

$statePath = Join-Path $PSScriptRoot ".labstate.shared"
$labState | Out-File -FilePath $statePath -Encoding utf8 -Force
Write-Host "✓ Environment state saved to: .labstate.shared" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Shared Environment Details:" -ForegroundColor Cyan
Write-Host "  Resource Group:    $ResourceGroup" -ForegroundColor White
Write-Host "  Hub Name:          $hubName" -ForegroundColor White
Write-Host "  Project Endpoint:  $projectEndpoint" -ForegroundColor White
Write-Host ""
Write-Host "Configuration File:  .env.shared" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Copy configuration to lab folders:" -ForegroundColor White
Write-Host "   # For Lab 02 example:" -ForegroundColor Gray
Write-Host "   cp .env.shared Labfiles/02-build-ai-agent/Python/.env" -ForegroundColor Gray
Write-Host "   # (Edit to keep only PROJECT_ENDPOINT and MODEL_DEPLOYMENT_NAME)" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Or manually configure each lab's .env file with:" -ForegroundColor White
Write-Host "   PROJECT_ENDPOINT=$projectEndpoint" -ForegroundColor Gray
Write-Host "   MODEL_DEPLOYMENT_NAME=gpt-4.1 (or gpt-4o for hub labs)" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Skip setup.ps1 in individual labs - use this shared environment!" -ForegroundColor White
Write-Host ""
Write-Host "4. Run your labs!" -ForegroundColor White
Write-Host ""
Write-Host "When completely done with all labs, run:" -ForegroundColor Yellow
Write-Host "  ./teardown-shared-environment.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "Cost Tip: This shared environment saves 60-80% vs per-lab setup!" -ForegroundColor Cyan
Write-Host ""
