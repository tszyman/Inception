NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml
USER_LOGIN = tomas
DATA_PATH = /home/$(USER_LOGIN)/data

all: up

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

create_dirs:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress

clean:
	$(COMPOSE) down -v --rmi all

fclean:
	clean
	@docker system prune -a --volumes -f
	@sudo rm -rf $(DATA_PATH)/mariadb
	@sudo rm -rf $(DATA_PATH)/wordpress

re: fclean all

.PHONY: all up down start stop creat_dirs clean fclean re