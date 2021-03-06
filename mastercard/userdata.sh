#!/bin/bash
set -o xtrace
sudo yum update -y
sudo amazon-linux-extras install nginx1
sudo systemctl start nginx
