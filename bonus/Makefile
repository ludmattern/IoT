.PHONY: clean describe gitlab all install migrate

all:
	bash script.sh

describe:
	sudo watch kubectl get pods -n gitlab

gitlab:
	bash access_gitlab.sh

install:
	bash install.sh

migrate:
	sudo kubectl apply -f ./argocd/app.yaml

clean:
	sudo kubectl delete namespace gitlab || true
	sudo fuser -k 8080/tcp
