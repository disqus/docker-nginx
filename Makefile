all:
	docker build --rm -t docker-nginx . && docker run --privileged --rm -it docker-nginx

.PHONY: all
