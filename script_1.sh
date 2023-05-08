#!/bin/bash
PAQUETES=("apache2" "git")

echo "Validando Usuario"

if [ "$(id -u)" -ne 0 ]; then
    echo "Por favor correr con usuario Root"
    exit
fi 

echo "====================================="
apt-get update
echo "Sistem operativo actualizado"
# Verificar si Apache2 y Git están instalados
for m in "${PAQUETES[@]}"
do
    if dpkg -s "$m" > /dev/null 2>&1; then
        echo "$m Ya se encuentra instalado"        
    else
        echo "Instalando $m"
        apt-get install -y apache2
        apt-get install -y git
    fi
done

echo "====================================="

echo "Instalando WEB"
sleep 1
rm -rf devops-static-web
git clone -b devops-mariobros https://github.com/roxsross/devops-static-web.git 
cp -r devops-static-web/* /var/www/html
ls -lrt /var/www/html

echo "====================================="

echo "Iniciando Apache2"
systemctl start apache2
systemctl enable apache2

echo "====================================="

#echo "TEST"

#curl localhost
#sleep 1
#echo "FIN"