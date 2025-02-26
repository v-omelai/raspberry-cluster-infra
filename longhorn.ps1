$env:KUBECONFIG="$PWD\.server\config"
Start-Process "http://localhost:8080"
kubectl -n longhorn-system port-forward --address 0.0.0.0 svc/longhorn-frontend 8080:80
