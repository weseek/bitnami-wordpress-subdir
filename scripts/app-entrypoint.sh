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
/bin/cat /configs/wordpress-vhost.conf > /opt/bitnami/apache/conf/vhosts/wordpress-vhost.conf
TLSCONFIG=$(sed -e ':loop;N;$!b loop;s/\n/\\n/g;s/&/\\&/g' <<'EOS'
/** enable TLS forced in reverse proxy environment */
// FORCE TLS ADMIN
define('FORCE_SSL_ADMIN', true);

// Avoid TLS roop
if ( ! empty( $_SERVER['HTTP_X_FORWARDED_PROTO'] ) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https' ) {
       $_SERVER['HTTPS']='on';
}

EOS
)
/bin/sed -i \
  -e "s|/\* That's all, stop editing\! Happy blogging. \*/|${TLSCONFIG}\n/\* That's all, stop editing\! Happy blogging. \*/|" \
  -e "s|^define('WP_SITEURL'.*$|define('WP_SITEURL', 'http://' . \$_SERVER['HTTP_HOST'] . '/wp');define('WP_HOME', 'http://' . \$_SERVER['HTTP_HOST'] . '/wp');/** Absolute path to the WordPress directory. */|" \
  -e "s|^define('WP_TEMP_DIR'.*$|define('WP_TEMP_DIR', '/opt/bitnami/wordpress/wp/tmp/');|" \
  /opt/bitnami/wordpress/wp-config.php

# Move contents to sub directory.
if [ -d '/opt/bitnami/wordpress' ]; then
  mv /opt/bitnami/wordpress /opt/bitnami/wp
  mkdir /opt/bitnami/wordpress
  mv /opt/bitnami/wp /opt/bitnami/wordpress/
fi

exec tini -- "$@"
