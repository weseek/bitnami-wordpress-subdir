# bitnami-wordpress-subdir

A Wordpress based on bitnami/wordpress with replacing configs to use sub directory ('/wp').

# Instration

You need to get docker-compose.yml to start bitnami-wordpress-subdir.

```
$ curl -l https://github.com/weseek/bitnami-wordpress-subdir/blob/master/docker-compose.yml
```

Finished instaration, you can start bitnami-wordpress-subdir.

# How to start / stop Wordpress

```sh
# User is needed to join docker group or root authority.
$ docker-compose up/down
```

NOTE: A post is created titled 'Hello World!' every `docker-compose up`.

Then, browser can access wordpress by enter URL http://localhost/wp/.

# Maintenance (for Developer/Operator)

## How to upgrade base bitnami-wordpress

Edit bitnami/wordpress version in Dockerfile.

```sh
# Dockerfile
FROM bitnami/wordpress:4.8.3-r0  # !!!CHANGE THIS VERSION!!!
  : <snip>
```

Build and test browser access. (URL http://localhost/wp/)

```sh
$ docer-compose up -d build
```

## About tagging

Add a version tag to the committed repository.
Note: It is need to follow rule bellow.

### Tagging Rule

- Make it same as the base bitnami/wordpress version.
- If you made bitnami-wordpress-subdir own modifications or extensions, add a serial number at the end of the above rule version.
