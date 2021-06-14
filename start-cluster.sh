#!/bin/bash

# creamos el docker base 
docker build -f secondary/Dockerfile -t irm/hadoop-cluster-base:latest secondary

# creamos el nodo master
docker build -f primary/Dockerfile -t irm/hadoop-cluster-master:latest primary


# numeramos y creamos los 3 contenedores
N=${1:-3}

docker network create --driver=bridge hadoop &> /dev/null

# iniciamos los dos datanodes
i=1
while [ $i -lt $N ]
do
	docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                irm/hadoop-cluster-base
	i=$(( $i + 1 ))
done 



# iniciamos el contenedor master
docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
				-p 9000:9000 \
                --name hadoop-master \
                --hostname hadoop-master \
				-v $PWD/data:/data \
                irm/hadoop-cluster-master



# entramos en la consola del nodo master
docker exec -it hadoop-master bash