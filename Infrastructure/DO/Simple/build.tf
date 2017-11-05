variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}

provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_droplet" "empire-server" {
    image = "ubuntu-14-04-x64"
    name = "Empire"
    region = "ams3"
    size = "512mb"
    ipv6 = false
    ssh_keys = [
       "${var.ssh_fingerprint}"
    ]

inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "22"
      source_addresses   = ["0.0.0.0/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "80"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "443"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]


connection {
    user = "root"
    type = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout = "2m"
}

provisioner "local-exec" {
    command = "sleep -Seconds 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root --private-key '${ssh-keys},' -i '${digitalocean_droplet.empire-server.ipv4_address},' Empire.yml"
  }
}


output "Empire C2 Server IP" {
    value = "${digitalocean_droplet.empire-server.ipv4_address}"
}