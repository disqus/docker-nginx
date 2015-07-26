FROM python:2.7

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 520A9993A1C052F8
ENV NGINX_VERSION 1.8.0
ENV NGINX_DOWNLOAD_URL http://nginx.org/download/nginx-1.8.0.tar.gz

RUN modsDir='/usr/src/nginx-modules'; \
    set -x \
    && mkdir -p $modsDir/nginx-statsd \
        && curl -sSL https://github.com/zebrafishlabs/nginx-statsd/archive/b756a12.tar.gz \
            | tar -zxvC $modsDir/nginx-statsd --strip-components=1 \
    && mkdir -p $modsDir/nginx-echo \
        && curl -sSL https://github.com/openresty/echo-nginx-module/archive/v0.57.tar.gz \
            | tar -zxvC $modsDir/nginx-echo --strip-components=1 \
    && mkdir -p /usr/src/nginx \
    && curl -sSL "$NGINX_DOWNLOAD_URL" -o nginx.tar.gz \
    && curl -sSL "$NGINX_DOWNLOAD_URL.asc" -o nginx.tar.gz.asc \
    && gpg --verify nginx.tar.gz.asc \
    && tar -xzf nginx.tar.gz -C /usr/src/nginx --strip-components=1 \
    && rm nginx.tar.gz && rm nginx.tar.gz.asc \
    && ( cd /usr/src/nginx ; ./configure \
        --conf-path=/etc/nginx/nginx.conf \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --lock-path=/var/lock/nginx.lock \
        --pid-path=/run/nginx.pid \
        --http-client-body-temp-path=/var/lib/nginx/body \
        --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
        --http-proxy-temp-path=/var/lib/nginx/proxy \
        --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
        --with-pcre-jit \
        --with-ipv6 \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_realip_module \
        --with-http_gzip_static_module \
        --add-module=$modsDir/nginx-echo \
        --without-http_browser_module \
        --without-http_geo_module \
        --without-http_limit_conn_module \
        --without-http_limit_req_module \
        --without-http_memcached_module \
        --without-http_referer_module \
        --without-http_scgi_module \
        --without-http_split_clients_module \
        --without-http_ssi_module \
        --without-http_userid_module \
        # this doesn't normally exist in nginx-light... but this is for python, so we want it
        # --without-http_uwsgi_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module \
        # extras that aren't included in normal nginx-light
        --with-md5-asm \
        --with-md5=/usr/include \
        --with-sha1-asm \
        --with-sha1=/usr/include \
        --with-file-aio \
        --add-module=$modsDir/nginx-statsd \
        ) \
    && make -C /usr/src/nginx -j$(nproc) \
    && make -C /usr/src/nginx install \
    && mkdir -p /var/lib/nginx \
    && rm -rf /usr/src/nginx \
    && rm -rf /usr/src/nginx-modules

ENV PATH $PATH:/usr/local/nginx/sbin

# redirect all logs to stderr/stdout
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

WORKDIR /usr/local/nginx/html
EXPOSE 80 443

CMD [ "nginx", "-g", "daemon off;" ]
