FROM zeek/zeek:9.0.0-rc2

RUN apt-get update

RUN apt-get install -y tcpdump supervisor tcpreplay apt-transport-https curl gnupg2

RUN mkdir -p /usr/share/keyrings/

RUN curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elastic-7.x.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/elastic-7.x.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" >> /etc/apt/sources.list.d/elastic-7.x.list

RUN apt-get update

RUN apt-get install -y filebeat

RUN apt-get upgrade -y

ADD ./config/zeekctl.cfg /usr/local/zeek/etc/zeekctl.cfg
ADD ./config/networks.cfg /usr/local/zeek/etc/networks.cfg
ADD ./config/node.cfg /usr/local/zeek/etc/node.cfg

#COPY ./config/local.zeek /usr/local/zeek/share/zeek/site/local.zeek
#COPY ./config/mattermost.zeek /usr/local/zeek/share/zeek/site/mattermost.zeek

COPY ./config/filebeat.yml /etc/filebeat/filebeat.yml

ADD ./bin /opt/pocketsoc-ng/bin
RUN chmod +x /opt/pocketsoc-ng/bin/startup.sh

ADD ./config/supervisor.conf /etc/supervisord.conf
CMD ["/opt/pocketsoc-ng/bin/startup.sh"]
