COMMAND=$1
terraform $COMMAND \
-var "aws_access_key=XXXX" \
-var "aws_secret_key=XXXXXXXX" \
-var "vpc_id=vpc-XXXXXXXX" \
-var "pvt_key=$HOME/.ssh/empire-c2.pem"
