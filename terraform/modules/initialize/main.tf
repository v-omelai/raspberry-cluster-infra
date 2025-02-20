variable "nodes" {
  type = list(object({
    user = string
    host = string
    key  = string
  }))
}

variable "sleep" {
  type = number
}

resource "null_resource" "initialize" {
  for_each = { for idx, node in var.nodes : idx => node }

  triggers = {
    user = each.value.user
    host = each.value.host
    key  = each.value.key
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

      "sudo apt-get upgrade -y",
      "sudo apt-get update -y",
      "sudo apt-get autoremove -y",
      "sudo apt-get autoclean -y",

      "if grep -q 'cgroup_enable=cpuset' /boot/firmware/cmdline.txt; then",
      "  echo 'cgroup_enable=cpuset found in /boot/firmware/cmdline.txt'",
      "else",
      "  echo 'cgroup_enable=cpuset not found in /boot/firmware/cmdline.txt'",
      "  cat /boot/firmware/cmdline.txt",
      "  sudo sed -i -e '1s/$/ cgroup_enable=cpuset/g' /boot/firmware/cmdline.txt",
      "  cat /boot/firmware/cmdline.txt",
      "fi",

      "if grep -q 'cgroup_enable=memory' /boot/firmware/cmdline.txt; then",
      "  echo 'cgroup_enable=memory found in /boot/firmware/cmdline.txt'",
      "else",
      "  echo 'cgroup_enable=memory not found in /boot/firmware/cmdline.txt'",
      "  cat /boot/firmware/cmdline.txt",
      "  sudo sed -i -e '1s/$/ cgroup_enable=memory/g' /boot/firmware/cmdline.txt",
      "  cat /boot/firmware/cmdline.txt",
      "fi",

      "if grep -q 'cgroup_memory=1' /boot/firmware/cmdline.txt; then",
      "  echo 'cgroup_memory found in /boot/firmware/cmdline.txt'",
      "else",
      "  echo 'cgroup_memory not found in /boot/firmware/cmdline.txt'",
      "  cat /boot/firmware/cmdline.txt",
      "  sudo sed -i -e '1s/$/ cgroup_memory=1/g' /boot/firmware/cmdline.txt",
      "  cat /boot/firmware/cmdline.txt",
      "fi",

      "uptime",
      "sudo nohup sh -c 'sleep 2; shutdown -r now' &",
      "sleep 1",
    ]
  }

  provisioner "local-exec" {
    command = "PowerShell -Command Start-Sleep ${var.sleep}"
  }

  provisioner "local-exec" {
    command = "scp -i ${self.triggers.key} -r ../manifests ${self.triggers.user}@${self.triggers.host}:~"
  }

  provisioner "remote-exec" {
    inline = [
      "uptime",
      "sudo mkdir -p /tmp/.server",
      "sudo mkdir -p ~/manifests",
      "sudo chmod 777 /tmp/.server",
      "sudo chmod 777 ~/manifests",
      "echo 'Node ${self.triggers.host} initialized'"
    ]
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "sudo rm -rf /tmp/.server",
      "sudo rm -rf ~/manifests",
    ]
  }
}
