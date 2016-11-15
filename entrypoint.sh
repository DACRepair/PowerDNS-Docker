#!/bin/bash
set -e

if [[ ! -d /data/powerdns ]]; then
  echo "the persistent storage volume is empty"
  echo "creating default config"
  cp -r /etc/powerdns /data
#  ln -s /data/powerdns /etc/powerdns
  find /data/powerdns -type f -exec sed -i -e 's!/etc/powerdns!/data/powerdns!g' {} \;
  sed -i -e 's!daemon=yes!daemon=no!g' /data/powerdns/pdns.conf
else
  echo "using existing config"
fi

/usr/sbin/pdns_server  --config-dir=/data/powerdns
