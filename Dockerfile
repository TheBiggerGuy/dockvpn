FROM ubuntu:wily

MAINTAINER Guy Taylor <thebigguy.co.uk@gmail.com>

RUN apt-get update -qy ;\
    apt-get install -qy openvpn openssl ca-certificates iptables supervisor python-pip ;\
    pip install awscli ;\
    pip install supervisor-stdout ;\
    apt-get purge -qy python-pip ;\
    apt-get autoremove -qy ;\
    apt-get clean -qy ;\
    apt-get purge -qy ;\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /var/log

RUN mkdir -p /dev/net ;\
    mknod /dev/net/tun c 10 200

EXPOSE 443/tcp 1194/udp

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY config/* /etc/openvpn/
RUN cat /etc/openvpn/tcp.conf /etc/openvpn/common.conf >> /etc/openvpn/tcp.conf.tmp ;\
    cat /etc/openvpn/udp.conf /etc/openvpn/common.conf >> /etc/openvpn/udp.conf.tmp ;\
    mv /etc/openvpn/tcp.conf.tmp /etc/openvpn/tcp.conf ;\
    mv /etc/openvpn/udp.conf.tmp /etc/openvpn/udp.conf ;\
    rm /etc/openvpn/common.conf ;\
    ls /etc/openvpn/

COPY bin/* /usr/bin/

ENTRYPOINT ["/usr/bin/dockervpn"]
