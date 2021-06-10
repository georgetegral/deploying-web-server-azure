# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

## Table of Contents
* [Introduction](#Introduction)
* [Getting Started](#Getting-Started)
* [Install our dependencies](#Install-our-dependencies)
* [Deploy a policy](#Deploy-a-policy)
* [Create and configure our environment variables](#Create-and-configure-our-environment-variables)
* [Deploy the Packer template](#Deploy-the-Packer-template)
* [Deploy the infrastructure as code with Terraform](#Deploy-the-infrastructure-as-code-with-Terraform)
* [References](#References)

## Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

Infrastructure as Code (IaC) is the management of infrastructure (networks, virtual machines, load balancers, and connection topology) in a descriptive model, using the same versioning as DevOps team uses for source code. Like the principle that the same source code generates the same binary, an IaC model generates the same environment every time it is applied. IaC is a key DevOps practice and is used in conjunction with continuous delivery.

For this project we will use Azure as our cloud provider, in conjunction with Terraform for our IaC needs, and Packer, which will help us with the creation of virtual machine images. 

We will use a Packer template (in JSON format), with a Terraform template to deploy a customizable, scalable web server in Azure.

## Getting Started
In this project we will follow the following steps:
1. Install our dependencies
2. Deploy a policy
3. Create and configure our environment variables
4. Deploy the Packer template
5. Deploy the infrastructure as code with Terraform

## Install our dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

## Deploy a policy
We will deploy a security policy that enforces that all the resources that we deploy have a tag, this is to have a better understanding of what each resource does. The rules of the policy are defined in the ```enforceTag.json``` file. To deploy the policy we write in our command line:
```bash
az policy definition create --name tagging-policy --mode indexed --rules enforceTag.json --description "Policy to enforce all indexed resources are tagged"
```

When we have done this, we should wait a few minutes and then enter the following command:
```bash
az policy assignment list
```

If everything went correctly, we should be able to see a json definition of our new policy:

![Policy assignment](images/az-policy-assignment-list.PNG)

We are ready to continue to the next step.

## Create and configure our environment variables
We will need to configure environment variables in our local computer to use the ```server.json``` Packer template.
We will need 3 variables that we can get from the Azure portal

### Get Subscription ID
* Login into your azure account.
* Search "Subscriptions".
* Select your subscription.
* Copy the Subscription Id.

### Get Client ID
* Login into your azure account.
* Search "Azure Active Directory".
* Click "App registrations" under the Manage tab.
* Click the application.
* Copy the client ID.

#### Get Client Secret
* Login into your azure account.
* Search "Azure Active Directory".
* Click "App registrations" under the Manage tab.
* Click the application.
* Click "Certificates & Secrets" under the Manage tab.
* Create a client secret as you need.
* Copy the client secret value.

With this 3 variables identified, we can now go to the terminal and export the environment variables with the following commands:

```bash
export ARM_CLIENT_ID=your_client_id
export ARM_CLIENT_SECRET=your_client_secret
export ARM_SUBSCRIPTION_ID=your_suscription_id
```

Once you have exported this environment variables, use the ```printenv``` command to check that they are properly configured:

```bash
printenv
```

We can now proceed with the exercise

## Deploy the Packer template

## Deploy the infrastructure as code with Terraform

## References
- [What is Infrastructure as Code?](https://docs.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code)
- [Azure](https://portal.azure.com)
- [Azure Command Line Interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Packer](https://www.packer.io/downloads)
- [Terraform](https://www.terraform.io/downloads.html)