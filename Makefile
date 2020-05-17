.PHONY: help

SHELL = /bin/bash

NODE_USER_ID ?= $(shell id -u)
NODE_USER_NAME ?= $(shell id -un)
NODE_GROUP_ID ?= $(shell id -g)
NODE_GROUP_NAME ?= $(shell id -gn)

DOCKER_TAG ?= hgdeoro/docker-nodejs-environment

DOCKER_RUN_INTERACTIVE := $(shell [ -t 0 ] && echo "-ti")
DOCKER_NETWORK ?= --network host

NODE_VERSION ?= 14.2.0-stretch

# Directory that will be mounted on docker
WORKDIR ?= $(PWD)

INITIAL_PATH := /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

help:
	@echo "See the sources"

build:
	docker build . -t $(DOCKER_TAG) \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		--build-arg NODE_USER_NAME=$(NODE_USER_NAME) \
		--build-arg NODE_USER_ID=$(NODE_USER_ID) \
		--build-arg NODE_GROUP_NAME=$(NODE_GROUP_NAME) \
		--build-arg NODE_GROUP_ID=$(NODE_GROUP_ID)

run:
	docker run \
		--init \
		--rm $(DOCKER_RUN_INTERACTIVE) \
		$(DOCKER_NETWORK) \
		--mount type=bind,source=$(WORKDIR),target=$(WORKDIR) \
		--mount type=bind,source=$${HOME}/.npm,target=$(WORKDIR)/.npm \
		--workdir $(WORKDIR) \
		-e HOME=$(WORKDIR) \
		-e PATH=$(INITIAL_PATH):$(WORKDIR)/node_modules/.bin \
		$(DOCKER_TAG) \
		$(COMMAND_AND_ARGS)
