NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml
USER_LOGIN = tomas
DATA_PATH = /home/$(USER_LOGIN)/data

all: up

up: create_dirs
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

create_dirs:
	@mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress 2>/dev/null || (sudo mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress && sudo chmod -R 777 $(DATA_PATH))

clean:
	$(COMPOSE) down -v --rmi all

fclean: clean
	@docker system prune -a --volumes -f
	@sudo rm -rf $(DATA_PATH)/mariadb/* 2>/dev/null || true
	@sudo rm -rf $(DATA_PATH)/wordpress/* 2>/dev/null || true

re: fclean all

.PHONY: all up down start stop creat_dirs clean fclean re