FROM rockylinux:9

RUN dnf install -y epel-release
RUN dnf install -y epel-release &&\
    dnf install -y bind-utils iputils iproute net-tools traceroute net-tools tcpdump iptables lsof vim openssh-clients ncurses tcpreplay &&\
    dnf update -y

ADD ./bin /opt/pocketsoc-ng/bin

RUN chmod +x /opt/pocketsoc-ng/bin/startup.sh

CMD ["/opt/pocketsoc-ng/bin/startup.sh"]    
