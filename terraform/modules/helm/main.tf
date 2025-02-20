variable "server" {
  type = object({
    user = string
    host = string
    key  = string
  })
}

resource "null_resource" "helm" {
  triggers = {
    user = var.server.user
    host = var.server.host
    key  = var.server.key
    run  = timestamp()
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
      "curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3",
      "chmod 700 get_helm.sh",
      "./get_helm.sh",
      "sudo rm -rf get_helm.sh",
      "echo 'Helm is now installed'",
    ]
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "sudo rm -rf /usr/local/bin/helm",
      "sudo rm -rf ~/.cache/helm",
      "sudo rm -rf ~/.config/helm",
      "sudo rm -rf ~/.local/share/helm",
    ]
  }
}
