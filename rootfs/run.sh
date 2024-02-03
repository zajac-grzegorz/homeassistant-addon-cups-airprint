#!/usr/bin/with-contenv bashio

ulimit -n 1048576

# wait until the avahi daemon has started up

until [ -e /var/run/avahi-daemon/socket ]; do
  sleep 1s
done

# move cups from /etc to /data

bashio::log.info "Preparing directories"
cp -v -R /etc/cups /data
rm -v -fR /etc/cups

# link the two

ln -v -s /data/cups /etc/cups

# start CUPS

bashio::log.info "Starting CUPS server as CMD from S6"

cupsd -f
