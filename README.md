About:

This Repository is created for the development of Infrastructure with the help of Terraform in which the end-users only contact the load  balancers which is used to request the public facing web application.

Pre-requisites:

1. Terraform version : V12
2. Python 3.8
3. Aws-Cli
4. Visual studio
5. Github

Terraform commands:

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