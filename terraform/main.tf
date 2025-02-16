module "initialize" {
  source    = "./modules/initialize"
  instances = var.instances
  sleep     = 60
}

module "server" {
  depends_on = [module.initialize]
  source     = "./modules/server"
  sleep      = 30
}

module "agent" {
  depends_on = [module.initialize, module.server]
  source     = "./modules/agent"
  instances  = var.instances
  sleep      = 5
}
