FROM python:2.7

ENV OPENRESTY_VERSION 1.7.10.1
ENV OPENRESTY_DOWNLOAD_URL http://openresty.org/download/ngx_openresty-1.7.10.1.tar.gz
ENV OPENRESTY_DOWNLOAD_SHA1 0cc7a3fe75fbe50dec619af1a09b87f7f8c79e1d

RUN buildDeps='libgd-dev libgeoip-dev libpam0g-dev'; \
    runtimeDeps='libgd3 libgeoip1'; \
    modsDir='/usr/src/nginx-modules'; \
    set -x \
    && apt-get update && apt-get install -y $buildDeps $runtimeDeps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /usr/src/nginx \
    && mkdir -p $modsDir/nginx-statsd \
        && curl -sSL https://github.com/zebrafishlabs/nginx-statsd/archive/b756a12.tar.gz \
            | tar -zxvC $modsDir/nginx-statsd --strip-components=1 \
    && mkdir -p $modsDir/nginx-auth-pam \
        && curl -sSL https://github.com/stogh/ngx_http_auth_pam_module/archive/v1.4.tar.gz \
            | tar -zxvC $modsDir/nginx-auth-pam --strip-components=1 \
    && mkdir -p $modsDir/nginx-dav-ext-module \
        && curl -sSL https://github.com/arut/nginx-dav-ext-module/archive/v0.0.3.tar.gz \
            | tar -zxvC $modsDir/nginx-dav-ext-module --strip-components=1 \
    && mkdir -p $modsDir/nginx-upstream-fair \
        && curl -sSL https://github.com/gnosek/nginx-upstream-fair/archive/a18b409.tar.gz \
            | tar -zxvC $modsDir/nginx-upstream-fair --strip-components=1 \
    && mkdir -p $modsDir/ngx_http_substitutions_filter_module \
        && curl -sSL https://github.com/yaoweibin/ngx_http_substitutions_filter_module/archive/v0.6.4.tar.gz \
            | tar -zxvC $modsDir/ngx_http_substitutions_filter_module --strip-components=1 \
    && curl -sSL "$OPENRESTY_DOWNLOAD_URL" -o openresty.tar.gz \
    && echo "$OPENRESTY_DOWNLOAD_SHA1 openresty.tar.gz" | sha1sum -c - \
    && tar -xzf openresty.tar.gz -C /usr/src/nginx --strip-components=1 \
    && rm openresty.tar.gz \
    && ( cd /usr/src/nginx ; ./configure \
        --conf-path=/etc/nginx/nginx.conf \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --lock-path=/var/lock/nginx.lock \
        --pid-path=/run/nginx.pid \
        --http-client-body-temp-path=/var/lib/nginx/body \
        --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
        --http-proxy-temp-path=/var/lib/nginx/proxy \
        --http-scgi-temp-path=/var/lib/nginx/scgi \
        --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
        --with-debug \
        --with-pcre-jit \
        --with-ipv6 \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_dav_module \
        --with-http_geoip_module \
        --with-http_gzip_static_module \
        --with-http_image_filter_module \
        --with-http_spdy_module \
        --with-http_sub_module \
        --with-http_xslt_module \
        --with-mail \
        --with-mail_ssl_module \
        --add-module=$modsDir/nginx-auth-pam \
        --add-module=$modsDir/nginx-dav-ext-module \
        --add-module=$modsDir/nginx-upstream-fair \
        --add-module=$modsDir/ngx_http_substitutions_filter_module \
        # extras that aren't included in normal nginx-full
        --with-md5-asm \
        --with-md5=/usr/include \
        --with-sha1-asm \
        --with-sha1=/usr/include \
        --with-file-aio \
        --add-module=$modsDir/nginx-statsd \
        -j$(nproc) \
        ) \
    && make -C /usr/src/nginx -j$(nproc) \
    && make -C /usr/src/nginx install \
    && mkdir -p /var/lib/nginx \
    && rm -rf /usr/src/nginx \
    && rm -rf /usr/src/nginx-modules \
    && apt-get purge -y --auto-remove $buildDeps

ENV PATH $PATH:/usr/local/openresty/bin:/usr/local/openresty/nginx/sbin

WORKDIR /usr/local/openresty/nginx/html
EXPOSE 80 443

CMD [ "nginx", "-g", "daemon off;" ]
