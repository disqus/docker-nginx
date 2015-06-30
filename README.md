Supported tags and respective `Dockerfile` links

-   [`python2.7.10`, `python2.7`, `python2` (*python2/full/Dockerfile*)](https://github.com/disqus/docker-nginx/blob/master/python2/full/Dockerfile)
-   [`python2.7.10-onbuild`, `python2.7-onbuild`, `python2-onbuild`, `latest` (*python2/full/onbuild/Dockerfile*)](https://github.com/disqus/docker-nginx/blob/master/python2/full/onbuild/Dockerfile)
-   [`python2.7.10-light`, `python2.7-light`, `python2-light` (*python2/light/Dockerfile*)](https://github.com/disqus/docker-nginx/blob/master/python2/light/Dockerfile)
-   [`python2.7.10-light-onbuild`, `python2.7-light-onbuild`, `python2-light-onbuild` (*python2/light/onbuild/Dockerfile*)](https://github.com/disqus/docker-nginx/blob/master/python2/light/onbuild/Dockerfile)
-   [`python2.7.10-full`, `python2.7-full`, `python2-full` (*python2/full/Dockerfile*)](https://github.com/disqus/docker-nginx/blob/master/python2/full/Dockerfile)
-   [`python2.7.10-full-onbuild`, `python2.7-full-onbuild`, `python2-full-onbuild` (*python2/full/onbuild/Dockerfile*)](https://github.com/disqus/docker-nginx/blob/master/python2/full/onbuild/Dockerfile)
-   [`python2.7.10-openresty`, `python2.7-openresty`, `python2-openresty` (*python2/openresty/Dockerfile*)](https://github.com/disqus/docker-nginx/blob/master/python2/openresty/Dockerfile)
-   [`python2.7.10-openresty-onbuild`, `python2.7-openresty-onbuild`, `python2-openresty-onbuild` (*python2/openresty/onbuild/Dockerfile*)](https://github.com/disqus/docker-nginx/blob/master/python2/openresty/onbuild/Dockerfile)

# Why not link containers?

In larger deployments, it's harder to tightly couple an application container with it's nginx configs and make sure that they are always 100% paired together. This does not replace a normal upstream proxy, but this is intended to run in front of say, uwsgi or gunicorn.

# How to use this image

## Create a `Dockerfile` in your Python app project

    FROM disqus/nginx:python2-onbuild

If you need to override your own nginx config files, you can `COPY` them in

    FROM disqus/nginx:python2-onbuild
    COPY nginx/nginx.conf /etc/nginx/nginx.conf
    COPY nginx/conf.d/ /etc/nginx/conf.d/
    COPY nginx/sites-enabled/ /etc/nginx/sites-enabled/

These images include multiple `ONBUILD` triggers, which should be all you need to bootstrap most applications. The build will `COPY` a `requirements.txt` file, `RUN pip install` on said file, copy the current directory into `/usr/src/app`, then run `wsgi.py` with uwsgi.

You can then build and run the Docker image:

    docker build -t my-python-app .
    docker run -it --rm --name my-running-app my-python-app

# Image Variants

The `disqus/nginx` images come in many flavors, each designed for a specific use case.

## `disqus/nginx:python<version>

This image is a mashup of nginx + `python:<version>`, meant for running python based applications behind a tightly coupled nginx.

## `disqus/nginx:python<version>-onbuild

This image makes deploying a python application behind nginx much easier. It works identically to the `python:onbuild` images, but also hooks up `uwsgi`/`nginx` for you. If your project includes a `wsgi.py` file in the root, this image will run that with `uwsgi` and drops an nginx config that will `uwsgi_pass` to it.
