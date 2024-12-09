. ./environment

echo "Adding helm repo for Rancher"
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update

echo "Create the appropriate namespace"
kubectl create namespace cattle-system

echo "Set External IP address from Loadbalancer"
IP_ADDRESS=`kubectl get services --namespace ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`
export IP_ADDRESS

echo "Deploying Rancher"
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set ingress.ingressClassName=nginx \
  --set hostname=rancher.${IP_ADDRESS}.nip.io \
  --set bootstrapPassword=admin