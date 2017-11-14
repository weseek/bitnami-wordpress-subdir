FROM bitnami/wordpress:latest

# Add new scripts and configs to use sub directory.
COPY ./scripts/app-entrypoint.sh /app-entrypoint.sh

# Remove config file original to replace.
RUN mkdir /configs
COPY ./configs/wordpress-https-vhost.conf /configs
COPY ./configs/wordpress-vhost.conf /configs
COPY ./configs/wp-config.php /configs
COPY ./configs/wp-config.php.init /configs

