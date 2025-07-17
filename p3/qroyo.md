En gros, la première fois que tu make, décommente l’installation de Docker, ensuite recommente

L’installation est un peu longue, c’est normal

Une fois fini tu peux aller sur http://localhost:8888

Pour te connecter, le username c’est admin et le mot de passe tu l’as en faisant la commande :

kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d && echo

Ensuite, j’ai un repo sur mon Git, c’est la partie.
Et dans deployment.yaml, si tu changes v1 pour v2, la sync se fait toute seule, sans rien faire
Ça prend 2–3 minutes à être détecté

Je peux t’ajouter au repo ou tu recrées le même repo et tu le changes dans app.yaml

Force pour les bonus