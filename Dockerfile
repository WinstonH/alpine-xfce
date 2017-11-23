FROM alpine:edge
MAINTAINER Winston H.
ENV TZ 'Asia/Shanghai'
RUN apk upgrade --no-cache \
    && apk add --no-cache bash tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && rm -rf /var/cache/apk/*

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --update --no-cache add x11vnc xvfb openbox xfce4-terminal supervisor sudo dbus firefox \
&& addgroup alpine \
&& adduser  -G alpine -s /bin/sh -D alpine \
&& echo "alpine:alpine" | /usr/sbin/chpasswd \
&& echo "alpine    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
&& rm -rf /tmp/* /var/cache/apk/*
COPY entrypoint.sh /usr/sbin/entrypoint.sh
COPY check.sh /home/alpine/check.sh
COPY reset.sh /home/alpine/reset.sh
ADD etc /etc
WORKDIR /home/alpine
EXPOSE 22 5900 3389
USER alpine
ENTRYPOINT ["entrypoint.sh"]
