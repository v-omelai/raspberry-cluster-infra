$env:KUBECONFIG="$PWD\.server\config"
$base64Token = kubectl -n kubernetes-dashboard get secret admin-user-token -o jsonpath="{.data.token}"
$decodedToken = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64Token))
$decodedToken
Start-Process "https://localhost:8443"
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
