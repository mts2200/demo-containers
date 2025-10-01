FROM postgres:latest
ADD ./init-scripts/00-demo-init.sh /docker-entrypoint-initdb.d/
ENV POSTGRES_USER="root"
ENV POSTGRES_PASSWORD="toor"
EXPOSE 5432