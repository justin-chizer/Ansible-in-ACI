variable "resource_group" {
  type        = string
  description = "New RG for our infra"
}

variable "region" {
  type        = string
  description = "Should be same as Hub"
}

variable "worker-vnet" {
  type        = string
  description = "Name of new VNet"
}

variable "worker_subnet_name" {
  type        = string
  description = "vm subnet name"
}

variable "subscription_id" {
  description = "Azure Subscription ID to deploy to"
}

variable "client_id" {
  description = "Azure Client ID to deploy to"
}

variable "client_secret" {
  description = "Azure Client Secret to deploy to"
}

variable "tenant_id" {
  description = "Azure Tenant ID to deploy to"
}

variable "hub_resource_group" {
  type        = string
  description = "Name of the hub Resource Group"
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the hub vnet"
}

variable "worker_vm" {
  type        = string
  description = "(optional) describe your variable"
}