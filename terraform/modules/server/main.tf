variable "sleep" {
  type = number
}

variable "server" {
  type = object({
    user = string
    host = string
    key  = string
  })
}

resource "null_resource" "server" {
  triggers = {
    sleep = var.sleep
    user  = var.server.user
    host  = var.server.host
    key   = var.server.key
    run   = timestamp()
  }

  connection {
    type        = "ssh"
    user        = self.triggers.user
    host        = self.triggers.host
    private_key = file(self.triggers.key)
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Running on ${self.triggers.host}'",
      "sudo ip -4 route get 1.1.1.1 | grep -oP 'src \\K\\S+' > /tmp/.server/address",
      "curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE=644 sh -",
      "sleep ${self.triggers.sleep}",
      "sudo cat /var/lib/rancher/k3s/server/node-token > /tmp/.server/node-token",
      "grep -qxF 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' ~/.bashrc || echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc",
      "source ~/.bashrc",
      "echo 'K3s server is now ready'",
    ]
  }

  provisioner "local-exec" {
    command = "scp -i ${self.triggers.key} -r ${self.triggers.user}@${self.triggers.host}:/tmp/.server .."
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "sudo k3s-killall.sh",
      "sudo k3s-uninstall.sh",
    ]
  }
}
