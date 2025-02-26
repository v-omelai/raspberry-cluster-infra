resource "null_resource" "wrapper" {
  depends_on = [module.initialize, module.server, module.agents]
  triggers = {
    config = "../.server/config"
  }
}

provider "kubernetes" {
  config_path = null_resource.wrapper.triggers.config
}

provider "helm" {
  kubernetes {
    config_path = null_resource.wrapper.triggers.config
  }
}
