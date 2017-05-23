
REPO=dmitryb/mesos-spark
V=2.1.1

docker-build:
	docker build -t $(REPO):$(V) .

docker-push:
	docker push $(REPO):$(V)

docker-pull:
	docker pull $(REPO):$(V)
