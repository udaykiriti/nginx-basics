FROM nginx:latest

RUN apt-get update && apt-get install -y python3

RUN mkdir -p /app/scripts /app/html /app/conf

COPY html /usr/share/nginx/html
COPY conf/nginx-docker.conf /etc/nginx/nginx.conf
COPY conf/.htpasswd /etc/nginx/.htpasswd
COPY scripts/backend.py /app/scripts/backend.py

COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
