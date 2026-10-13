# Azure Resource Group Creation with Bicep

## Overview

This project uses Azure Bicep to create an Azure Resource Group at subscription scope and deploy resources into it.

### Project Structure

resource-group/
├── create-rg.bicep
├── main.bicep
├── main.bicepparam
└── README.md


## Prerequisites

- Azure CLI installed
- Bicep CLI available through Azure CLI
- Authenticated Azure account
- An active Azure subscription with the required permissions

Sign in to Azure:

az login

Check the current subscription:

az account show --output table

To select a different subscription:

az account set --subscription "<subscription-id>"


## 1. Build the Resource Group Template

Compile the Bicep template to check for syntax and compilation errors:

az bicep build --file resource-group/create-rg.bicep

## 2. Create the Resource Group

Deploy `create-rg.bicep` at subscription scope:

az deployment sub create --location northeurope --template-file resource-group/main.bicep --parameters resource-group/main.bicepparam

This creates the resource group defined by the `resourceGroupName` parameter in `create-rg.bicep`.

## 3. Verify the Resource Group

List resource groups in the current subscription:

az group list --output table

Check whether the specific resource group exists:

az group exists --name rg-bicep-lab

Expected output:

true


## 4. Deploy Resources into the Resource Group

Preview changes before deploying:

az deployment group what-if --resource-group rg-bicep-lab --template-file resource-group/main.bicep --parameters resource-group/main.bicepparam

After the resource group has been created, deploy the infrastructure defined in `main.bicep`:

az deployment group create --resource-group rg-bicep-lab --template-file resource-group/main.bicep --parameters resource-group/main.bicepparam

## 5. Verify Deployed Resources

List the resources inside the resource group:

az resource list --resource-group rg-bicep-lab --output table


## Deployment Workflow

1. Authenticate with Azure.
2. Build and validate the resource group template.
3. Create the resource group at subscription scope.
4. Verify that the resource group exists.
5. Preview and deploy infrastructure at resource-group scope.
6. Verify the deployed resources.

**Important:** `create-rg.bicep` uses `targetScope = 'subscription'` because resource groups are created at subscription scope. `main.bicep` uses `targetScope = 'resourceGroup'` because its resources are deployed inside an existing resource group.