resource "null_resource" "agents" {
  for_each = { for idx, agent in var.agents : idx => agent }

  triggers = {
    sleep = var.sleep
    user  = each.value.user
    host  = each.value.host
    key   = each.value.key
    run   = timestamp()
  }

  connection {
    type        = "ssh"
    user        = self.triggers.user
    host        = self.triggers.host
    private_key = file(self.triggers.key)
  }

  provisioner "local-exec" {
    command = "scp -i ${self.triggers.key} -r ../.server ${self.triggers.user}@${self.triggers.host}:/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Running on ${self.triggers.host}'",
      "curl -sfL https://get.k3s.io | K3S_URL=https://$(cat /tmp/.server/address):6443 K3S_TOKEN=$(cat /tmp/.server/node-token) sh -",
      "sleep ${self.triggers.sleep}",
      "echo 'Node ${self.triggers.host} is now registered'",
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
