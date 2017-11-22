# Amazon EC2
A simple Empire server using a small EC2 instance. Installs Empire, creates a listener, and downloads a corresponding stager.

This is *not* perfect. I would love to see this get better.

##Prerequisites
These can all be found at bneg's blog [post](https://bneg.io/2017/11/06/automated-empire-infrastructure/).
+ Download Terraform (https://www.terraform.io/downloads.html)
+ Install ansible `apt-get install ansible` or `pip install ansible`.
+ An Amazon EC2 account.
+ Accepted the terms and subscribe to the Kali rolling-release in the AWS marketplace (http://aws.amazon.com/marketplace/pp?sku=89bab4k3h9x4rkojcm2tj8j4l).

## Instructions

1. Setup an Amazon EC2 account. This is kind of a big deal.
2. Generate a keypair. Save the .pem and chmod 400 it.
3. Take note of your AWS access/secret keys and your VPC ID. Put those in go.sh
4. ./go.sh init
5. ./go.sh apply
6. ?????????????
7. Profit?!?!