# This module deploys EKS on AWS using Terraform: 
https://github.com/hashicorp/terraform-provider-aws

# Deploys sample Guestbook on the eks cluster


To deploy the infrastructure: 
`cd terraform`
`terraform apply`

To deploy the Guestbook: 
`cd k8s/deployment/stateless`
`bash deploy.sh `
