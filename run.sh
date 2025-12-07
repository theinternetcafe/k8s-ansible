#!/bin/bash
docker run --rm -it \
  -v $(pwd):/runner \
  -v ~/.ssh:/home/runner/.ssh:ro \
  -e HOME=/home/runner \
  -e ANSIBLE_REMOTE_USER=$(whoami) \
  docker.io/tzakrajs/ansible-runner:2.20.0 \
  ${@:1}
