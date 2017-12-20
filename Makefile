.PHONY: local.clean \
	local.docker \
	local

define full_stack
	make local.clean
	make local.docker
	docker-compose ps
endef

## Create and start all containers; Fix Permissions; Run Migrations
local:
	@$(call full_stack)

## Create and start one/all containers; Fix Permissions; Optional: [SERVICE]
local.docker:
	docker-compose build
	docker-compose up -d $(SERVICE)

## ssh into docker container
local.ssh:
	docker-compose run web /bin/bash

## Stop and remove one or all containers within scope; Optional: [SERVICE]
local.clean:
	docker-compose down -v $(SERVICE)

# Formatting codes
green = \x1b[32;01m$1\x1b[0m

.PHONY: help

## This help screen
help::
	@printf "\n## $(PACKAGE_NAME) targets:\n\n"
	@awk '/^[a-zA-Z\-\_0-9%\.]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = $$1; \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			gsub("\\\\", "", helpCommand); \
			gsub(":+$$", "", helpCommand); \
			printf "  $(call green,%-35s) %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
