resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "longhorn-system"
  }
}

resource "helm_release" "longhorn" {
  depends_on = [kubernetes_namespace.namespace]
  name       = "longhorn"
  namespace  = kubernetes_namespace.namespace.metadata[0].name
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"

  set {
    name  = "defaultSettings.deletingConfirmationFlag"
    value = "true"
  }

  set {
    name  = "defaultSettings.defaultDataPath"
    value = "/var/lib/longhorn"
  }

  set {
    name  = "persistence.defaultClass"
    value = "true"
  }

  set {
    name  = "persistence.defaultFsType"
    value = "ext4"
  }

  wait = true
}
