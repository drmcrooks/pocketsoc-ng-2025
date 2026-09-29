#! /bin/bash
  
AUTH_KEY="Authorization: $authkey"

JSON="application/json"
FEED_URL="https://pocketsoc-ng-web-1/attributes/bro/download/all"
FEED_DIR="/opt/zeek/feeds"

mkdir -p $FEED_DIR

while true; do
    curl -k -s --header "$AUTH_KEY" --header "Accept: $JSON" --header "Content-type: $JSON" -X POST --data "{\"request\": {${EXCLUSIONS} \"type\": \"all\"}}" $FEED_URL > $FEED_DIR/intel.txt
    sleep 60
done
