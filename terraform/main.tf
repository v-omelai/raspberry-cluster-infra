module "initialize" {
  source = "./modules/initialize"
  nodes  = concat([var.nodes.server], var.nodes.agents)
  sleep  = var.sleep
}

module "k3s-server" {
  depends_on = [module.initialize]
  source     = "./modules/k3s-server"
  server     = var.nodes.server
}

module "k3s-agent" {
  depends_on = [module.initialize, module.k3s-server]
  source     = "./modules/k3s-agent"
  agents     = var.nodes.agents
}

module "helm" {
  depends_on = [module.initialize, module.k3s-server]
  source     = "./modules/helm"
  server     = var.nodes.server
}
