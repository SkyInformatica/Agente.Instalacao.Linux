#!/bin/bash

versaoAInstalar=1.0.2.3
nomeServico=SkyAgenteNovoProjeto$versaoAInstalar
nomeApp=SkyInfo.Agente.Servico.Agente.dll
dirInstalacao="$(dirname $0)"

tipoServico=$(ps -p 1 |awk '{print $4}' |sed "1d")

if [ "$tipoServico" = "systemd" ]; then
    cat > /etc/systemd/system/$nomeServico.service << EOF
[Unit]
Description=$nomeServico

[Service]
User=root
Restart=on-failure
Type=simple
ExecStart=$dirInstalacao/repositorio/$versaoAInstalar/$nomeApp &> /dev/null &

[Install]
WantedBy=default.target
EOF

chmod 755 /etc/systemd/system/$nomeServico.service

cp $dirInstalacao/../appsettings.json $dirInstalacao/$versaoAInstalar/appsettings.json

 #   systemctl daemon-reload
 #   systemctl enable $nomeServico$versaoServico.service
 #   systemctl start $nomeServico$versaoServico.service

elif [ "$tipoServico" = "init" ]; then
        echo "Scripts INIT em desenvolvimento"
else 
        echo "Systema não suportado"
fi