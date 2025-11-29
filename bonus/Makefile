.PHONY: clean describe gitlab all install migrate

all:
	bash scripts/config_gitlab.sh

describe:
	sudo watch kubectl get pods -n gitlab

gitlab:
	bash scripts/access_gitlab.sh

install:
	bash scripts/install.sh

migrate:
	sudo kubectl apply -f confs/argocd/app.yaml

clean:
	sudo kubectl delete namespace gitlab || true
	sudo fuser -k 8080/tcp
