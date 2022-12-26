# IacTerraform
Multi AZ and multi region deployment of EKS cluster using Terraform. 
Automatic deployment of busybox image using Kubernetes Terraform Module.
![alt text](./Images/infrastructure.png?raw=true "output")

## How to deploy:
1. You need these pre- installed:
aws cli
terraform
kubectl

2. Configure your aws account using the command: "aws configure"

3. Clone the repo, and CD into the dirctory you want to deploy (Region1 / Region2)

4. Change the variables to your preferences and your environment. ( file 0-variables.tf)

5. Run commands: 
terraform init
terraform plan
terraform apply

6. After about 15 minutes the infrastructure will be deployed.
Run the command aws eks --region us-west-1 update-kubeconfig --name eks-cluster
(change the values accordingly)
In order to configure kubectl with your infrastructre.

7. Run the command: kubectl get svc
The link in "externalIP" in "terraform-service" is your deployment Load Balancer link.

