#!/bin/bash

NOMESERVICO=SkyAgenteNovoProjeto

tipoServico=$(ps -p 1 |awk '{print $4}' |sed "1d")

if [ "$tipoServico" = "systemd" ]; then

  for SERVICO in $(ls /etc/systemd/system/ | grep $NOMESERVICO)
  do

    if [ "$(systemctl is-active $SERVICO)" != "active" ]; then
      systemctl stop $SERVICO
      systemctl disable $SERVICO
      rm /etc/systemd/system/$SERVICO
    fi

  done

elif [ "$tipoServico" = "init" ]; then

  for SERVICO in $(ls /etc/init.d/ | grep $NOMESERVICO)
  do

    if [ "$(service $SERVICO status)" != "$SERVICO: Rodando." ]; then

      update-rc.d -f $SERVICO remove
      rm /etc/systemd/system/$SERVICO

    fi

  done

else

  echo "Systema não suportado" 

fi