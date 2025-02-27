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

      "sudo mkdir -p /var/lib/longhorn",
      "if mountpoint -q /var/lib/longhorn; then sudo umount -l /var/lib/longhorn; fi",
      "if ! sudo blkid /dev/sda | grep -q 'TYPE=\"ext4\"'; then",
      "  sudo wipefs --all --force /dev/sda",
      "  sudo mkfs.ext4 /dev/sda",
      "fi",
      "sudo mount /dev/sda /var/lib/longhorn",
      "sudo chmod 777 /var/lib/longhorn",
      "if ! grep -q '^/dev/sda /var/lib/longhorn ext4 ' /etc/fstab; then",
      "  echo '/dev/sda /var/lib/longhorn ext4 defaults 0 0' | sudo tee -a /etc/fstab",
      "fi",
      "sudo systemctl daemon-reload",

      "sudo ip -4 route get 1.1.1.1 | grep -oP 'src \\K\\S+' > /tmp/.server/address",
      "curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE=644 sh -s - --bind-address $(cat /tmp/.server/address)",
      "sleep ${self.triggers.sleep}",
      "sudo cat /var/lib/rancher/k3s/server/node-token > /tmp/.server/node-token",
      "sudo cat /etc/rancher/k3s/k3s.yaml > /tmp/.server/config",
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
      "if mountpoint -q /var/lib/longhorn; then sudo umount -l /var/lib/longhorn; fi",
      "sudo rm -rf /var/lib/longhorn",
      "sudo sed -i '/\\/var\\/lib\\/longhorn/d' /etc/fstab",
      "sudo systemctl daemon-reload",
      "sudo k3s-killall.sh",
      "sudo k3s-uninstall.sh",
    ]
  }
}
