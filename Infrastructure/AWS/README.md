# AWS CLI Instructions
The most efficient way to run the AWS Terraform builds is to use the AWS CLI tool.

1. Install AWS CLI tool
    * `brew install aws` on Mac OS X
    * `pip install awscli` on Linux (tested on Kali)

1. configure your [AWS Access Key](https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/). You'll need your key ID and secret access key.
    * `aws configure`
1. Add your SSH key to the key store. Enter your password if necessary
    * `ssh-add ~/.ssh/<PRIVATE KEY>` 
1. Initialize the directory and install the provider specific packages
    * `terraform init -var "pub_key=$HOME/.ssh/id_rsa.pub" -var "priv_key=$HOME/.ssh/id_rsa"` 
3. Create the Terraform Plan
    * `terraform plan -var "pub_key=$HOME/.ssh/id_rsa.pub" -var "priv_key=$HOME/.ssh/id_rsa"`
4. Apply the Terraform Plan
    * `terraform apply -var "pub_key=$HOME/.ssh/id_rsa.pub" -var "priv_key=$HOME/.ssh/id_rsa"`
5. Destroy the Infrastructure
    * `terraform destroy -var "pub_key=$HOME/.ssh/id_rsa.pub" -var "priv_key=$HOME/.ssh/id_rsa"`


Or, create a `go.sh` which can be called with `./go.sh [init, plan, apply, destroy]
```bash
COMMAND=$1
terraform $COMMAND \
-var "pub_key=$HOME/.ssh/id_rsa.pub" \
-var "pvt_key=$HOME/.ssh/id_rsa" \
```