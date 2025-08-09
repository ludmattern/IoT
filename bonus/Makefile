.PHONY: bonus-gitlab bonus-status

all: bonus-gitlab

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
#	kubectl delete application gitlab -n argocd --ignore-not-found=true
#	kubectl patch application gitlab -n argocd --type merge -p '{"metadata":{"finalizers":null}}' || true
#	helm uninstall gitlab -n gitlab || true
#	kubectl delete namespace gitlab --ignore-not-found=true
#	kubectl get pv | grep -E "(gitlab|gitaly|postgresql|redis)" | awk '{print $$1}' | xargs -r kubectl delete pv || true
#	sudo sed -i '/local.gitlab.com/d' /etc/hosts || true
#	kubectl delete application gitlab -n argocd
#	kubectl delete jobs --all -n gitlab
#	kubectl delete pods --all -n gitlab --force --grace-period=0
#	kubectl delete namespace gitlab --ignore-not-found=true