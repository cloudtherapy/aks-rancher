. ./environment

echo "Adding helm repo for Rancher"
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

echo "Create the appropriate namespace"
kubectl create namespace cattle-system

echo "Deploying Rancher"
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set bootstrapPassword=admin