FROM zhiqiangvip/docker-ubuntu1404-163
MAINTAINER mysql qiang <zhiqiangvip999@gmail.com>

# Add MySQL configuration
COPY my.cnf /etc/mysql/conf.d/my.cnf
COPY mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

RUN mkdir -p /data && rm -fr /var/lib/mysql && ln -s /data /var/lib/mysql

RUN apt-get update && \
    apt-get -yq install mysql-server-5.5 pwgen && \
    rm -rf /var/lib/apt/lists/* && \
    rm /etc/mysql/conf.d/mysqld_safe_syslog.cnf && \
    if [ ! -f /usr/share/mysql/my-default.cnf ] ; then cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf; fi && \
    mysql_install_db > /dev/null 2>&1 && \
    touch /var/lib/mysql/.EMPTY_DB

# Add MySQL scripts
COPY import_sql.sh /import_sql.sh
COPY run.sh /run.sh
RUN chmod 755 /run.sh

ENV MYSQL_USER=admin \
    MYSQL_PASS=**Random** \
    ON_CREATE_DB=**False** \
    REPLICATION_MASTER=**False** \
    REPLICATION_SLAVE=**False** \
    REPLICATION_USER=replica \
    REPLICATION_PASS=replica \
    ON_CREATE_DB=**False**

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql"]

EXPOSE 3306
CMD ["/run.sh"]
