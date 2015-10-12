FROM ubuntu:vivid
RUN apt-get update -qy
RUN apt-get install -qy openvpn iptables curl
RUN apt-get clean -qy
RUN apt-get purge -qy
ADD ./bin /usr/local/sbin
VOLUME /etc/openvpn
EXPOSE 443/tcp 1194/udp
CMD run
