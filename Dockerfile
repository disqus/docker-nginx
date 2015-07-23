FROM jpetazzo/dind

RUN mkdir -p /usr/src/docker-nginx
WORKDIR /usr/src/docker-nginx

COPY . /usr/src/docker-nginx

CMD ["wrapdocker", "/usr/src/docker-nginx/build.sh"]
