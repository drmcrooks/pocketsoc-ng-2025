FROM rockylinux:9

RUN dnf config-manager --enable crb
RUN dnf install -y bind-utils iputils iproute net-tools traceroute net-tools tcpdump iptables lsof vim openssh-clients ncurses libpcap libpcap-devel gcc cmake
RUN dnf update -y

RUN curl -s -L -O https://github.com/appneta/tcpreplay/releases/download/v4.5.1/tcpreplay-4.5.1.tar.gz && tar -xzvf ./tcpreplay-4.5.1.tar.gz && cp tcpreplay-4.5.1 && ./configure && make && make install

ADD ./bin /opt/pocketsoc-ng/bin

RUN chmod +x /opt/pocketsoc-ng/bin/startup.sh

CMD ["/opt/pocketsoc-ng/bin/startup.sh"]    
