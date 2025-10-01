FROM mariadb:lts
ADD ./init-scripts/00-demo-init.sh /docker-entrypoint-initdb.d/
ENV MYSQL_ROOT_PASSWORD="toor"
EXPOSE 3306