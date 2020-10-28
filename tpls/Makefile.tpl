.DEFAULT_GOAL := maak.mk
SHELL=/bin/bash -o pipefail
COMPONENTS :={{#components}} {{name}}{{/components}}
CONTAINERS :={{#containers}} {{name}}{{/containers}}
ENV := dev

images: $(addsuffix .image,$(CONTAINERS))

# Cleans all compilation and docker assets of all components.
# Make sure you have some time to rebuild them after that ;-)
#
# An individual .clean task exists on each component as well
clean: $(addsuffix .clean,$(CONTAINERS))

################################################################################
# Generation of the standard rules
#

# In addition to the main rules above, each architectural component at least
# have the following standard rules, which are dynamically defined below:
#
# - component.image: builds the docker image, rebuilding source code if needed
# - component.down:  shuts down the component
# - component.up:    wakes up the component, making sure the last version runs
# - component.on:    wakes up the component, taking the last known image
# - component.clean: cleans everything, only useful for rebuilding from scratch

{{#containers}}
{{{dockerbuilt}}}: {{{dockerfile}}} $(shell find {{{context}}} -type f | grep -v '{{{depsignore}}}' | grep '{{{depsinclude}}}')
	docker build -t {{dockerPrefix}}/{{name}} {{{context}}} -f {{{dockerfile}}} | tee {{{dockerlog}}}
	touch {{{dockerbuilt}}}

{{name}}.image: {{{dockerbuilt}}}

# Shuts the component down
{{name}}.down:
	docker-compose stop {{name}}

# Wakes the component up
{{name}}.up: {{name}}.image
	docker-compose up -d --force-recreate {{name}}

# Wakes the component up using the last known image
{{name}}.on:
	docker-compose up -d {{name}}

# Alias for down
{{name}}.off:
	docker-compose stop {{name}}

{{name}}.restart:
	docker-compose stop {{name}}
	docker-compose up -d {{name}}

# Show logs in --follow mode for the component
{{name}}.logs:
	docker-compose logs -f {{name}}

# Opens a bash shell on the component
{{name}}.bash:
	docker-compose exec {{name}} bash

# Removes every compilation/docker assets for the component
{{name}}.clean:
	rm -rf {{{dockerlog}}} {{{dockerpushed}}} {{{dockerbuilt}}}

# Pushes the image to the private repository
{{{dockerpushed}}}: {{{dockerbuilt}}}
	@if [ -z "$(DOCKER_REGISTRY)" ]; then \
		echo "No private registry defined, ignoring. (set DOCKER_REGISTRY or place it in .env file)"; \
		return 1; \
	fi
	docker tag {{project.name}}/{{name}} $(DOCKER_REGISTRY)/{{project.name}}/{{name}}:$(DOCKER_TAG)
	docker push $(DOCKER_REGISTRY)/{{project.name}}/{{name}}:$(DOCKER_TAG) | tee -a {{{dockerlog}}}
	touch {{{dockerpushed}}}

{{name}}.push: {{name}}/Dockerfile.pushed

{{/containers}}
