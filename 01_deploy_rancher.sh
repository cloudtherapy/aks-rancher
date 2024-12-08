. ./environment

az group create --name rg-${APP} --location ${LOCATION}

az aks create \
  --resource-group rg-${APP} \
  --name ${APP}-aks-cluster \
  --kubernetes-version ${VERSION} \
  --node-count ${NODE_COUNT} \
  --node-vm-size $VM_SIZE

  az aks get-credentials --resource-group rg-${APP} --name ${APP}-aks-cluster --overwrite-existing 