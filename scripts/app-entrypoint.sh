#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

# Reset initialization flag to re-initialize.
if [ -f '/bitnami/wordpress/.initialized' ]; then
  rm /bitnami/wordpress/.initialized
  cat /configs/wp-config.php.init > /opt/bitnami/wordpress/wp-config.php
fi

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/init.sh" ]]; then
  . /init.sh
  nami_initialize apache php mysql-client wordpress
fi

# Replace config to use sub directory and use SSL forced in Admin's settings page.
/bin/cat /configs/wordpress-https-vhost.conf > /opt/bitnami/apache/conf/vhosts/wordpress-https-vhost.conf
/bin/cat /configs/wordpress-vhost.conf > /opt/bitnami/apache/conf/vhosts/wordpress-vhost.conf
/bin/cat /configs/wp-config.php > /opt/bitnami/wordpress/wp-config.php

# Move contents to sub directory.
if [ -d '/opt/bitnami/wordpress' ]; then
  mv /opt/bitnami/wordpress /opt/bitnami/wp
  mkdir /opt/bitnami/wordpress
  mv /opt/bitnami/wp /opt/bitnami/wordpress/
fi

exec tini -- "$@"
