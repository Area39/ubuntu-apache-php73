PORT?=80

.PHONY: build
build:
	docker build --tag ubuntu_php7.3 .
	docker run --name my_server -d -p $(PORT):80 -v $(CURDIR)/public/:/var/www/Website/ ubuntu_php7.3

.PHONY: up
up:
	docker start my_server

.PHONY: down
down:
	docker stop my_server

.PHONY: ssh
ssh:
	docker exec -it my_server bash

.PHONY: status
status:
	docker ps -f name=my_server

.PHONY: php
php:
	docker-compose build linuxapachephp73

