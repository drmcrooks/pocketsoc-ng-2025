#! /bin/bash

chmod +x /opt/pocketsoc-ng/bin/nic_setup.sh
/opt/pocketsoc-ng/bin/nic_setup.sh

chmod +x /opt/pocketsoc-ng/bin/pull_misp.sh

/opt/pocketsoc-ng/bin/pull_misp.sh &

chmod +x /opt/pocketsoc-ng/bin/notifier.sh

echo ${ZEEKHOST} > /opt/pocketsoc-ng/data/zeekhost
echo NULL > /opt/pocketsoc-ng/data/authkey

which supervisord

/usr/bin/supervisord -c /etc/supervisord.conf
