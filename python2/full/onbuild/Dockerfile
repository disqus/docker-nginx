FROM disqus/nginx:python2-full

RUN curl -o /usr/local/bin/nginx-and -sL "https://github.com/mattrobenolt/nginx-and/releases/download/0.1.2/nginx-and-linux-$(dpkg --print-architecture)" \
    && chmod +x /usr/local/bin/nginx-and

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY requirements.txt /usr/src/app/
ONBUILD RUN pip install --no-cache-dir -r requirements.txt

ONBUILD COPY . /usr/src/app

# if this is UWSGI_VERSION, uwsgi thinks you're trying to call `uwsgi --version` so it doesn't actually work
ENV PYTHON_UWSGI_VERSION 2.0.11.1
RUN pip install --no-cache-dir uwsgi==$PYTHON_UWSGI_VERSION

COPY nginx.conf /etc/nginx/nginx.conf
COPY sites-enabled/ /etc/nginx/sites-enabled/

CMD [ "nginx-and", "uwsgi", "--uid=nobody", "--socket=/tmp/uwsgi.sock", "--wsgi-file=wsgi.py", "--chmod-socket=666" ]
