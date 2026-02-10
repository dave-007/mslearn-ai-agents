#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Setup script for Lab 09 - Integrate Agent with Foundry IQ
.DESCRIPTION
    Provisions Azure resources needed for Lab 09:
    - Foundry project
    - GPT-4.1 and text-embedding-3-small model deployments
    - AI Search service
    - Storage Account with blob container
    - Uploads sample product data
    - Generates .env configuration file
.PARAMETER SubscriptionId
    Azure subscription ID (uses current default if not specified)
.PARAMETER ResourceGroup
    Resource group name (default: rg-ai-agents-lab09)
.PARAMETER Location
    Azure region (default: eastus)
.PARAMETER ProjectName
    Foundry project name (default: lab09-foundry-iq)
.EXAMPLE
    ./setup.ps1
.EXAMPLE
    ./setup.ps1 -ResourceGroup "my-rg" -Location "westus"
#>

[CmdletBinding()]
param(
    [string]$SubscriptionId = "",
    [string]$ResourceGroup = "rg-ai-agents-lab09",
    [string]$Location = "eastus",
    [string]$ProjectName = "lab09-foundry-iq",
    [string]$SearchServiceName = "",
    [string]$StorageAccountName = ""
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Lab 09: Foundry IQ Integration - Setup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
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

Write-Host "✓ Using subscription: $($account.name)" -ForegroundColor Green
Write-Host ""

# Generate unique names if not provided
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$uniqueSuffix = $timestamp.Substring($timestamp.Length - 8)

if (-not $SearchServiceName) {
    $SearchServiceName = "srch-lab09-$uniqueSuffix".ToLower()
}
if (-not $StorageAccountName) {
    $StorageAccountName = "stlab09$uniqueSuffix".ToLower()
    # Ensure storage account name meets requirements (3-24 chars, alphanumeric)
    $StorageAccountName = $StorageAccountName.Substring(0, [Math]::Min(24, $StorageAccountName.Length))
}

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

# Create AI Search service
Write-Host "Creating AI Search service: $SearchServiceName..." -ForegroundColor Yellow
Write-Host "(This may take 2-3 minutes)" -ForegroundColor Gray

try {
    $search = az search service create `
        --name $SearchServiceName `
        --resource-group $ResourceGroup `
        --location $Location `
        --sku free `
        --output json 2>$null | ConvertFrom-Json
    
    if (-not $search) {
        # Try Basic SKU if Free is not available
        Write-Host "Free tier not available, trying Basic SKU..." -ForegroundColor Yellow
        $search = az search service create `
            --name $SearchServiceName `
            --resource-group $ResourceGroup `
            --location $Location `
            --sku basic `
            --output json | ConvertFrom-Json
    }
    
    Write-Host "✓ AI Search service created" -ForegroundColor Green
} catch {
    Write-Error "Failed to create AI Search service: $_"
    exit 1
}
Write-Host ""

# Create Storage Account
Write-Host "Creating Storage Account: $StorageAccountName..." -ForegroundColor Yellow

try {
    $storage = az storage account create `
        --name $StorageAccountName `
        --resource-group $ResourceGroup `
        --location $Location `
        --sku Standard_LRS `
        --kind StorageV2 `
        --output json | ConvertFrom-Json
    
    Write-Host "✓ Storage account created" -ForegroundColor Green
} catch {
    Write-Error "Failed to create storage account: $_"
    exit 1
}
Write-Host ""

# Get storage account key
Write-Host "Retrieving storage account key..." -ForegroundColor Yellow
$storageKey = az storage account keys list `
    --resource-group $ResourceGroup `
    --account-name $StorageAccountName `
    --query "[0].value" `
    --output tsv

Write-Host "✓ Storage key retrieved" -ForegroundColor Green
Write-Host ""

# Create blob container
Write-Host "Creating blob container: contosoproducts..." -ForegroundColor Yellow

az storage container create `
    --name "contosoproducts" `
    --account-name $StorageAccountName `
    --account-key $storageKey `
    --output none

Write-Host "✓ Blob container created" -ForegroundColor Green
Write-Host ""

# Upload sample data files
Write-Host "Uploading sample product data..." -ForegroundColor Yellow

$dataPath = Join-Path $PSScriptRoot "data"
if (Test-Path $dataPath) {
    $pdfFiles = Get-ChildItem -Path $dataPath -Filter "*.pdf"
    
    if ($pdfFiles.Count -eq 0) {
        Write-Host "⚠ No PDF files found in data/ folder" -ForegroundColor Yellow
        Write-Host "  Please download sample data from:" -ForegroundColor Gray
        Write-Host "  https://github.com/MicrosoftLearning/mslearn-ai-agents/raw/main/Labfiles/09-integrate-agent-with-foundry-iq/data/contoso-products.zip" -ForegroundColor Gray
    } else {
        foreach ($file in $pdfFiles) {
            Write-Host "  Uploading: $($file.Name)..." -ForegroundColor Gray
            az storage blob upload `
                --account-name $StorageAccountName `
                --account-key $storageKey `
                --container-name "contosoproducts" `
                --name $file.Name `
                --file $file.FullName `
                --output none
        }
        Write-Host "✓ $($pdfFiles.Count) files uploaded" -ForegroundColor Green
    }
} else {
    Write-Host "⚠ Data folder not found" -ForegroundColor Yellow
    Write-Host "  Creating data/ folder. Please add PDF files manually." -ForegroundColor Gray
    New-Item -ItemType Directory -Path $dataPath -Force | Out-Null
}
Write-Host ""

# Create AI Foundry hub/project
$hubName = "aihub-$ProjectName-$uniqueSuffix"
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

# Get AI Search admin key
Write-Host "Retrieving AI Search admin key..." -ForegroundColor Yellow
$searchKey = az search admin-key show `
    --resource-group $ResourceGroup `
    --service-name $SearchServiceName `
    --query "primaryKey" `
    --output tsv

Write-Host "✓ Search key retrieved" -ForegroundColor Green
Write-Host ""

# Generate .env file
Write-Host "Generating .env file..." -ForegroundColor Yellow

$envContent = @"
# Lab 09 Configuration - Generated by setup.ps1
# Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

PROJECT_ENDPOINT=$projectEndpoint
AGENT_NAME=product-expert-agent

# AI Search Configuration
SEARCH_SERVICE_NAME=$SearchServiceName
SEARCH_API_KEY=$searchKey
SEARCH_ENDPOINT=https://$SearchServiceName.search.windows.net

# Storage Configuration
STORAGE_ACCOUNT_NAME=$StorageAccountName
STORAGE_ACCOUNT_KEY=$storageKey
STORAGE_CONNECTION_STRING=DefaultEndpointsProtocol=https;AccountName=$StorageAccountName;AccountKey=$storageKey;EndpointSuffix=core.windows.net
CONTAINER_NAME=contosoproducts
"@

$envPath = Join-Path $PSScriptRoot "Python" ".env"
$envContent | Out-File -FilePath $envPath -Encoding utf8 -Force
Write-Host "✓ .env file created at: Python/.env" -ForegroundColor Green
Write-Host ""

# Save state for teardown
Write-Host "Saving lab state..." -ForegroundColor Yellow
$labState = @{
    subscriptionId = $account.id
    resourceGroup = $ResourceGroup
    location = $Location
    hubName = $hubName
    hubId = $hubId
    projectEndpoint = $projectEndpoint
    searchService = $SearchServiceName
    storageAccount = $StorageAccountName
    containerName = "contosoproducts"
    timestamp = (Get-Date).ToString("o")
} | ConvertTo-Json

$statePath = Join-Path $PSScriptRoot ".labstate"
$labState | Out-File -FilePath $statePath -Encoding utf8 -Force
Write-Host "✓ Lab state saved to: .labstate" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Resource Group:      $ResourceGroup" -ForegroundColor Cyan
Write-Host "Hub Name:            $hubName" -ForegroundColor Cyan
Write-Host "Project Endpoint:    $projectEndpoint" -ForegroundColor Cyan
Write-Host "AI Search Service:   $SearchServiceName" -ForegroundColor Cyan
Write-Host "Storage Account:     $StorageAccountName" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Open the Foundry portal: https://ai.azure.com" -ForegroundColor Gray
Write-Host "2. Create an agent named: product-expert-agent" -ForegroundColor Gray
Write-Host "3. Connect the agent to Foundry IQ using the search service" -ForegroundColor Gray
Write-Host "4. Create knowledge base from the storage container" -ForegroundColor Gray
Write-Host "5. Run the lab: cd Python && python agent_client.py" -ForegroundColor Gray
Write-Host ""
Write-Host "When finished, run: ./teardown.ps1" -ForegroundColor Yellow
Write-Host ""
