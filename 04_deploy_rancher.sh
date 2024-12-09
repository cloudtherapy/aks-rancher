. ./environment

echo "Adding helm repo for Rancher"
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update

echo "Create the appropriate namespace"
kubectl create namespace cattle-system

echo "Deploying Rancher"
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set ingress.ingressClassName=nginx \
  --set hostname="${IP_ADDRESS}.sslip.io" \
  --set bootstrapPassword=admin