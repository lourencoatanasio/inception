
up:
	mkdir -p /home/ldiogo/data/mysql
	mkdir -p /home/ldiogo/data/wordpress
	docker-compose -f ./srcs/docker-compose.yml up --build

re :
	mkdir -p /home/ldiogo/data/mysql
	mkdir -p /home/ldiogo/data/wordpress
	docker-compose -f ./srcs/docker-compose.yml down --volumes --remove-orphans
	docker-compose -f ./srcs/docker-compose.yml up --build
fclean:
	docker-compose -f ./srcs/docker-compose.yml down --rmi all --volumes --remove-orphans
	docker system prune -f
	sudo rm -rf /home/ldiogo/data
