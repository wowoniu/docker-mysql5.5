all: mysql-5.5

mysql-5.5:
	docker build -t mysql:5.5 .
