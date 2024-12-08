. ./environment

echo "Creating resource group"
az group create --name rg-${APP} --location ${LOCATION}

echo "Creating AKS cluster"
az aks create \
  --resource-group rg-${APP} \
  --name ${APP}-aks-cluster \
  --kubernetes-version ${K8S_VERSION} \
  --node-count ${NODE_COUNT} \
  --node-vm-size $VM_SIZE

echo "Getting credentials and storing them in kubeconfig"
az aks get-credentials --resource-group rg-${APP} --name ${APP}-aks-cluster --overwrite-existing

echo "Adding helm repo for ingress-nginx"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

echo "Install helm chart for ingress-nginx"
helm upgrade --install \
  ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.service.type=LoadBalancer \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
  --set controller.service.externalTrafficPolicy=Local \
  --version ${NGINX_VERSION} \
  --create-namespace

echo "Get the Public IP address"
kubectl get service ingress-nginx-controller --namespace=ingress-nginx

echo "Adding helm repo for Rancher"
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

echo "Create the appropriate namespace"
kubectl create namespace cattle-system

# If you have installed the CRDs manually, instead of setting `installCRDs` or `crds.enabled` to `true` in your Helm install command, you should upgrade your CRD resources before upgrading the Helm chart:
#kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/<VERSION>/cert-manager.crds.yaml

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true

helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set bootstrapPassword=admin