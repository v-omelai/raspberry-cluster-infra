variable "instances" {
  description = "The number of instances"
  type        = number
}

variable "sleep" {
  description = "The number of seconds to pause during execution"
  type        = number
}

resource "null_resource" "initialize" {
  count = var.instances

  connection {
    type        = "ssh"
    user        = "52pi-k3s-${count.index + 1}"
    private_key = file("/../.ssh/52pi-k3s-${count.index + 1}")
    host        = "52pi-k3s-${count.index + 1}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Running on 52pi-k3s-${count.index + 1}'",

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

  provisioner "remote-exec" {
    inline = [
      "uptime",
    ]
  }
}
