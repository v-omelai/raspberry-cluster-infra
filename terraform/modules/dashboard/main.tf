# resource "dashboard" "namespace" {
#   metadata {
#     name = "kubernetes-dashboard"
#   }
# }
#
# resource "kubernetes_secret_v1" "admin" {
#   depends_on = [kubernetes_namespace.namespace]
#   type       = "kubernetes.io/service-account-token"
#   metadata {
#     name      = "admin-user-token"
#     namespace = kubernetes_namespace.namespace.metadata[0].name
#     annotations = {
#       "kubernetes.io/service-account.name" = "admin"
#     }
#   }
# }
#
# resource "kubernetes_cluster_role_binding_v1" "admin-user" {
#   metadata {
#     name = "admin-user"
#   }
#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = "cluster-admin"
#   }
#   subject {
#     kind      = "ServiceAccount"
#     name      = "admin-user"
#     namespace = var.kubernetes-dashboard-name
#   }
#   depends_on = [
#     kubernetes_namespace_v1.kubernetes-dashboard,
#     kubernetes_service_account_v1.admin-user
#   ]
# }
#
# resource "helm_release" "dashboard" {
#   depends_on = [kubernetes_namespace.namespace]
#   name       = "kubernetes-dashboard"
#   repository = "https://kubernetes.github.io/dashboard/"
#   chart      = "kubernetes-dashboard"
#   namespace  = kubernetes_namespace.namespace.metadata[0].name
#
#   set {
#     name  = "service.type"
#     value = "LoadBalancer"
#   }
#
#   set {
#     name  = "service.externalPort"
#     value = "9080"
#   }
#
#   set {
#     name  = "rbac.clusterReadOnlyRole"
#     value = "true"
#   }
#
#   set {
#     name  = "metricsScraper.enabled"
#     value = "true"
#   }
#
#   wait = true
# }
