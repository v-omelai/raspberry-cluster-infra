variable "sleep" {
  description = "The number of seconds to pause during execution"
  type        = number
}

resource "null_resource" "server" {
  connection {
    type        = "ssh"
    user        = "52pi-k3s-1"
    private_key = file("/../.ssh/52pi-k3s-1")
    host        = "52pi-k3s-1"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /tmp/k3s",
      "sudo chmod 777 /tmp/k3s",
      "curl -sfL https://get.k3s.io | sh -",
      "sleep ${var.sleep}",
      "sudo cat /var/lib/rancher/k3s/server/node-token > /tmp/k3s/node-token",
      "sudo ip -4 route get 1.1.1.1 | grep -oP 'src \\K\\S+' > /tmp/k3s/server-address",
    ]
  }

  provisioner "local-exec" {
    command = "scp -i ../.ssh/52pi-k3s-1 -r 52pi-k3s-1@52pi-k3s-1:/tmp/k3s ../.temp"
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "sudo k3s-killall.sh",
      "sudo k3s-uninstall.sh",
    ]
  }
}
