
# Azure Bicep Playbook

Reusable Azure infrastructure patterns implemented with Bicep.

## Modules

### Networking

| Module | Description |
|---|---|
| `networking/vnet-subnets-nsg` | Virtual Network, application/data subnets, NSGs and security rules |

## Prerequisites

- An Azure subscription
- Azure CLI
- Bicep CLI support through Azure CLI
- An authenticated Azure session

## Networking: VNet, Subnets and NSGs

Deploys:

- One Virtual Network
- An application subnet and a data subnet
- One Network Security Group per subnet
- HTTPS inbound rule for the application NSG
- SQL inbound rule from the application subnet
- An additional inbound deny rule for other traffic from the VirtualNetwork service tag

Default outbound NSG rules remain in place.

## Validate

```bash
az bicep build --file networking/vnet-subnets-nsg/main.bicep
```

## Preview deployment

```bash
az deployment group what-if \
  --resource-group rg-network-lab \
  --template-file networking/vnet-subnets-nsg/main.bicep \
  --parameters networking/vnet-subnets-nsg/main.bicepparam
```

## Deploy

```bash
az deployment group create \
  --resource-group rg-network-lab \
  --name networking-baseline \
  --template-file networking/vnet-subnets-nsg/main.bicep \
  --parameters networking/vnet-subnets-nsg/main.bicepparam
```

## Design notes

- Resource names and address ranges are configurable.
- Subnets are declared as child resources.
- NSGs are explicitly associated with their respective subnets.
- Security rules use priorities 100 and 200.
- This is a learning baseline, not a complete production network.
- No public IP, VM, NAT Gateway, firewall, or route table is created.
- Default outbound rules are not restricted by this module.

## Cleanup

Delete the lab resource group only if it contains no resources you need:

```bash
az group delete --name rg-network-lab --yes --no-wait
```
