.DEFAULT_GOAL := maak.mk
SHELL=/bin/bash -o pipefail
COMPONENTS := basic multi-container
CONTAINERS := basic multi-container.php-fpm multi-container.nginx
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

basic/Dockerfile.built: basic/Dockerfile $(shell find basic -type f | grep -v 'Dockerfile.*.built\|Dockerfile.*.pushed\|Dockerfile.*.log' | grep 'basic/Dockerfile\|.*')
	docker build -t qbmake/basic basic -f basic/Dockerfile | tee basic/Dockerfile.log
	touch basic/Dockerfile.built

basic.image: basic/Dockerfile.built

# Shuts the component down
basic.down:
	docker-compose stop basic

# Wakes the component up
basic.up: basic.image
	docker-compose up -d --force-recreate basic

# Wakes the component up using the last known image
basic.on:
	docker-compose up -d basic

# Alias for down
basic.off:
	docker-compose stop basic

basic.restart:
	docker-compose stop basic
	docker-compose up -d basic

# Show logs in --follow mode for the component
basic.logs:
	docker-compose logs -f basic

# Opens a bash shell on the component
basic.bash:
	docker-compose exec basic bash

# Removes every compilation/docker assets for the component
basic.clean:
	rm -rf basic/Dockerfile.log basic/Dockerfile.pushed basic/Dockerfile.built

# Pushes the image to the private repository
basic/Dockerfile.pushed: basic/Dockerfile.built
	@if [ -z "$(DOCKER_REGISTRY)" ]; then \
		echo "No private registry defined, ignoring. (set DOCKER_REGISTRY or place it in .env file)"; \
		return 1; \
	fi
	docker tag qbmake/basic $(DOCKER_REGISTRY)/qbmake/basic:$(DOCKER_TAG)
	docker push $(DOCKER_REGISTRY)/qbmake/basic:$(DOCKER_TAG) | tee -a basic/Dockerfile.log
	touch basic/Dockerfile.pushed

basic.push: basic/Dockerfile.pushed

multi-container/Dockerfile.php-fpm.built: multi-container/Dockerfile.php-fpm $(shell find multi-container -type f | grep -v 'Dockerfile.*.built\|Dockerfile.*.pushed\|Dockerfile.*.log' | grep 'multi-container/Dockerfile.php-fpm\|.*')
	docker build -t qbmake/multi-container.php-fpm multi-container -f multi-container/Dockerfile.php-fpm | tee multi-container/Dockerfile.php-fpm.log
	touch multi-container/Dockerfile.php-fpm.built

multi-container.php-fpm.image: multi-container/Dockerfile.php-fpm.built

# Shuts the component down
multi-container.php-fpm.down:
	docker-compose stop multi-container.php-fpm

# Wakes the component up
multi-container.php-fpm.up: multi-container.php-fpm.image
	docker-compose up -d --force-recreate multi-container.php-fpm

# Wakes the component up using the last known image
multi-container.php-fpm.on:
	docker-compose up -d multi-container.php-fpm

# Alias for down
multi-container.php-fpm.off:
	docker-compose stop multi-container.php-fpm

multi-container.php-fpm.restart:
	docker-compose stop multi-container.php-fpm
	docker-compose up -d multi-container.php-fpm

# Show logs in --follow mode for the component
multi-container.php-fpm.logs:
	docker-compose logs -f multi-container.php-fpm

# Opens a bash shell on the component
multi-container.php-fpm.bash:
	docker-compose exec multi-container.php-fpm bash

# Removes every compilation/docker assets for the component
multi-container.php-fpm.clean:
	rm -rf multi-container/Dockerfile.php-fpm.log multi-container/Dockerfile.php-fpm.pushed multi-container/Dockerfile.php-fpm.built

# Pushes the image to the private repository
multi-container/Dockerfile.php-fpm.pushed: multi-container/Dockerfile.php-fpm.built
	@if [ -z "$(DOCKER_REGISTRY)" ]; then \
		echo "No private registry defined, ignoring. (set DOCKER_REGISTRY or place it in .env file)"; \
		return 1; \
	fi
	docker tag qbmake/multi-container.php-fpm $(DOCKER_REGISTRY)/qbmake/multi-container.php-fpm:$(DOCKER_TAG)
	docker push $(DOCKER_REGISTRY)/qbmake/multi-container.php-fpm:$(DOCKER_TAG) | tee -a multi-container/Dockerfile.php-fpm.log
	touch multi-container/Dockerfile.php-fpm.pushed

multi-container.php-fpm.push: multi-container.php-fpm/Dockerfile.pushed

multi-container/Dockerfile.nginx.built: multi-container/Dockerfile.nginx $(shell find multi-container -type f | grep -v 'Dockerfile.*.built\|Dockerfile.*.pushed\|Dockerfile.*.log' | grep 'multi-container/Dockerfile.nginx\|.*')
	docker build -t qbmake/multi-container.nginx multi-container -f multi-container/Dockerfile.nginx | tee multi-container/Dockerfile.nginx.log
	touch multi-container/Dockerfile.nginx.built

multi-container.nginx.image: multi-container/Dockerfile.nginx.built

# Shuts the component down
multi-container.nginx.down:
	docker-compose stop multi-container.nginx

# Wakes the component up
multi-container.nginx.up: multi-container.nginx.image
	docker-compose up -d --force-recreate multi-container.nginx

# Wakes the component up using the last known image
multi-container.nginx.on:
	docker-compose up -d multi-container.nginx

# Alias for down
multi-container.nginx.off:
	docker-compose stop multi-container.nginx

multi-container.nginx.restart:
	docker-compose stop multi-container.nginx
	docker-compose up -d multi-container.nginx

# Show logs in --follow mode for the component
multi-container.nginx.logs:
	docker-compose logs -f multi-container.nginx

# Opens a bash shell on the component
multi-container.nginx.bash:
	docker-compose exec multi-container.nginx bash

# Removes every compilation/docker assets for the component
multi-container.nginx.clean:
	rm -rf multi-container/Dockerfile.nginx.log multi-container/Dockerfile.nginx.pushed multi-container/Dockerfile.nginx.built

# Pushes the image to the private repository
multi-container/Dockerfile.nginx.pushed: multi-container/Dockerfile.nginx.built
	@if [ -z "$(DOCKER_REGISTRY)" ]; then \
		echo "No private registry defined, ignoring. (set DOCKER_REGISTRY or place it in .env file)"; \
		return 1; \
	fi
	docker tag qbmake/multi-container.nginx $(DOCKER_REGISTRY)/qbmake/multi-container.nginx:$(DOCKER_TAG)
	docker push $(DOCKER_REGISTRY)/qbmake/multi-container.nginx:$(DOCKER_TAG) | tee -a multi-container/Dockerfile.nginx.log
	touch multi-container/Dockerfile.nginx.pushed

multi-container.nginx.push: multi-container.nginx/Dockerfile.pushed

