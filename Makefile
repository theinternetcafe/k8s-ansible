.PHONY: build-amd64 build-arm64 build-all push-amd64 push-arm64 push-all all

IMAGE_NAME = docker.io/tzakrajs/ansible-runner
VERSION = 2.20.0

build-amd64:
	docker build --platform linux/amd64 -t $(IMAGE_NAME)-amd64:$(VERSION) .

build-arm64:
	docker build --platform linux/arm64 -t $(IMAGE_NAME)-arm64:$(VERSION) .

build-all: build-amd64 build-arm64

push-amd64:
	docker push $(IMAGE_NAME)-amd64:$(VERSION)

push-arm64:
	docker push $(IMAGE_NAME)-arm64:$(VERSION)

push-all: push-amd64 push-arm64

all: build-all push-all
