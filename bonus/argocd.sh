kubectl port-forward svc/argocd-server -n argocd 8080:443
kubectl get secret gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode ; echo