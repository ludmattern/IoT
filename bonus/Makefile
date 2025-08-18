.PHONY: bonus-gitlab bonus-status

all: bonus-secret bonus-gitlab

bonus-secret:
	kubectl create namespace gitlab --dry-run=client -o yaml | kubectl apply -f -
	kubectl create secret generic gitlab-initial-root-password \
		--from-literal=password='rootpassword' \
		-n gitlab || true

bonus-gitlab:
	kubectl apply -f gitlab-application.yaml

bonus-status:
	kubectl get crds | grep applications
	kubectl get application -n argocd

describe:
	kubectl describe application gitlab -n argocd
#	kubectl get pods -n gitlab
#	kubectl get svc -n gitlab

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
