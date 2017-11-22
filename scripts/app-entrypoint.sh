#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

# Move contents to sub directory
if [ ! -d '/opt/bitnami/wordpress/wp' ]; then
  mv /opt/bitnami/wordpress /opt/bitnami/wp
  mkdir /opt/bitnami/wordpress
  mv /opt/bitnami/wp /opt/bitnami/wordpress/
fi

# Replace config of installed directory of wordpress
/bin/sed -i \
  -e '/"installdir":/ s|"/opt/bitnami/wordpress"|"/opt/bitnami/wordpress/wp"|' \
  ~/.nami/registry.json

# initialize apache, php, mysql-client, wordpress by nami
if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/init.sh" ]]; then
  . /init.sh
  nami_initialize apache php mysql-client wordpress
fi

# Replace apache config to enable sub directory
APACHE_CONF_DIR='/opt/bitnami/apache/conf/vhosts/'
cp /configs/wordpress-vhost.conf $APACHE_CONF_DIR
cp /configs/wordpress-https-vhost.conf $APACHE_CONF_DIR

# Replace wordpress config to enable sub directory
if [ ! -f '/bitnami/wordpress/.subdirized' ]; then
  TLSCONFIG=$(sed -e ':loop;N;$!b loop;s/\n/\\n/g;s/&/\\&/g' <<'EOS'
/** enable TLS forced in reverse proxy environment */
// Avoid TLS loop
//   cf. https://qiita.com/hirror/items/bb96e236c3ffc41e890e#%E3%83%AA%E3%83%90%E3%83%BC%E3%82%B9%E3%83%97%E3%83%AD%E3%82%AD%E3%82%B7%E3%82%92%E4%BD%BF%E7%94%A8%E3%81%97%E3%81%A6%E3%81%84%E3%82%8B%E5%A0%B4%E5%90%88%E3%81%AEssl%E9%80%9A%E4%BF%A1 
if ( ! empty( $_SERVER['HTTP_X_FORWARDED_PROTO'] ) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https' ) {
       $_SERVER['HTTPS']='on';
}

EOS
)
  # Replace config to enable sub directory
  # NOTE: Option `--follow-symlinks` is needed for sed, because 
  #         "/opt/bitnami/wordpress/wp-config.php" is a symbolic link.
  #       cf. https://tsuchinoko.dmmlabs.com/?p=678
  /bin/sed -i --follow-symlinks \
    -e "s|\(/\* That's all, stop editing\! Happy blogging. \*/\)|${TLSCONFIG}\n\1|" \
    -e "/^define('WP_SITEURL'/ s|'/'|'/wp'|g" \
    -e "/^define('WP_SITEURL'/ s|'http://'|'https://'|g" \
    /opt/bitnami/wordpress/wp/wp-config.php

  touch /bitnami/wordpress/.subdirized || true
fi

exec tini -- "$@"
