# Azure Bicep Playbook

Reusable Azure infrastructure patterns implemented with Bicep.

The goal of this repository is to build a collection of modular, reusable, and configurable Azure infrastructure templates, from individual resources to complete infrastructure patterns.

## Modules

### Networking

| Module | Description |
|---|---|
| `networking/vnet` | Creates a configurable Virtual Network. |
| `networking/nsg` | Creates a Network Security Group with configurable HTTPS and optional SSH inbound rules. |
| `networking/vnet-subnets-nsg` | Creates a Virtual Network, application/data subnets, NSGs, and security rules. |
| `networking/private-dns` | Creates a Private DNS Zone and links it to an existing Virtual Network. |
| `networking/private-endpoint` | Creates a Private Endpoint and associates it with an existing Private DNS Zone. |

### Storage

| Module | Description |
|---|---|
| `storage/storage-account` | Creates a Storage Account with configurable redundancy, private networking defaults, Blob versioning, and soft delete. |

## Prerequisites

- An Azure subscription.
- Azure CLI installed.
- Bicep CLI support through Azure CLI.
- An authenticated Azure session.
- An existing resource group for each deployment.
- Appropriate permissions to create the target resources.

Authenticate with Azure:

```bash
az login --use-device-code
az account set --subscription "<subscription-id>"
```

## Validate templates

Compile the Bicep templates before deployment:

```bash
az bicep build --file networking/vnet/main.bicep
az bicep build --file networking/nsg/main.bicep
az bicep build --file networking/vnet-subnets-nsg/main.bicep
az bicep build --file networking/private-dns/main.bicep
az bicep build --file networking/private-endpoint/main.bicep
az bicep build --file storage/storage-account/main.bicep
```

## Networking: Virtual Network

Creates a Virtual Network with a configurable address space, location, and resource tags.

### Preview deployment


az deployment group what-if \
  --resource-group rg-network-lab \
  --template-file networking/vnet/main.bicep \
  --parameters networking/vnet/main.bicepparam


### Deploy

az deployment group create \
  --resource-group rg-network-lab \
  --name vnet-deployment \
  --template-file networking/vnet/main.bicep \
  --parameters networking/vnet/main.bicepparam


## Networking: Network Security Group

Creates a standalone NSG with configurable inbound HTTPS and optional SSH rules.

- HTTPS inbound is enabled by default.
- SSH inbound is disabled by default.
- SSH source addresses can be restricted through parameters.
- The NSG is not automatically associated with a subnet.

### Preview deployment

```bash
az deployment group what-if \
  --resource-group rg-network-lab \
  --template-file networking/nsg/main.bicep \
  --parameters networking/nsg/main.bicepparam
```

### Deploy

```bash
az deployment group create \
  --resource-group rg-network-lab \
  --name nsg-deployment \
  --template-file networking/nsg/main.bicep \
  --parameters networking/nsg/main.bicepparam
```

## Networking: VNet, Subnets and NSGs

Deploys:

- One Virtual Network.
- An application subnet and a data subnet.
- One NSG per subnet.
- An HTTPS inbound rule for the application NSG.
- A SQL inbound rule from the application subnet.
- An additional inbound deny rule for other traffic matching the `VirtualNetwork` service tag.

Default outbound NSG rules remain in place.

### Preview deployment

```bash
az deployment group what-if \
  --resource-group rg-network-lab \
  --template-file networking/vnet-subnets-nsg/main.bicep \
  --parameters networking/vnet-subnets-nsg/main.bicepparam
```

### Deploy

```bash
az deployment group create \
  --resource-group rg-network-lab \
  --name networking-baseline \
  --template-file networking/vnet-subnets-nsg/main.bicep \
  --parameters networking/vnet-subnets-nsg/main.bicepparam
```

## Networking: Private DNS

Creates a Private DNS Zone and links it to an existing Virtual Network.

The current example uses:

```text
privatelink.blob.core.windows.net
```

This zone supports private DNS resolution for Azure Blob Storage Private Endpoints.

The VNet link uses `registrationEnabled: false`, since automatic VM DNS registration is not required for this scenario.

The VNet must exist before deploying the link.

## Networking: Private Endpoint

Creates a Private Endpoint for an existing Azure resource and associates it with an existing Private DNS Zone through a DNS Zone Group.

The current example targets the Blob service of an Azure Storage Account:

- Target subresource: `blob`.
- Private Endpoint subnet: an existing subnet.
- Private DNS Zone: `privatelink.blob.core.windows.net`.
- DNS Zone Group: `default`.

The target resource, subnet, and Private DNS Zone must exist before deployment.

## Storage: Storage Account

Creates an Azure Storage Account with the following baseline:

- `StorageV2` account kind.
- Configurable redundancy: LRS, ZRS, GRS, or RA-GRS.
- Minimum TLS version of 1.2.
- HTTPS-only traffic.
- Blob public access disabled.
- Public network access disabled by default.
- Shared Key authentication disabled by default.
- Blob versioning enabled by default.
- Blob soft delete enabled by default.
- Container soft delete enabled.
- Configurable resource tags.

The Storage Account name must be globally unique and contain between 3 and 24 lowercase letters or numbers.

When public network access is disabled, clients need a suitable private connectivity path to reach the service. For the Blob Private Endpoint scenario, deploy the Private DNS Zone and Private Endpoint modules as well.

Disabling Shared Key authentication requires clients to use an appropriate Microsoft Entra ID authentication method and the necessary data-plane RBAC permissions.

## Private Storage Deployment Order

For a Storage Account accessible through a Private Endpoint, use this deployment sequence:

1. Create the resource group.
2. Deploy the Virtual Network and the required subnet.
3. Deploy the Storage Account.
4. Deploy the Private DNS Zone and link it to the VNet.
5. Deploy the Private Endpoint and its DNS Zone Group.
6. Configure and verify name resolution and private connectivity from the client network.

The VNet, subnet, Storage Account, and DNS resources can be deployed in separate modules, allowing each component to be reused independently.

## Design Notes

- Each module has its own `main.bicep`, `main.bicepparam`, and `README.md`.
- Resource names, locations, address ranges, and relevant settings are parameterized.
- Existing resources are referenced by resource ID when required.
- Outputs expose resource IDs and names for reuse in other deployments.
- Private Endpoints and Private DNS Zones are separate modules.
- The examples are learning baselines, not complete production architectures.
- Review network access, DNS resolution, RBAC permissions, redundancy, and recovery requirements before using these templates in production.
- Always run `what-if` before deploying changes.

## Cleanup

Delete the lab resource group only if it contains no resources you need:

```bash
az group delete \
  --name rg-network-lab \
  --yes \
  --no-wait
```

**Warning:** deleting a resource group permanently removes the resources it contains.

## Roadmap

- [ ] Reusable subnet module.
- [ ] Managed Identity and RBAC modules.
- [ ] Key Vault with RBAC.
- [ ] Linux VM with Managed Identity.
- [ ] Log Analytics and Diagnostic Settings.
- [ ] VNet Peering and Hub-and-Spoke networking.
- [ ] Azure App Service with Application Insights.
- [ ] Azure SQL with Private Endpoint.
- [ ] Modular three-tier application example.
