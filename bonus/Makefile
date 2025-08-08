.PHONY: bonus-namespace bonus-gitlab bonus-status

all: bonus-namespace bonus-gitlab

bonus-namespace:
	kubectl apply -f gitlab-namespace.yaml

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
	kubectl delete namespace gitlab
	kubectl delete application gitlab -n argocd