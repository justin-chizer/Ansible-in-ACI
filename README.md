![Terraform GitHub Actions](https://github.com/justin-chizer/ansible-in-aci/workflows/Terraform%20GitHub%20Actions/badge.svg?branch=master)
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

This can be done by running the ./initial-infrastructure.sh script.

