#!/bin/bash

# Démarrer MySQL
service mysql start

# Démarrer PHP-FPM
service php7.3-fpm start

# Si le répertoire WordPress est vide, copier les fichiers depuis le répertoire temporaire
if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
    echo "Copie des fichiers WordPress dans le volume..."
    cp -r /usr/src/wordpress/* /var/www/html/wordpress/
    chown -R www-data:www-data /var/www/html/wordpress
fi

# Démarrer Nginx en mode foreground
nginx -g "daemon off;"
