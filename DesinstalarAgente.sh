#!/bin/bash

NOMESERVICO=SkyAgenteNovoProjeto

tipoServico=$(ps -p 1 |awk '{print $4}' |sed "1d")

if [ "$tipoServico" = "systemd" ]; then

  for SERVICO in $(ls /etc/systemd/system/ | grep $NOMESERVICO)
  do

    systemctl stop $SERVICO
    systemctl disable $SERVICO
    rm /etc/systemd/system/$SERVICO

  done

elif [ "$tipoServico" = "init" ]; then

  for SERVICO in $(ls /etc/init.d/ | grep $NOMESERVICO)
  do

    update-rc.d -f $SERVICO remove
    rm /etc/init.d/$SERVICO

  done

else

  echo "Systema não suportado" 

fi

rm -rf $(dirname $(readlink -f $0))/../repositorio/