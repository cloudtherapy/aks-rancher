. ./environment

# Add the Jetstack Helm repository
echo "Adding jetstack repo and update"
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
echo "Installing cert-manager"
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true