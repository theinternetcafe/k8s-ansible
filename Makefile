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

VAGRANT_PROJECT_ROOT := $(shell pwd)
VAGRANTFILE := $(VAGRANT_PROJECT_ROOT)/Vagrantfile

# Check that we are in the project root
.PHONY: check-project-root
check-project-root:
ifeq ($(wildcard $(VAGRANTFILE)),)
	@echo "This script must be run from the project root"
	@exit 1
endif

# Check that Vagrant is installed
.PHONY: check-vagrant
check-vagrant:
ifeq ($(shell which vagrant),)
	@echo "Vagrant is not installed"
	@echo "  Install Vagrant from https://www.vagrantup.com/downloads.html"
	@exit 1
endif

# Check that the appropriate virtualization software is installed
.PHONY: check-virtualization-software
check-virtualization-software:
ifeq ($(shell uname -s),MINGW64_NT-10.0)
	@if [ ! -x "$$(which virtualbox)" ]; then \
		echo "VirtualBox is not installed"; \
		echo "  Install VirtualBox from https://www.virtualbox.org/wiki/Downloads"; \
		exit 1; \
	fi;
else ifeq ($(shell uname -s),Darwin)
	@if [ ! -d "/Applications/Parallels Desktop.app" ]; then \
		echo "Parallels Desktop is not installed"; \
		echo "  Install Parallels Desktop from https://www.parallels.com/products/desktop/"; \
		exit 1; \
	fi;
else
	ifeq ($(shell which qemu-kvm),)
		@echo "QEMU/KVM is not installed"
		@echo "  Install QEMU/KVM from your package manager"
		@exit 1
	endif
endif

# Check that no boxes are already running
.PHONY: check-no-boxes-running
check-no-boxes-running:
ifneq ($(shell vagrant status | grep "running"),)
	@echo "One or more boxes are already running"
	@echo "  Run 'make destroy-all-boxes' to destroy all boxes"
	@exit 1
endif

# Start the vagrant staging environment
.PHONY: start-staging-environment
start-staging-environment: check-project-root check-vagrant check-virtualization-software
	@vagrant up --provision

# Stop and destroy all running boxes
.PHONY: destroy-all-boxes
destroy-all-boxes:
	vagrant destroy -f
