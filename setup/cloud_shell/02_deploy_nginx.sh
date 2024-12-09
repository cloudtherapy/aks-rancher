. ./environment

echo "Adding helm repo for ingress-nginx and running update"
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

sleep 10

echo "Get the Public IP address"
kubectl get service ingress-nginx-controller --namespace=ingress-nginx

echo "Set External IP address from Loadbalancer"

IP_ADDRESS=`kubectl get services --namespace ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

export IP_ADDRESS