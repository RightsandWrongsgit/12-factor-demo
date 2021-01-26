SHELL := /usr/bin/env bash

####################
## Stack Commands ##
####################

PHONY += setup
setup: bundle-install pull-images pull-dependencies

setup-build: rebuild pull-dependencies

rebuild: bundle-install build

bundle-install:
	bundle install --path .bundle/gems

PHONY += start
start:
	bundle exec docker-sync-stack start

start-services:
	docker-compose -f docker-compose.yml -f docker-compose-dev.yml up

start-sync:
	bundle exec docker-sync start --foreground

PHONY += clean
clean:
	bundle exec docker-sync-stack clean

pull-images:
	docker-compose pull

push-images:
	docker-compose push

pull-dependencies:

build:
	docker-compose build

#########################
## Individual Commands ##
#########################

PHONY += standard_load

standard_load:
	rm src/.keep
	composer create-project drupal/recommended-project:8.9.11 src

PHONY += standard_install

standard_install:
	mv yoursite src/web/profiles
	cp src/web/sites/default/default.settings.php src/web/sites/default/settings.php
	chmod 666 src/web/sites/default/settings.php
	mkdir src/web/sites/default/files
	chmod 777 src/web/sites/default/files



# PHONY += special_load

# special_load:
#   composer create-project --no-install drupal/recommended-project:8.9.11 src

# PHONY += special_install
#   composer intall
# NOTE AFTER USER PLACES THEIR OR OUR SUPPLIED CUSTOM 
# COMPOSER.JSON &/or COMPOSER.LOCK files in the correct
# directory and they have edited any credentials in the
# quickstart.settings.php file or the .env file we ultimately
# provide, then the various directory, file moves/creates/
# permissions need to be added. 
# May need to add cd src, mkdir config, chmod 777 config to 
# handle some existing site moves.



.PHONY: $(PHONY)
