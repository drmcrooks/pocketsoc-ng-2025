#! /bin/bash

JSON="application/json"
FEED_URL="https://pocketsoc-ng-web-1/attributes/bro/download/all"
FEED_DIR="/opt/zeek/feeds"

mkdir -p $FEED_DIR

while true; do
    authkey=`cat /opt/pocketsoc-ng/data/authkey`
    AUTH_KEY="Authorization: $authkey"
    curl -k -s --header "$AUTH_KEY" --header "Accept: $JSON" --header "Content-type: $JSON" -X POST --data "{\"request\": {${EXCLUSIONS} \"type\": \"all\"}}" $FEED_URL > $FEED_DIR/intel.txt
    sleep 60
done
