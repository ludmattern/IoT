.PHONY: bonus-tls bonus-secret bonus-gitlab bonus-status all clean install argocd deploy push-repo generate-token create-project

all: install bonus describe

install:
	bash install.sh

bonus:
	kubectl create namespace gitlab --dry-run=client -o yaml | kubectl apply -f -
	kubectl create secret tls gitlab-tls-cert -n gitlab --cert=gitlab.qroyo.com.pem --key=gitlab.qroyo.com-key.pem
	kubectl apply -f gitlab-application.yaml

bonus-status:
	kubectl get crds | grep applications
	kubectl get application -n argocd

describe:
	watch kubectl get pods -n gitlab

argocd:
	@echo "ArgoCD accessible at : https://localhost:30080"
	@echo -n "Login: admin\npassword: "
	@kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
	@echo ""

gitlab:
	@kubectl port-forward svc/traefik -n kube-system 8443:443 > /dev/null 2>&1 &
	@echo "Gitlab accessible at : https://gitlab.qroyo.com:8443"
	@echo -n "Login: root\npassword: "
	@kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 -d
	@echo ""

clean:
	# Supprimer l'app ArgoCD AVANT de supprimer le namespace
	kubectl delete application gitlab -n argocd --ignore-not-found=true
	kubectl patch application gitlab -n argocd --type merge -p '{"metadata":{"finalizers":null}}' || true
	
	# Attendre un peu que ArgoCD arrête d'essayer
	sleep 10
	
	# Supprimer le namespace
	kubectl delete namespace gitlab --ignore-not-found=true --timeout=60s || \
	kubectl patch namespace gitlab --type merge -p '{"spec":{"finalizers":null}}' || true
	

	# Attendre que le namespace soit supprimé
	while kubectl get namespace gitlab >/dev/null 2>&1; do echo "Waiting for namespace to be deleted..."; sleep 5; done
	echo "Namespace deleted successfully"
	
	k3d cluster delete iot-cluster

	@PORT_PID=$$(sudo lsof -ti :8443) && \
	if [ -n "$$PORT_PID" ]; then \
		echo "Killing process using port 8443 (PID=$$PORT_PID)"; \
		sudo kill -9 $$PORT_PID; \
	else \
		echo "Port 8443 is free"; \
	fi || true
