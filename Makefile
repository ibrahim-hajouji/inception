all : up

up :
	@docker-compose -f ./srcs/docker-compose.yml up -d --build
	@echo -e "\033[32mAll containers have been built and started.\033[0m"

down :
	@docker-compose -f ./srcs/docker-compose.yml down
	@echo -e "\033[32mAll containers have been removed.\033[0m"

stop :
	@docker-compose -f ./srcs/docker-compose.yml stop
	@echo -e "\033[32mAll containers have been stopped.\033[0m"

start :
	@docker-compose -f ./srcs/docker-compose.yml start
	@echo -e "\033[32mAll containers have been started.\033[0m"

status :
	@echo -e "\033[34mListing running containers:\033[0m"
	@docker ps

re : down up
	@echo -e "\033[32mAll containers have been rebuilt and started.\033[0m"

.PHONY: all up down stop start status re
