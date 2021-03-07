ABOUT REPO:

This Repository is created for the development of Infrastructure with the help of Terraform in which the end-users only contact the load  balancers which is used to request the public facing web application.


ABOUT ARCHITECTURE:


Using Terraform we are building a module meant to deploy a web application (NGNIX) which contains VPC and both public and private subnet, where private subnet is used for compute and public is use for load balancers. End-users only contact the load balancers and the underlying instance are accessed for management purposes, also we are attatching the security group scheme which supports the minimal set of ports required for communication. The AWS generated load balancer hostname with be used for request to the public facing web application and an autoscaling group should be created which utilizes the latest AWS AMI. The instance in the ASG

    o   Contain both a root volume to store the application / services

    o   Contain a secondary volume meant to store any log data bound from / var/log

    o   Include a web server.


PRE-REQUISITES:

1. Terraform version : V12
2. Python 3.8
3. Aws-Cli
4. Visual studio
5. Github

TERRAFORM COMMAND:

1. terraform init:

    Usage: terraform init

    The terraform init command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

2. terraform apply:

    Usage: terraform apply [options] [plan]

    By default, apply scans the current directory for the configuration and applies the changes appropriately. However, you can optionally give the path to a saved plan file that was previously created with terraform plan.

    If you don't give a plan file on the command line, terraform apply will create a new plan automatically and then prompt for approval to apply it. If the created plan does not include any changes to resources or to root module output values then terraform apply will exit immediately, without prompting.

3. terraform destroy:

    Usage: terraform destroy [options]

    Infrastructure managed by Terraform will be destroyed. This will ask for confirmation before destroying.


INPUT:

 All the required input for the creation  of this infrastructure is present in the terraform.auto.tfvars which is present inside the mastercard module. You can modify the input according to requirement. This file is used to assigining the value to the defined variable.


VARIABLES:

All the required variable for creating this infrastructure is present in the variables.tf file. This file is used to defining the variables.


OUTPUTS:

Output for all the resources which are created in this infrastructure is present in outputs.tf file.


WARNING:


Do not delete or modify the terraform.tfstate file.








 
