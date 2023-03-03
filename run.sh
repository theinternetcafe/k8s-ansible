#!/bin/bash
ANSIBLE_ROLES_PATH=./roles ansible-playbook ${@:1}
