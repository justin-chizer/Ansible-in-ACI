![Actions Pipeline](https://github.com/justin-chizer/ansible-in-aci/workflows/CI/badge.svg)
# Goals
Running in GitHub Actions:

- Terraform will:
    - Create a new Resource Group.
    - Create a new VNet in the same Azure region as the hub.
    - Peer the VNet to the hub.
    - Create a VM in the spoke VM subnet.
    - Obtain the private IP of the new VM.
- Azure Container Instance will:
    - Run Ansible and connect to the VM using the IP, user name, and password.
    - Run the Ansible Playbook to configure the VM.

# Assumptions

We have the hub infrastructure already provisioned that contains:

- Resource Group
- VNet
- ACI subnet
- VM
- Azure Container Registry
- Azure Key Vault

This can be done by running the ./initial-infrastructure.sh script.


# Setup

There are two Service Principals that need to be made. The first is scoped to the Azure Key Vault and will have a scope of Reader. For example:
```
az ad sp create-for-rbac --scope /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/<NAME>/providers/Microsoft.KeyVault/vaults/<VaultName> --role Reader
```
This Service Principal is stored as a "secret" in GitHub.

TIP: Don't forget to give the Service Principal GET access on the "secrets"

The second Service Principal will be stored in Key Vault and will have a scope of Contributor. For example:
```
az ad sp create-for-rbac --scope /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx --role Contributor
```
This Service Principal will be used to create our resources.


