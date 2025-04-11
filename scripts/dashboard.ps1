cd ..
$env:KUBECONFIG="$PWD\.server\config"
$base64Token = kubectl -n kubernetes-dashboard get secret admin-user-token -o jsonpath="{.data.token}"
$decodedToken = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64Token))
$decodedToken
kubectl -n kubernetes-dashboard delete pod -l app=kubernetes-dashboard-kong
kubectl -n kubernetes-dashboard wait --for=condition=Ready pod -l app=kubernetes-dashboard-kong --timeout=60s
Start-Process "https://localhost:8443"
kubectl -n kubernetes-dashboard port-forward --address 0.0.0.0 svc/kubernetes-dashboard-kong-proxy 8443:443
