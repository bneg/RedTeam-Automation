COMMAND=$1
terraform $COMMAND \
-var "do_token=444444444444444444444444444444444444444444444" \
-var "pub_key=$HOME/.ssh/id_rsa.pub" \
-var "pvt_key=$HOME/.ssh/id_rsa" \
-var "ssh_fingerprint=DE:AD:BE:EF:C0:DE:DE:AD:BE:EF:C0:DE:AD:BE:EF:C0"