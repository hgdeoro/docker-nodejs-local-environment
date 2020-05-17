# Docker image for nodejs local environment

1. Clone the repo
2. Build the image `make build`
3. `cd` to your nodejs project
4. Call `exec.sh` to run nodejs in the Docker container

The `exec.sh` script calls the `run` target (see the `Makefile` for datails):

    run:
    	docker run \
    		--init \
    		--rm \
            $(DOCKER_RUN_INTERACTIVE) \
    		$(DOCKER_NETWORK) \
    		--mount type=bind,source=$(WORKDIR),target=$(WORKDIR) \
    		--mount type=bind,source=$${HOME}/.npm,target=$(WORKDIR)/.npm \
    		--workdir $(WORKDIR) \
    		-e HOME=$(WORKDIR) \
    		-e PATH=$(INITIAL_PATH):$(WORKDIR)/node_modules/.bin \
    		$(DOCKER_TAG) \
    		$(COMMAND_AND_ARGS)


By default, the `run` target will:

* `--init` make sure Ctrl+C works
* `$(DOCKER_NETWORK)` defaults to `--network host`
* `--mount` bind-mount `${HOME}/.npm` to cache downloads
* `--mount` bind-mount your current directory in the host, to the same directory
  within the container and set `--workdir` and `HOME` to the same directory
* `-e PATH` will add `node_modules/.bin` to your `PATH`

The `exec.sh` exist mainly to pass the arguments to `make`.


## Examples

To open a `bash` shell:

    /path/to/exec.sh

To execute something inside the container:

    /path/to/exec.sh npm install @vue/cli

# Limitations

* `npm install -g` won't work
