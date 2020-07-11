#!/bin/bash
echo 'Running Script'

# Set Variables
RESOURCE_GROUP=core
REGION=westus2

VNET_NAME=core-vnet
VNET_ADDRESS=10.0.0.0/16
VM_SUBNET=vm-subnet
VM_SUBNET_ADDRESS=10.0.0.0/24
ACR_SUBNET=acr-subnet
ACR_SUBNET_ADDRESS=10.0.1.0/24
KV_SUBNET=kv-subnet
KV_SUBNET_ADDRESS=10.0.2.0/24
ACI_SUBNET=aci-subnet
ACI_SUBNET_ADDRESS=10.0.3.0/24
AZURE_BASTION_SUBNET_ADDRESS=10.0.4.0/24
NSG_NAME=core-nsg

VM_NAME=core-vm
# ACR_NAME must be globally unique
ACR_NAME=coreacrchizer
BASTION_NAME=core-bastion

# Create Resource Group
az group create -g $RESOURCE_GROUP -l $REGION

# Create Network Security Group
az network nsg create -g $RESOURCE_GROUP -n $NSG_NAME

# Create VNet and needed subnets
az network vnet create -g $RESOURCE_GROUP -n $VNET_NAME --address-prefix $VNET_ADDRESS --subnet-name $VM_SUBNET --subnet-prefix $VM_SUBNET_ADDRESS --nsg $NSG_NAME
az network vnet subnet create -g $RESOURCE_GROUP --vnet-name $VNET_NAME -n $ACR_SUBNET --address-prefixes $ACR_SUBNET_ADDRESS --nsg $NSG_NAME
az network vnet subnet create -g $RESOURCE_GROUP --vnet-name $VNET_NAME -n $KV_SUBNET --address-prefixes $KV_SUBNET_ADDRESS --nsg $NSG_NAME
az network vnet subnet create -g $RESOURCE_GROUP --vnet-name $VNET_NAME -n $ACI_SUBNET --address-prefixes $ACI_SUBNET_ADDRESS --nsg $NSG_NAME
# The Azure Bastion subnet name must be "AzureBastionSubnet"
az network vnet subnet create -g $RESOURCE_GROUP --vnet-name $VNET_NAME -n AzureBastionSubnet --address-prefixes $AZURE_BASTION_SUBNET_ADDRESS

# Deploy a VM into the vmsubnet with no Public IP
az vm create -g $RESOURCE_GROUP -n $VM_NAME --image UbuntuLTS --size Standard_D2ds_v4 --authentication-type password --admin-username azureuser --admin-password Password123! --nsg $NSG_NAME --public-ip-address "" --vnet-name $VNET_NAME --subnet $VM_SUBNET

# Create an Azure Bastion Host. It knows to use the AzureBastionSubnet
az network public-ip create -g $RESOURCE_GROUP -n bastion-ip --sku Standard
az network bastion create -g $RESOURCE_GROUP -n $BASTION_NAME --vnet-name $VNET_NAME --public-ip-address bastion-ip

# Now we have a VNet with 5 subnets and 1 private VM. 
# Using the managed Azure Bastion service we are able to connect to the VM through the Azure portal.

#Create Private ACR
az acr create -g $RESOURCE_GROUP -n $ACR_NAME --sku Premium --default-action Deny --public-network-enabled true --admin-enabled false