.PHONY: clean gitlab all

all:
	bash script.sh

describe:
	sudo watch kubectl get pods -n gitlab

gitlab:
	bash access_gitlab.sh

install:
	bash install.sh

clean:
	sudo kubectl delete namespace gitlab
