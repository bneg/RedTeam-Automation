COMMAND=$1
terraform $COMMAND \
-var "vpc_id=vpc-XXXXXXXX" \
-var "priv_key=$HOME/.ssh/[secret_key_id_rsa]"
-var "pub_key=$HOME/.ssh/[public_key_id_rsa.pub"