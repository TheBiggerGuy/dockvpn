FROM ubuntu:vivid

RUN apt-get update -qy ;\
    apt-get install -qy openvpn iptables supervisor ;\
    apt-get clean -qy ;\
    apt-get purge -qy

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY config/* /etc/openvpn/
RUN cat /etc/openvpn/common.conf >> /etc/openvpn/tcp.config ;\
    cat /etc/openvpn/common.conf >> /etc/openvpn/udp.config ;\
    rm /etc/openvpn/common.conf

RUN mkdir -p /var/log/supervisor ;\
    mkdir -p /var/log/openvpn

ADD ./bin /usr/local/sbin
VOLUME /etc/openvpn

RUN mkdir -p /dev/net ;\
    mknod /dev/net/tun c 10 200

EXPOSE 443/tcp 1194/udp
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
