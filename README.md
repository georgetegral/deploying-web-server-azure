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
We will need to configure environment variables in our local computer to use the ```server.json``` Packer template. We will need to create an Azure resource group and then get 4 variables that we can obtain from the resource group.

### Login to Azure from Azure CLI
Ensure that you are logged in to your Azure Subscription

```bash
az login
```

### Create resource group
During the build process, Packer creates temporary Azure resources as it builds the source VM. To capture that source VM for use as an image, we must define a resource group. The output from the Packer build process is stored in this resource group.

```bash
az group create -n udacity-rg -l southcentralus
```

### Create Azure credentials
Packer authenticates with Azure using a service principal. An Azure service principal is a security identity that you can use with apps, services, and automation tools like Packer. We control and define the permissions as to what operations the service principal can perform in Azure.

```bash
az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
```

We will also need to obtain the Azure Subscription ID with the following command:

```bash
az account show --query "{ subscription_id: id }"
```

With this 4 variables identified, we can now go to the terminal and export the environment variables with the following commands:

```bash
export ARM_CLIENT_ID=your_client_id
export ARM_CLIENT_SECRET=your_client_secret
export ARM_SUBSCRIPTION_ID=your_suscription_id
export ARM_TENANT_ID=your_tenant_id
```

Once you have exported this environment variables, use the ```printenv``` command to check that they are properly configured:

```bash
printenv
```

We can now proceed with the exercise

## Deploy the Packer template

Now we can deploy our Packer template with the following command:

```bash
packer build server.json
```

If everything went correctly, we should be able to see an output similar to the following:

```bash
azure-arm: output will be in this color.

==> azure-arm: Running builder ...
==> azure-arm: Getting tokens using client secret
==> azure-arm: Getting tokens using client secret
    azure-arm: Creating Azure Resource Manager (ARM) client ...
==> azure-arm: WARNING: Zone resiliency may not be supported in South Central US, checkout the docs at https://docs.microsoft.com/en-us/azure/availability-zones/
==> azure-arm: Creating resource group ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-4g8pdhdj8x'
==> azure-arm:  -> Location          : 'South Central US'
==> azure-arm:  -> Tags              :
==> azure-arm:  ->> tag : udacity
==> azure-arm: Validating deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-4g8pdhdj8x'
==> azure-arm:  -> DeploymentName    : 'pkrdp4g8pdhdj8x'
==> azure-arm: Deploying deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-4g8pdhdj8x'
==> azure-arm:  -> DeploymentName    : 'pkrdp4g8pdhdj8x'
==> azure-arm:
==> azure-arm: Getting the VM's IP address ...
==> azure-arm:  -> ResourceGroupName   : 'pkr-Resource-Group-4g8pdhdj8x'
==> azure-arm:  -> PublicIPAddressName : 'pkrip4g8pdhdj8x'
==> azure-arm:  -> NicName             : 'pkrni4g8pdhdj8x'
==> azure-arm:  -> Network Connection  : 'PublicEndpoint'
==> azure-arm:  -> IP Address          : '23.100.120.204'
==> azure-arm: Waiting for SSH to become available...
==> azure-arm: Connected to SSH!
==> azure-arm: Provisioning with shell script: C:\Users\jorge\AppData\Local\Temp\packer-shell779550731
==> azure-arm: + echo Hello, World!
==> azure-arm: + nohup busybox httpd -f -p 80
==> azure-arm: Querying the machine's properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-4g8pdhdj8x'
==> azure-arm:  -> ComputeName       : 'pkrvm4g8pdhdj8x'
==> azure-arm:  -> Managed OS Disk   : '/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/pkr-Resource-Group-4g8pdhdj8x/providers/Microsoft.Compute/disks/pkros4g8pdhdj8x'
==> azure-arm: Querying the machine's additional disks properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-4g8pdhdj8x'
==> azure-arm:  -> ComputeName       : 'pkrvm4g8pdhdj8x'
==> azure-arm: Powering off machine ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-4g8pdhdj8x'
==> azure-arm:  -> ComputeName       : 'pkrvm4g8pdhdj8x'
==> azure-arm: Capturing image ...
==> azure-arm:  -> Compute ResourceGroupName : 'pkr-Resource-Group-4g8pdhdj8x'
==> azure-arm:  -> Compute Name              : 'pkrvm4g8pdhdj8x'
==> azure-arm:  -> Compute Location          : 'South Central US'
==> azure-arm:  -> Image ResourceGroupName   : 'udacity-rg'
==> azure-arm:  -> Image Name                : 'PackerImage'
==> azure-arm:  -> Image Location            : 'South Central US'
==> azure-arm: 
==> azure-arm: Deleting individual resources ...
==> azure-arm: Adding to deletion queue -> Microsoft.Compute/virtualMachines : 'pkrvm4g8pdhdj8x'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/networkInterfaces : 'pkrni4g8pdhdj8x'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/virtualNetworks : 'pkrvn4g8pdhdj8x'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/publicIPAddresses : 'pkrip4g8pdhdj8x'
==> azure-arm: Waiting for deletion of all resources...
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvn4g8pdhdj8x'
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkrip4g8pdhdj8x'
==> azure-arm: Attempting deletion -> Microsoft.Compute/virtualMachines : 'pkrvm4g8pdhdj8x'
==> azure-arm: Attempting deletion -> Microsoft.Network/networkInterfaces : 'pkrni4g8pdhdj8x'
==> azure-arm: Error deleting resource. Will retry.
==> azure-arm: Name: pkrvn4g8pdhdj8x
==> azure-arm: Error: network.VirtualNetworksClient#Delete: Failure sending request: StatusCode=400 -- Original Error: Code="InUseSubnetCannotBeDeleted" Message="Subnet pkrsn4g8pdhdj8x is in use by /subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/pkr-Resource-Group-4g8pdhdj8x/providers/Microsoft.Network/networkInterfaces/pkrni4g8pdhdj8x/ipConfigurations/ipconfig and cannot be deleted. In order to delete the subnet, delete all the resources within the subnet. See aka.ms/deletesubnet." Details=[]
==> azure-arm:
==> azure-arm: Error deleting resource. Will retry.
==> azure-arm: Name: pkrip4g8pdhdj8x
==> azure-arm: Error: network.PublicIPAddressesClient#Delete: Failure sending request: StatusCode=400 -- Original Error: Code="PublicIPAddressCannotBeDeleted" Message="Public IP address /subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/pkr-Resource-Group-4g8pdhdj8x/providers/Microsoft.Network/publicIPAddresses/pkrip4g8pdhdj8x can not be deleted since it is still allocated to resource /subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/pkr-Resource-Group-4g8pdhdj8x/providers/Microsoft.Network/networkInterfaces/pkrni4g8pdhdj8x/ipConfigurations/ipconfig. In order to delete the public 
IP, disassociate/detach the Public IP address from the resource.  To learn how to do this, see aka.ms/deletepublicip." Details=[]
==> azure-arm:
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvn4g8pdhdj8x'
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkrip4g8pdhdj8x'
==> azure-arm:  Deleting -> Microsoft.Compute/disks : '/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/pkr-Resource-Group-4g8pdhdj8x/providers/Microsoft.Compute/disks/pkros4g8pdhdj8x'
==> azure-arm: Removing the created Deployment object: 'pkrdp4g8pdhdj8x'
==> azure-arm: 
==> azure-arm: Cleanup requested, deleting resource group ...
==> azure-arm: Resource group has been deleted.
Build 'azure-arm' finished after 9 minutes 22 seconds.

==> Wait completed after 9 minutes 22 seconds

==> Builds finished. The artifacts of successful builds are:
--> azure-arm: Azure.ResourceManagement.VMImage:

OSType: Linux
ManagedImageResourceGroupName: udacity-rg
ManagedImageName: PackerImage
ManagedImageId: /subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg/providers/Microsoft.Compute/images/PackerImage
ManagedImageLocation: South Central US
```

And in the Azure portal we should be able to see the image "PackerImage" in our resource group.

![Packer Image](images/PackerImage.PNG)

## Deploy the infrastructure as code with Terraform

The first step is to run the following Terraform command to download all necessary plugins:

```bash
terraform init
```

Should you wish to change the number of virtual machines that are deployed, or the resource group prefix, or anything else, feel free to change it in the ```vars.tf``` file. Just change the default value, or remove it and set it when you will deploy it.

Before we can plan our solution, we have to take into account that we have already created the resource group for our PackerImage, and Terraform does not allow to deploy resources into existing resource groups. 

To fix this we need to import the existing resource group to Terraform so that it knows to deploy our resources there. To do that we have to run the following command:

```bash
terraform import azurerm_resource_group.main /subscriptions/{subsriptionId}/resourceGroups/{resourceGroupName}
```

In my specific case it is:
```bash
terraform import azurerm_resource_group.main /subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg
```

![Import RG](images/import-rg.PNG)

Once that is done, we can run the following command to plan our solution:

```bash
terraform plan -out solution.plan
``` 

To create our infrastructure in Azure we have to run the following command:

```bash
terraform apply
```

While the infrastructure is deploying, we should get output similar to this:

```bash
azurerm_virtual_network.main: Creating...
azurerm_public_ip.main: Creating...
azurerm_availability_set.main: Creating...
azurerm_managed_disk.main: Creating...
azurerm_network_security_group.main: Creating...
azurerm_availability_set.main: Creation complete after 1s [id=/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg/providers/Microsoft.Compute/availabilitySets/udacity-aset]
azurerm_public_ip.main: Creation complete after 3s [id=/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg/providers/Microsoft.Network/publicIPAddresses/udacity-ip]
azurerm_lb.main: Creating...
azurerm_lb.main: Creation complete after 0s [id=/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg/providers/Microsoft.Network/loadBalancers/udacity-lb]
azurerm_lb_backend_address_pool.main: Creating...
azurerm_lb_backend_address_pool.main: Creation complete after 1s [id=/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg/providers/Microsoft.Network/loadBalancers/udacity-lb/backendAddressPools/udacity-bap]
azurerm_virtual_network.main: Creation complete after 5s [id=/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg/providers/Microsoft.Network/virtualNetworks/udacity-network]
azurerm_subnet.main: Creating...
azurerm_managed_disk.main: Creation complete after 9s [id=/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg/providers/Microsoft.Compute/disks/udacity-md]
azurerm_subnet.main: Creation complete after 4s [id=/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg/providers/Microsoft.Network/virtualNetworks/udacity-network/subnets/udacity-subnet]
azurerm_network_interface.main[1]: Creating...
azurerm_network_interface.main[0]: Creating...
azurerm_network_interface.main[1]: Creation complete after 1s [id=/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg/providers/Microsoft.Network/networkInterfaces/udacity-nic-1]
azurerm_network_interface.main[0]: Creation complete after 1s [id=/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg/providers/Microsoft.Network/networkInterfaces/udacity-nic-0]
azurerm_linux_virtual_machine.main[0]: Creating...
azurerm_linux_virtual_machine.main[1]: Creating...
azurerm_network_security_group.main: Creation complete after 10s [id=/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg/providers/Microsoft.Network/networkSecurityGroups/udacity-nsg]
azurerm_linux_virtual_machine.main[0]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [40s elapsed]
oups/udacity-rg/providers/Microsoft.Compute/virtualMachines/udacity-vm-1]                                                            oups/udacity-rg/providers/Microsoft.Compute/virtualMachines/udacity-vm-0]
╷                                                                                                                                    oups/udacity-rg/providers/Microsoft.Compute/virtualMachines/udacity-vm-1]
```

After we have deployed our infrastructure, we should get a confirmation message from Terraform

![Apply complete bash](images/apply-complete-cmd.PNG)

We can also check if the resources are deployed in the Azure Portal, the result will look something like the following:

![Apply complete portal](images/apply-complete-portal.PNG)

We can also check all the resources that we just deployed in Terraform with the following command:

```bash
terraform show
```

Finally, remember to destroy the resources:

```bash
terraform destroy
```

## References
- [What is Infrastructure as Code?](https://docs.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code)
- [Azure](https://portal.azure.com)
- [Azure Command Line Interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Packer](https://www.packer.io/downloads)
- [Terraform](https://www.terraform.io/downloads.html)
- [How to use Packer to create Linux virtual machine images in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer)
- [Terraform Azure Documentation](https://learn.hashicorp.com/collections/terraform/azure-get-started)