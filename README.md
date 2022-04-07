# Spin up basic server configuration
This is a Terraform and Ansible provisioning system for multiple EC2 instances in different availability zones. It will create instances in all of the zones specified in the "availability_zones" variable in variables.tf. It also installs a basic Nginx application to the default port and allows ingress.

Each of the instances is placed within its own Virtual Private Cloud (VPC) context, which allows for logical separation and placement.

The new instances will be linked together by a Wireguard network on the 192.168.6.0/24 subnet, which hosts allocated sequentially from 192.168.6.1. The first EC2 instance will be the Wireguard server while all others are clients. The environment allows peer-to-peer network communication. 

## Modules and Flow
Provisioning is via Terraform which then hands over the ansible for configuration.

### User Setup
The ansible scripts extensibly configures a set of users on each of the boxes. It installs public-key authentication for each user and password-less sudo for the users specified in setup_sudoers.yml. 

### Wireguard Information
This application will create files in /home/martin/wireguard with new configuration files and public/private keys if they don't already exist. You can then join the network using:
    
    sudo wg-quick up ./wg0.conf

### Virtual Private Cloud
Boxes are configured on their own private subnets of 10.0.0.0/16. These are set so that "map_public_ip_on_launch" is true, so every instance is publicly accessible. 

### Security Group
Instances within the private VPCs (which determine the availability zone/region of the instances) are assigned public IP addresses and traffic is allowed to pass to boxes on ports 22 (SSH), 80 (HTTP), and 41194 (for Wireguard). The Security Group is applied to instances via "vpc_security_group_ids" and also to the VPC via "vpc_id". 

## Next Steps
### Block Storage
There's an incomplete block storage module attached here that shows how to attach an EBS volume to an EC2 instance. An important note is that different kernels place block devices under different names. So even if we request /dev/sdd we may get /dev/xvdd. The next step is to modify the block storage setup module so that it allocates one device for each instance and correctly returns the mount path.

### Load Balancer
The next module that needs writing is the basic load balancer that will distribute traffic between the Nginx instances.

&copy; Martin Paul Eve 2022