.DEFAULT_GOAL := help

# Used for publishing docker images
GIT_OWNER=oktinaut
GIT_REPOSITORY=kata-github-actions

# Get npm package information
NAME := $(shell node --print --eval "require('./package.json').name.split('/').pop()")
VERSION := $(shell node --print --eval "require('./package.json').version")

#help:	@ 📖 List available tasks on this project
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(MAKEFILE_LIST)| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[36m%-30s\033[0m %s\n\n", $$1, $$2}'

#test: @ ✅ Runs all tests, results are written to the 'reports' folder
test:
	docker build \
	--build-arg NPM_TOKEN=${NPM_TOKEN} \
	--target stage-test \
	-t ${NAME}-test:${VERSION} \
	.
	docker run --volume=$(shell pwd)/reports:/workspace/reports ${NAME}-test:${VERSION}

#build: @ 📦 Builds the service as a Docker image
build:
	docker build \
	--build-arg NPM_TOKEN=${NPM_TOKEN} \
	-t docker.pkg.github.com/${GIT_OWNER}/${GIT_REPOSITORY}/${NAME}:${VERSION} \
	.

#publish: @ ⬆️  Publishes the service's Docker image
publish:
	docker push docker.pkg.github.com/${GIT_OWNER}/${GIT_REPOSITORY}/${NAME}:${VERSION}

#start: @ 🐳 Starts the service as a Docker container
start:
	GIT_OWNER=${GIT_OWNER} \
	GIT_REPOSITORY=${GIT_REPOSITORY} \
	NAME=${NAME} \
	VERSION=${VERSION} \
	docker-compose up
