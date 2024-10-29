# Utiliser Debian Buster comme base
FROM debian:buster

# Installer les dépendances et mises à jour nécessaires
RUN apt-get update && \
    apt-get install -y nginx default-mysql-server php-fpm php-mysql php-xml php-mbstring wget unzip openssl && \
    apt-get clean

# Configurer MySQL
RUN service mysql start && \
    mysql -e "CREATE DATABASE wordpress;" && \
    mysql -e "CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'secure_password';" && \
    mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;"

# Télécharger WordPress dans un répertoire temporaire
RUN wget https://wordpress.org/latest.tar.gz && \
    mkdir -p /usr/src/wordpress && \
    tar -xzf latest.tar.gz -C /usr/src/wordpress --strip-components=1 && \
    rm latest.tar.gz

# Installer phpMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz && \
    tar -xzf phpMyAdmin-5.2.1-all-languages.tar.gz && \
    rm phpMyAdmin-5.2.1-all-languages.tar.gz && \
    mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin && \
    cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php

# Configurer phpMyAdmin
RUN sed -i "s/\['host'\] = 'localhost'/\['host'\] = '127.0.0.1'/" /var/www/html/phpmyadmin/config.inc.php

# Créer un certificat SSL auto-signé
RUN mkdir /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx-selfsigned.key -out /etc/nginx/ssl/nginx-selfsigned.crt -subj "/C=FR/ST=France/L=City/O=Organization/OU=Department/CN=localhost"

# Copier la configuration de Nginx
COPY ./default.conf /etc/nginx/conf.d/default.conf

# Définir un volume pour le répertoire WordPress
VOLUME /var/www/html/wordpress

# Copier le script de démarrage
COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Exposer le port 80 et 443 pour le serveur web
EXPOSE 80 443

# Définir le script de démarrage comme point d'entrée
ENTRYPOINT ["docker-entrypoint.sh"]
