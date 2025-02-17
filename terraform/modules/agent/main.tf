variable "instances" {
  description = "The number of instances"
  type        = number
}

variable "sleep" {
  description = "The number of seconds to pause during execution"
  type        = number
}

resource "null_resource" "agent" {
  count = var.instances - 1

  connection {
    type        = "ssh"
    user        = "52pi-k3s-${count.index + 2}"
    private_key = file("/../.ssh/52pi-k3s-${count.index + 2}")
    host        = "52pi-k3s-${count.index + 2}"
  }

  provisioner "local-exec" {
    command = "scp -i ../.ssh/52pi-k3s-${count.index + 2} -r ../.temp/k3s 52pi-k3s-${count.index + 2}@52pi-k3s-${count.index + 2}:/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | K3S_URL=https://$(cat /tmp/k3s/server-address):6443 K3S_TOKEN=$(cat /tmp/k3s/node-token) sh -",
      "sleep ${var.sleep}",
    ]
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "sudo k3s-killall.sh",
      "sudo k3s-agent-uninstall.sh",
    ]
  }
}
