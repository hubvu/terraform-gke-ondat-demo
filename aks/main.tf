terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "aksOndatDemoResourceGroup"
  location = "northeurope"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                       = "terraform-aks-cluster-ondat-demo"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  dns_prefix                 = "terraformaksclusterondatdemo"
  private_cluster_enabled    = "false" 

  default_node_pool {
    name                     = "default"
    node_count               = "3"
    vm_size                  = "standard_d2_v2"
    availability_zones       = ["1", "2", "3"]
    type                     = "VirtualMachineScaleSets"
    os_disk_type             = "Managed"
    os_disk_size_gb          = 100
    os_sku                   = "Ubuntu"
    enable_auto_scaling      = "false"
    min_count                = null
    max_count                = null
    enable_host_encryption   = "false"
    enable_node_public_ip    = "false"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Demonstration"
  }
}

resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.cluster]
  filename     = "kubeconfig"
  content      = azurerm_kubernetes_cluster.cluster.kube_config_raw

  # install ondat
  provisioner "local-exec" {
    command = <<EOT
      export KUBECONFIG="./kubeconfig"

      kubectl storageos install --include-etcd \
        --admin-username 'admin' \
        --admin-password 'ADD_YOUR_STRONG_PASSWORD_HERE'

    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}