FROM ubuntu:20.04

WORKDIR /root

# instalar paquetes
RUN apt-get update && apt-get install -y openssh-server openjdk-8-jdk wget

# instalar hadoop3
RUN wget http://apache.rediris.es/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz && \
    tar -xzvf hadoop-3.3.0.tar.gz  && \
    mv hadoop-3.3.0 /usr/local/hadoop && \
    rm hadoop-3.3.0.tar.gz 

# inciar variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 

# generar clave ssh
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# gestion basica
RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

# mover ficheros al contenedor
COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/user_permision.sh ~/user_permision.sh

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# formatear el namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]

# abrir puertos
EXPOSE 9000 50010 50020 50070 50075 50090
EXPOSE 9871 9870 9820 9869 9868 9867 9866 9865 9864

EXPOSE 19888

EXPOSE 8030 8031 8032 8033 8040 8042 8088 8188

EXPOSE 49707 2122
