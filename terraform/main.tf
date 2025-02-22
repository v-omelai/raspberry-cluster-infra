module "initialize" {
  source = "./modules/initialize"
  nodes  = concat([var.nodes.server], var.nodes.agents)
  sleep  = var.sleep.initialize
}

module "server" {
  depends_on = [module.initialize]
  source     = "./modules/server"
  sleep      = var.sleep.server
  server     = var.nodes.server
}

module "agents" {
  depends_on = [module.initialize, module.server]
  source     = "./modules/agents"
  sleep      = var.sleep.agents
  agents     = var.nodes.agents
}

module "helm" {
  depends_on = [module.initialize, module.server]
  source     = "./modules/helm"
  server     = var.nodes.server
}
