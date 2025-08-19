.PHONY: bonus-tls bonus-secret bonus-gitlab bonus-status all clean

all: bonus-tls bonus-secret bonus-gitlab

bonus-tls:
	kubectl create namespace gitlab --dry-run=client -o yaml | kubectl apply -f -
	kubectl create secret tls gitlab-tls-cert -n gitlab --cert=gitlab.qroyo.com.pem --key=gitlab.qroyo.com-key.pem

bonus-secret:
	kubectl create namespace gitlab --dry-run=client -o yaml | kubectl apply -f -
	kubectl -n gitlab delete secret gitlab-initial-root-password --ignore-not-found=true
	kubectl create secret generic gitlab-initial-root-password \
		--from-literal=password='rootpassword' \
		-n gitlab || true

bonus-gitlab:
	kubectl apply -f gitlab-application.yaml

bonus-status:
	kubectl get crds | grep applications
	kubectl get application -n argocd

describe:
	watch kubectl get pods -n gitlab

argocd:
	@kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &
	@echo "ArgoCD accessible at : https://localhost:8080"
	@echo -n "Login: admin, password: "
	@kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

gitlab:
	@kubectl port-forward svc/traefik -n kube-system 8443:443
	@echo "Gitlab accessible at : https://gitlab.qroyo.com:8443"
	@echo -n "Login: root, password: rootpassword"

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
