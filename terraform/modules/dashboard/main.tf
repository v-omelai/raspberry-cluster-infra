resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "kubernetes-dashboard"
  }
}

resource "kubernetes_service_account_v1" "user" {
  depends_on = [kubernetes_namespace.namespace]
  metadata {
    name      = "admin-user"
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }
}

resource "kubernetes_secret_v1" "token" {
  depends_on = [kubernetes_namespace.namespace, kubernetes_service_account_v1.user]
  type       = "kubernetes.io/service-account-token"
  metadata {
    name      = "admin-user-token"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.user.metadata[0].name
    }
  }
}

resource "kubernetes_cluster_role_binding_v1" "role" {
  depends_on = [kubernetes_namespace.namespace, kubernetes_service_account_v1.user]
  metadata {
    name = "admin-user"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.user.metadata[0].name
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }
}

resource "helm_release" "kubernetes_dashboard" {
  depends_on = [kubernetes_namespace.namespace]
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  namespace  = kubernetes_namespace.namespace.metadata[0].name
  wait       = true
}
