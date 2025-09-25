#!/bin/bash

#--- script de Health Check para Servidores ---
# autor: Vitor Durães
# Data: 25/09/2025

echo "Iniciando verificação para o servidor: $1"
echo "----------------------------------------"

# o $1 é uma variável especial que pega o primeiro argumento
# que você passa rodar o script. Ex: ./health_check.sh 192.168.1.1

ping -c 1 $1 > /dev/null 2>&1

if [ $? -eq 0 ]; then
   echo "REDE: OK - Servidor respondendo ao ping."
else
   echo "REDE: FALHA - Servidor não responde ao ping."
fi

HTTP_STATUS=$(curl --max-time 5 -s -o /dev/null -w "%{http_code}" http://$1)

if [ $HTTP_STATUS -eq 200 ]; then
   echo "SERVIÇOR WEB: OK - Status HTTP é 200."
else
   echo "SERVIÇO WEB: Falha - Status HTTP é $HTTP_STATUS."
fi

USO_DISCO=75 
THRESHOLD=80

if [ $USO_DISCO -lt $THRESHOLD ]; then
  echo "DISCO: OK - Uso de disco está em $USO_DISCO%."
else
  echo "DISCO: CRÍTICO - Uso de disco está em $USO_DISCO% (acima de $THRESHOLD%)."
fi
