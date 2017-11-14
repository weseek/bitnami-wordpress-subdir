<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'bitnami_wordpress');

/** MySQL database username */
define('DB_USER', 'bn_wordpress');

/** MySQL database password */
define('DB_PASSWORD', '');

/** MySQL hostname */
define('DB_HOST', 'mariadb:3306');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '2qqtmPKY9T68aSMUf8bBoCCV5ALproH5');
define('SECURE_AUTH_KEY',  'Dm0bfdJpXZmeeMOEZetajUtdbODRiWBU');
define('LOGGED_IN_KEY',    'BhAq0FIKX9r55anwGLjkRaI5nciMuRh9');
define('NONCE_KEY',        'FZRJWg5Qe7LbfAMYYizhF0CKa0poFxTN');
define('AUTH_SALT',        'v0UE7vK5Ljst8SIaZeDGP8SJyyB5Dgmz');
define('SECURE_AUTH_SALT', 'nFCtv8OQGBn00SVpaCEJddhDd4U4z18s');
define('LOGGED_IN_SALT',   'NkwMiZrPbuw5xpWkrXI7SNvZa3AM4a95');
define('NONCE_SALT',       'ucBpVkaMlk1u2Kmjh20fyoj7ZBrBBrsr');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/** enable SSL forced in reverse proxy environment */
// FORCE SSL ADMIN
define('FORCE_SSL_ADMIN', true);

// Avoid SSL roop
if ( ! empty( $_SERVER['HTTP_X_FORWARDED_PROTO'] ) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https' ) {
       $_SERVER['HTTPS']='on';
}

/* That's all, stop editing! Happy blogging. */

define('WP_SITEURL', 'http://' . $_SERVER['HTTP_HOST'] . '/wp');define('WP_HOME', 'http://' . $_SERVER['HTTP_HOST'] . '/wp');/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
        define('ABSPATH', '/opt/bitnami/wordpress/wp' . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');

define('FS_METHOD', 'direct');

define('WP_TEMP_DIR', '/opt/bitnami/wordpress/wp/tmp/');

//  Disable pingback.ping xmlrpc method to prevent WordPress from participating in DDoS attacks
//  More info at: https://wiki.bitnami.com/Applications/Bitnami_WordPress#XMLRPC_and_Pingback

// remove x-pingback HTTP header
add_filter("wp_headers", function($headers) {
            unset($headers["X-Pingback"]);
            return $headers;
           });
// disable pingbacks
add_filter( "xmlrpc_methods", function( $methods ) {
             unset( $methods["pingback.ping"] );
             return $methods;
           });
