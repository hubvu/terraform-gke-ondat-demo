## Provision GKE cluster(s) Using Terraform & Install Ondat

- [Provision GKE cluster(s) Using Terraform & Install Ondat](#provision-gke-clusters-using-terraform--install-ondat)
  - [What is this?](#what-is-this)
  - [Resource Requirements](#resource-requirements)
  - [Dependencies](#dependencies)
  - [Supported Node Image Operating Systems](#supported-node-image-operating-systems)
  - [Environment Setup](#environment-setup)
    - [Step 1 - `gcloud` Configuration](#step-1---gcloud-configuration)
    - [Step 2 - `terraform` Configuration](#step-2---terraform-configuration)
    - [Step 3 - `kubectl`, `kubectl-storageos` & `storageos` Configuration](#step-3---kubectl-kubectl-storageos--storageos-configuration)
  - [Quick-start & Usage](#quick-start--usage)
  - [Using Ondat](#using-ondat)
  - [Acknowledgements](#acknowledgements)

### What is this?

* A demonstration project that uses Terraform to provision Google Kubernetes Engine [GKE] cluster(s) and installs [Ondat](https://www.ondat.io/) - a software-defined, cloud native storage platform for Kubernetes.
  * The goal of this project is to automate the process of creating, managing and destroying a GKE cluster with `terraform`. During the creation of a cluster, Ondat is installed using the [`kubectl-storageos`](https://github.com/storageos/kubectl-storageos) plugin.  

### Resource Requirements

* For information on resource requirements required to run Ondat, refer to the [official Ondat prerequisites documentation](https://docs.ondat.io/docs/prerequisites/).

### Dependencies

* Required utilities to ensure that deployments are executed successfully.
  * `terraform` , `gcloud` , `kubectl` , `kubectl-storageos`

### Supported Node Image Operating Systems

* Tested on;
  * `UBUNTU` , `UBUNTU_CONTAINERD`

### Environment Setup

#### Step 1 - `gcloud` Configuration

* Ensure that the [`gcloud`](https://cloud.google.com/sdk/docs/install) CLI is installed on your local machine and is in your path. 
  * Initialise `gcloud` CLI.
    * [`gcloud init`](https://cloud.google.com/sdk/gcloud/reference/init)
* Set the project property for `gcloud`.
  * [`gcloud config set project PROJECT_ID`](https://cloud.google.com/sdk/gcloud/reference/config/set)
* Authorise `gcloud` CLI to access Google Cloud using your user account.
  * [`gcloud auth application-default login`](https://cloud.google.com/sdk/gcloud/reference/auth/login)
* Ensure that the Kubernetes Engine API and Compute Engine API are enabled.
  * [`gcloud services enable container.googleapis.com`](https://cloud.google.com/kubernetes-engine/docs/reference/rest)
  * [`gcloud services enable compute.googleapis.com`](https://cloud.google.com/compute/docs/reference/rest/v1)

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
$ cd terraform-kubernetes-ondat-demo/gke/

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
$ export KUBECONFIG="${PWD}/kubeconfig-ondat-demo"

# or use `gcloud` to get the cluster credentials automatically added 
# to your `$HOME/.kube/config`.
$ gcloud container clusters get-credentials terraform-gke-cluster-ondat-demo --region="europe-west1"

$ kubectl get pods --all-namespaces

# destroy the environment created with terraform once you 
# are finished testing out GKE & Ondat.
$ terraform destroy
```

### Using Ondat

* Review the [Ondat Demo README.md](./../ondat/README.md) for an overview of Ondat and its usage. 

### Acknowledgements

* [Provisioning Kubernetes clusters on GCP with Terraform and GKE - learnk8s](https://learnk8s.io/terraform-gke).
* [Provision a GKE Cluster (Google Cloud) - Terraform](https://learn.hashicorp.com/tutorials/terraform/gke).
  * [Google Cloud Platform Provider - Terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs).
  * [Google Network Module - Terraform](https://registry.terraform.io/modules/terraform-google-modules/network/google/latest).
  * [Kubernetes Engine Module - Terraform](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest).
  * [Kubernetes Engine Auth Module - Terraform](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest/submodules/auth).
* [`local_file` Resource - Terraform](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file).
* [`local-exec` Provisioner - Terraform](https://www.terraform.io/docs/language/resources/provisioners/local-exec.html).
* [darwin/arm64 build #27257 - GitHub Issues](https://github.com/hashicorp/terraform/issues/27257).
* [Debugging via a shell on the node - Kubernetes](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#node-shell-session).
