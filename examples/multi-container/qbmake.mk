.DEFAULT_GOAL := qbmake.mk
SHELL=/bin/bash -o pipefail
COMPONENTS := 0 1
CONTAINERS := 0.0 1.0 1.1
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

0/Dockerfile.0.built: 0/Dockerfile.0 $(shell find 0 -type f | grep -v 'Dockerfile.*.built\|Dockerfile.*.pushed\|Dockerfile.*.log' | grep '0/Dockerfile.0\|.*')
	docker build -t qbmake/0.0 0 -f 0/Dockerfile.0 | tee 0/Dockerfile.0.log
	touch 0/Dockerfile.0.built

0.0.image: 0/Dockerfile.0.built

# Shuts the component down
0.0.down:
	docker-compose stop 0.0

# Wakes the component up
0.0.up: 0.0.image
	docker-compose up -d --force-recreate 0.0

# Wakes the component up using the last known image
0.0.on:
	docker-compose up -d 0.0

# Alias for down
0.0.off:
	docker-compose stop 0.0

0.0.restart:
	docker-compose stop 0.0
	docker-compose up -d 0.0

# Show logs in --follow mode for the component
0.0.logs:
	docker-compose logs -f 0.0

# Opens a bash shell on the component
0.0.bash:
	docker-compose exec 0.0 bash

# Removes every compilation/docker assets for the component
0.0.clean:
	rm -rf 0/Dockerfile.0.log 0/Dockerfile.0.pushed 0/Dockerfile.0.built

# Pushes the image to the private repository
0/Dockerfile.0.pushed: 0/Dockerfile.0.built
	@if [ -z "$(DOCKER_REGISTRY)" ]; then \
		echo "No private registry defined, ignoring. (set DOCKER_REGISTRY or place it in .env file)"; \
		return 1; \
	fi
	docker tag qbmake/0.0 $(DOCKER_REGISTRY)/qbmake/0.0:$(DOCKER_TAG)
	docker push $(DOCKER_REGISTRY)/qbmake/0.0:$(DOCKER_TAG) | tee -a 0/Dockerfile.0.log
	touch 0/Dockerfile.0.pushed

0.0.push: 0.0/Dockerfile.pushed

1/Dockerfile.0.built: 1/Dockerfile.0 $(shell find 1 -type f | grep -v 'Dockerfile.*.built\|Dockerfile.*.pushed\|Dockerfile.*.log' | grep '1/Dockerfile.0\|.*')
	docker build -t qbmake/1.0 1 -f 1/Dockerfile.0 | tee 1/Dockerfile.0.log
	touch 1/Dockerfile.0.built

1.0.image: 1/Dockerfile.0.built

# Shuts the component down
1.0.down:
	docker-compose stop 1.0

# Wakes the component up
1.0.up: 1.0.image
	docker-compose up -d --force-recreate 1.0

# Wakes the component up using the last known image
1.0.on:
	docker-compose up -d 1.0

# Alias for down
1.0.off:
	docker-compose stop 1.0

1.0.restart:
	docker-compose stop 1.0
	docker-compose up -d 1.0

# Show logs in --follow mode for the component
1.0.logs:
	docker-compose logs -f 1.0

# Opens a bash shell on the component
1.0.bash:
	docker-compose exec 1.0 bash

# Removes every compilation/docker assets for the component
1.0.clean:
	rm -rf 1/Dockerfile.0.log 1/Dockerfile.0.pushed 1/Dockerfile.0.built

# Pushes the image to the private repository
1/Dockerfile.0.pushed: 1/Dockerfile.0.built
	@if [ -z "$(DOCKER_REGISTRY)" ]; then \
		echo "No private registry defined, ignoring. (set DOCKER_REGISTRY or place it in .env file)"; \
		return 1; \
	fi
	docker tag qbmake/1.0 $(DOCKER_REGISTRY)/qbmake/1.0:$(DOCKER_TAG)
	docker push $(DOCKER_REGISTRY)/qbmake/1.0:$(DOCKER_TAG) | tee -a 1/Dockerfile.0.log
	touch 1/Dockerfile.0.pushed

1.0.push: 1.0/Dockerfile.pushed

1/Dockerfile.1.built: 1/Dockerfile.1 $(shell find 1 -type f | grep -v 'Dockerfile.*.built\|Dockerfile.*.pushed\|Dockerfile.*.log' | grep '1/Dockerfile.1\|.*')
	docker build -t qbmake/1.1 1 -f 1/Dockerfile.1 | tee 1/Dockerfile.1.log
	touch 1/Dockerfile.1.built

1.1.image: 1/Dockerfile.1.built

# Shuts the component down
1.1.down:
	docker-compose stop 1.1

# Wakes the component up
1.1.up: 1.1.image
	docker-compose up -d --force-recreate 1.1

# Wakes the component up using the last known image
1.1.on:
	docker-compose up -d 1.1

# Alias for down
1.1.off:
	docker-compose stop 1.1

1.1.restart:
	docker-compose stop 1.1
	docker-compose up -d 1.1

# Show logs in --follow mode for the component
1.1.logs:
	docker-compose logs -f 1.1

# Opens a bash shell on the component
1.1.bash:
	docker-compose exec 1.1 bash

# Removes every compilation/docker assets for the component
1.1.clean:
	rm -rf 1/Dockerfile.1.log 1/Dockerfile.1.pushed 1/Dockerfile.1.built

# Pushes the image to the private repository
1/Dockerfile.1.pushed: 1/Dockerfile.1.built
	@if [ -z "$(DOCKER_REGISTRY)" ]; then \
		echo "No private registry defined, ignoring. (set DOCKER_REGISTRY or place it in .env file)"; \
		return 1; \
	fi
	docker tag qbmake/1.1 $(DOCKER_REGISTRY)/qbmake/1.1:$(DOCKER_TAG)
	docker push $(DOCKER_REGISTRY)/qbmake/1.1:$(DOCKER_TAG) | tee -a 1/Dockerfile.1.log
	touch 1/Dockerfile.1.pushed

1.1.push: 1.1/Dockerfile.pushed

