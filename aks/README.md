## Provision AKS cluster(s) Using Terraform & Install Ondat

- [Provision AKS cluster(s) Using Terraform & Install Ondat](#provision-aks-clusters-using-terraform--install-ondat)
  - [What is this?](#what-is-this)
  - [Resource Requirements](#resource-requirements)
  - [Dependencies](#dependencies)
  - [Supported Node Image Operating Systems](#supported-node-image-operating-systems)
  - [Environment Setup](#environment-setup)
    - [Step 1 - `az` Configuration](#step-1---az-configuration)
    - [Step 2 - `terraform` Configuration](#step-2---terraform-configuration)
    - [Step 3 - `kubectl`, `kubectl-storageos` & `storageos` Configuration](#step-3---kubectl-kubectl-storageos--storageos-configuration)
  - [Quick-start & Usage](#quick-start--usage)
  - [Using Ondat](#using-ondat)
  - [Acknowledgements](#acknowledgements)


### What is this?

* A demonstration project that uses Terraform to provision Azure Kubernetes Service [AKS] cluster(s) and installs [Ondat](https://www.ondat.io/) - a software-defined, cloud native storage platform for Kubernetes.
  * The goal of this project is to automate the process of creating, managing and destroying a AKS cluster with `terraform`. During the creation of a cluster, Ondat is installed using the [`kubectl-storageos`](https://github.com/storageos/kubectl-storageos) plugin.  

### Resource Requirements

* For information on resource requirements required to run Ondat, refer to the [official Ondat prerequisites documentation](https://docs.ondat.io/docs/prerequisites/).

### Dependencies

* Required utilities to ensure that deployments are executed successfully.
  * `terraform` , `az` , `kubectl` , `kubectl-storageos`

### Supported Node Image Operating Systems

* Tested on;
  * `Ubuntu`

### Environment Setup

#### Step 1 - `az` Configuration

* Ensure that the [`az`](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) CLI is installed on your local machine and is in your path. 
* Authorise the `az` CLI to access Microsoft Azure using your user account.
  * [`az login`](https://cloud.google.com/sdk/gcloud/reference/auth/login)

#### Step 2 - `terraform` Configuration

* Ensure that the [`terraform`](https://learn.hashicorp.com/tutorials/terraform/install-cli) CLI is installed on your local machine and is in your path.
* [Apple M1](https://en.wikipedia.org/wiki/Apple_M1) users may get the following error message when they run `terraform init` on their machine.

```
 Error: Incompatible provider version
│
│ Provider registry.terraform.io/hashicorp/template v2.2.0 does not have a package available for your current platform, darwin_arm64.
│
│ Provider releases are separate from Terraform CLI releases, so not all providers are available for all platforms. Other versions of this provider may have different platforms supported.
╵
```

* This is due to the [`hashicorp/template` provider](https://github.com/hashicorp/terraform/issues/27257#issuecomment-825102330) being [deprecated](https://registry.terraform.io/providers/hashicorp/template/latest/docs#deprecation), but some providers still depend on it. To address this issue, apply the following workaround solution.

```bash
# clone the template provider repository.
$ git clone git@github.com:hashicorp/terraform-provider-template.git

# navigate into the directory.
$ cd terraform-provider-template/

# build the template provider from source (requires Golang to be installed).
$ go build

# make the generated binary executable.
$ chmod -v +x terraform-provider-template

# create the following directory and move the binary into `darwin_arm64/`.
$ mkdir -v ~/.terraform.d/plugins/registry.terraform.io/hashicorp/template/2.2.0/darwin_arm64/
$ mv -v terraform-provider-template ~/.terraform.d/plugins/registry.terraform.io/hashicorp/template/2.2.0/darwin_arm64/

# go back to the `terraform-gke-ondat-demo/` directory containing 
# the configuration files and initialise again.
$ terraform init
```

#### Step 3 - `kubectl`, `kubectl-storageos` & `storageos` Configuration

* Ensure that the [`kubectl`](https://kubernetes.io/docs/tasks/tools/#kubectl) CLI is installed on your local machine and is in your path.
* Ensure that the [`kubectl-storageos`](https://github.com/storageos/kubectl-storageos/releases) plugin CLI is installed on your local machine and is in your path.
* Ensure that the [`storageos`](https://github.com/storageos/go-cli/releases/) CLI is installed on your local machine and is in your path.

### Quick-start & Usage


```bash
# clone the repository.
$ git clone git@github.com:hubvu/terraform-kubernetes-ondat-demo.git

# navigate into the `aks/` directory.
$ cd terraform-kubernetes-ondat-demo/aks/

# make a note of your Subscription ID.
$ az account list | grep "id"

# create a Contributor Service Principal for Terraform and
# make a note of the following key value pairs;
# `appId`, `password` and `tenant`
$ az ad sp create-for-rbac \
  --role="Contributor" \
  --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"

# set the required Azure environment variables with the values noted earlier. 
$ export ARM_CLIENT_ID="YOUR_APP_ID"
$ export ARM_SUBSCRIPTION_ID="YOUR_SUBSCRIPTION_ID"
$ export ARM_TENANT_ID="YOUR_TENANT_ID"
$ export ARM_CLIENT_SECRET="YOUR_PASSWORD"

# initialise the working directory containing the configuration files.
$ terraform init

# validate the configuration files in the working directory.
$ terraform validate

# create an execution plan first.
$ terraform plan

# execute the actions proposed in a plan and enter your PROJECT_ID.
$ terraform apply

# after the cluster has been provisioned, inspect the pods with 
# kubectl and the generated kubeconfig file.
$ export KUBECONFIG="${PWD}/kubeconfig"

# or use `az` to get the cluster credentials automatically added 
# to your `$HOME/.kube/config`.
$ az aks get-credentials --resource-group aksOndatDemoResourceGroup --name terraform-aks-cluster-ondat-demo

$ kubectl get pods --all-namespaces

# destroy the environment created with terraform once you 
# are finished testing out AKS & Ondat.
$ terraform destroy
```

### Using Ondat

* Review the [Ondat Demo README.md](./../ondat/README.md) for an overview of Ondat and its usage. 

### Acknowledgements

* [Provisioning Kubernetes clusters on Azure with Terraform and AKE - learnk8s](https://learnk8s.io/terraform-aks).
* [Create a Kubernetes cluster with Azure Kubernetes Service using Terraform - Azure](https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks)
* [Provision an AKS Cluster (Azure) - Terraform](https://learn.hashicorp.com/tutorials/terraform/aks).
  * [Azure Provider - Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs).
  * [`azurerm_resource_group` Resource - Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group).
  * [`azurerm_kubernetes_cluster` Resource - Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster).
* [`local_file` Resource - Terraform](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file).
* [`local-exec` Provisioner - Terraform](https://www.terraform.io/docs/language/resources/provisioners/local-exec.html).
* [darwin/arm64 build #27257 - GitHub Issues](https://github.com/hashicorp/terraform/issues/27257).