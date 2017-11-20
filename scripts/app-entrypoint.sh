#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/init.sh" ]]; then
  . /init.sh
  nami_initialize apache php mysql-client wordpress
fi

# Replace config to use sub directory
cp /configs/wordpress-vhost.conf /opt/bitnami/apache/conf/vhosts/wordpress-vhost.conf

# Move contents to sub directory.
if [ ! -d '/opt/bitnami/wordpress/wp' ]; then
  TLSCONFIG=$(sed -e ':loop;N;$!b loop;s/\n/\\n/g;s/&/\\&/g' <<'EOS'
/** enable TLS forced in reverse proxy environment */
// Avoid TLS loop
//   cf. https://qiita.com/hirror/items/bb96e236c3ffc41e890e#%E3%83%AA%E3%83%90%E3%83%BC%E3%82%B9%E3%83%97%E3%83%AD%E3%82%AD%E3%82%B7%E3%82%92%E4%BD%BF%E7%94%A8%E3%81%97%E3%81%A6%E3%81%84%E3%82%8B%E5%A0%B4%E5%90%88%E3%81%AEssl%E9%80%9A%E4%BF%A1 
if ( ! empty( $_SERVER['HTTP_X_FORWARDED_PROTO'] ) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https' ) {
       $_SERVER['HTTPS']='on';
}

EOS
)
  /bin/sed -i \
    -e "s|\(/\* That's all, stop editing\! Happy blogging. \*/\)|${TLSCONFIG}\n\1|" \
    -e "/^define('WP_SITEURL'/  s|'/'|'/wp'|g" \
    -e "/^define('WP_TEMP_DIR'/ s|'/opt/bitnami/wordpress/tmp/'|'/opt/bitnami/wordpress/wp/tmp/'|" \
    -e "/^\s*define('ABSPATH'/  s|'/opt/bitnami/wordpress'|'/opt/bitnami/wordpress/wp'|" \
    /opt/bitnami/wordpress/wp-config.php

  mv /opt/bitnami/wordpress /opt/bitnami/wp
  mkdir /opt/bitnami/wordpress
  mv /opt/bitnami/wp /opt/bitnami/wordpress/
fi

exec tini -- "$@"
