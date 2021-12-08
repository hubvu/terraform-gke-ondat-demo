### Provision Managed Kubernetes cluster(s) Using Terraform & Install Ondat

- [Provision Managed Kubernetes cluster(s) Using Terraform & Install Ondat](#provision-managed-kubernetes-clusters-using-terraform--install-ondat)
- [What is this?](#what-is-this)
- [Getting Started](#getting-started)
  - [Google Kubernetes Engine (GKE)](#google-kubernetes-engine-gke)
  - [Azure Kubernetes Service (AKS)](#azure-kubernetes-service-aks)
  - [Elastic Kubernetes Service (EKS)](#elastic-kubernetes-service-eks)
- [Contributing](#contributing)
- [Licence](#licence)

### What is this?

* A demonstration repository that leverages Terraform to provision *Google Kubernetes Engine* [GKE], *Azure Kubernetes Service* [AKS] or *Elastic Kubernetes Service* [EKS] cluster(s) - and installs [Ondat](https://www.ondat.io/) - a software-defined, cloud native storage platform for Kubernetes.

### Getting Started

#### Google Kubernetes Engine (GKE)

* To provision a Google Kubernetes Engine [GKE] cluster (with `terraform`) and deploy Ondat, instructions can be found [here](./gke/README.md).

#### Azure Kubernetes Service (AKS)

* To provision a Azure Kubernetes Service [AKS] cluster (with `terraform`) and deploy Ondat, instructions can be found [here](./aks/README.md).

#### Elastic Kubernetes Service (EKS)

* To provision a Elastic Kubernetes Engine [EKS] cluster (with `eksctl`) and deploy Ondat, instructions can be found [here](https://github.com/chris-milsted/sa-demo-ondat/blob/main/Demo-Building.md).

### Contributing

* Contribution guidelines for this project can be found in the [Contributing](./CONTRIBUTING.md) document.

### Licence

* Licenced under the [MIT Licence](./LICENSE).