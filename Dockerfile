FROM alpine:edge
MAINTAINER Winston H.
ENV TZ 'Asia/Shanghai'
RUN apk upgrade --no-cache \
    && apk add --no-cache bash tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && rm -rf /var/cache/apk/*

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --update --no-cache add x11vnc xvfb xrdp xauth alpine-desktop xfce4 ttf-freefont supervisor sudo openssl openssh dbus \
&& addgroup alpine \
&& adduser  -G alpine -s /bin/sh -D alpine \
&& echo "alpine:alpine" | /usr/sbin/chpasswd \
&& echo "alpine    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
&& rm -rf /tmp/* /var/cache/apk/*
COPY entrypoint.sh /usr/sbin/entrypoint.sh
COPY check.sh /home/alpine/check.sh
COPY reset.sh /home/alpine/reset.sh
ADD etc /etc
RUN xrdp-keygen xrdp auto
RUN sed -i '/TerminalServerUsers/d' /etc/xrdp/sesman.ini \
&& sed -i '/TerminalServerAdmins/d' /etc/xrdp/sesman.ini

WORKDIR /home/alpine
EXPOSE 22 5900 3389
USER alpine
ENTRYPOINT ["entrypoint.sh"]
