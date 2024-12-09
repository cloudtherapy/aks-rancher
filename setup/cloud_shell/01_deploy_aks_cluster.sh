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