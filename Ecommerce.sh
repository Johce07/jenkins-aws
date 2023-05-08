#!/bin/bash
#variables
REPO="The-DevOps-Journey-101"
USERID=$(id -u)
paquetes=("apache2" "php" "libapache2-mod-php" "php-mysql" "git")

if [ "${USERID}" -ne 0 ]; then
    echo -e "\033[33mCorrer con usuario ROOT\033[0m"
    exit
fi 

echo "====================================="
apt-get update
echo -e "\e[92mEl Servidor se encuentra Actualizado ...\033[0m\n"

### base de datos

if dpkg -s mariadb-server > /dev/null 2>&1; then
    echo -e "\n\e[96mA Mariadb esta realmente instalado \033[0m\n"
else    
    echo -e "\n\e[92mInstalando mariadb ...\033[0m\n"
    apt install -y mariadb-server
    systemctl start mariadb
    systemctl enable mariadb
    sleep 1
    mysql -e "
         CREATE DATABASE ecomdb;
         CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
         GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
         FLUSH PRIVILEGES;"
    cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;
INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF

 echo -e "\n\033[33mScript sql generado\033[0m\n"
 mysql < db-load-script.sql
 echo -e "\n\033[33mScript sql ejecutado\033[0m\n"
fi

#### APACHE
for p in "${paquetes[@]}"
do      
    if dpkg -s "$p" >/dev/null 2>&1; then
        echo -e "\n\e[96m$p ya se encuentra instalado \033[0m\n"
    else    
        echo -e "\n\e[92mInstalando Apache2 php libapache2-mod-php php-mysql...\033[0m\n"
        apt install -y apache2
        apt install -y php libapache2-mod-php php-mysql
        apt install -y git
        systemctl start apache2
        systemctl enable apache2
        mv /var/www/html/index.html /var/www/html/index.html.bkp
        echo -e "\n\033[33mGit se ha instalado\033[0m\n"
    fi
done

if [ -d "$REPO" ]; then
    echo "La carpeta $REPO existe"
    rm -rf $REPO
fi

echo -e "\n\e[92mInstalling web ...\033[0m\n"
sleep 1
git clone https://github.com/roxsross/$REPO.git 
cp -r $REPO/CLASE-02/lamp-app-ecommerce/* /var/www/html
sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php
echo "====================================="

sleep 1

systemctl reload apache2