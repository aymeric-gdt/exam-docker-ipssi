# Projet Docker : Serveur Web avec WordPress, phpMyAdmin et SSL

Ce projet Docker configure un serveur web sous Debian Buster capable d'exécuter plusieurs services, notamment WordPress, phpMyAdmin et MySQL, avec Nginx comme serveur web et SSL pour sécuriser la connexion. Le serveur est conçu pour être extensible, utilisant des volumes pour la persistance de données et une configuration Nginx personnalisée.

## Fonctionnalités

- Installation et configuration de WordPress.
- Installation et configuration de phpMyAdmin.
- Base de données MySQL avec un utilisateur configuré.
- Configuration SSL (auto-signé) pour sécuriser les connexions HTTPS.
- Redirection automatique de HTTP vers HTTPS.
- `autoindex` configurable via une variable d'environnement.

## Prérequis

- **Docker** et **Docker Compose** installés sur votre machine.
- Connaissance de base en administration de serveurs et en configuration Docker.

## Installation et Lancement

### 1. Cloner le dépôt

```bash
git clone https://github.com/username/projet-docker-webserver.git
cd projet-docker-webserver
```
### 2. Construire l'image Docker
Depuis le répertoire du projet, exécutez la commande suivante pour construire l'image Docker :
```bash
docker build -t my_web_server .
```
### 3. Lancer le conteneur

Pour démarrer le conteneur avec persistance des données de WordPress et MySQL, utilisez la commande suivante :

```bash
docker run -d -p 80:80 -p 443:443 \
    -v wordpress_data:/var/www/html/wordpress \
    -v mysql_data:/var/lib/mysql \
    my_web_server
```
### 4. Accéder aux services
- WordPress : Accédez à http://localhost/wordpress.
- phpMyAdmin : Accédez à http://localhost/phpmyadmin.
- HTTPS : Le site est également accessible via HTTPS à https://localhost, bien que le certificat soit auto-signé.

## Configuration Personnalisée
### Nginx et SSL

Le projet utilise un certificat SSL auto-signé pour sécuriser les connexions. La configuration de Nginx est gérée via le fichier default.conf, qui est copié dans le conteneur lors de la construction.
Autoindex

L'autoindex de Nginx est configurable via la variable d'environnement AUTOINDEX. Pour l'activer ou le désactiver, ajoutez -e AUTOINDEX=on ou -e AUTOINDEX=off lors de l'exécution du conteneur.

Exemple pour désactiver l'autoindex :

```bash
docker run -d -p 80:80 -p 443:443 \
    -v wordpress_data:/var/www/html/wordpress \
    -v mysql_data:/var/lib/mysql \
    -e AUTOINDEX=off \
    my_web_server
```
### Arborescence du Projet

```plaintext
.
├── Dockerfile                # Dockerfile pour configurer l'image
├── default.conf              # Configuration de Nginx pour gérer SSL et les emplacements
├── docker-entrypoint.sh      # Script de démarrage pour gérer les services
└── README.md                 # Documentation du projet
```
### Fonctionnement Interne
WordPress et phpMyAdmin sont installés dans /var/www/html pour être servis par Nginx.
MySQL crée une base de données wordpress avec un utilisateur wp_user et un mot de passe sécurisé.
SSL est géré avec un certificat auto-signé situé dans /etc/nginx/ssl.

### Dépannage
Connexion non sécurisée en HTTPS : Étant donné que le certificat est auto-signé, les navigateurs affichent un avertissement. Il suffit d’accepter le certificat pour continuer.
Erreur de connexion à MySQL : Assurez-vous que MySQL est correctement configuré et que les volumes mysql_data et wordpress_data sont montés pour conserver les données.
