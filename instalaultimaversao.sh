#!/bin/bash

versaoAInstalar=1.0.2.3
nomeServico=SkyAgenteNovoProjeto$versaoAInstalar
nomeApp=SkyInfo.Agente.Servico.Agente
dirInstalacao="$(dirname $0)"

tipoServico=$(ps -p 1 |awk '{print $4}' |sed "1d")

if [ "$tipoServico" = "systemd" ]; then
    cat > /etc/systemd/system/$nomeServico.service << EOF
[Unit]
Description=$nomeServico Daemon

[Service]
User=root
Restart=always
Type=simple
ExecStart=$dirInstalacao/$versaoAInstalar/Binarios/$nomeApp &> /dev/null &
WorkingDirectory=$dirInstalacao/$versaoAInstalar/Binarios/

[Install]
WantedBy=default.target
EOF

chmod 755 /etc/systemd/system/$nomeServico.service
chmod +x $dirInstalacao/$versaoAInstalar/Binarios/*

cp $dirInstalacao/../appsettings.json $dirInstalacao/$versaoAInstalar/Binarios/appsettings.json

 systemctl daemon-reload
 systemctl enable $nomeServico$versaoServico.service
 systemctl start $nomeServico$versaoServico.service

elif [ "$tipoServico" = "init" ]; then

    cat > /etc/init.d/$nomeServico << EOF
#!/bin/sh
### BEGIN INIT INFO
# Provides:          $nomeServico
# Required-Start:    \$local_fs \$syslog
# Required-Stop:     \$local_fs \$syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: $nomeServico
# Description:       Agente de sincronização dos sistemas legado com novo projeto Sky Sistemas.
### END INIT INFO

NAME="$nomeServico"
DESC="$nomeServico daemon"
PIDFILE="/run/\$NAME.pid"
DAEMON="$dirInstalacao/$versaoAInstalar/Binarios/$nomeApp"

[ -x "\$DAEMON" ] || exit 0

. /lib/lsb/init-functions

do_start () {
    start-stop-daemon --start --quiet -b --exec "\$DAEMON"
}

do_stop() {
    start-stop-daemon --stop --quiet --exec "\$DAEMON"
}

case "\$1" in
    start)
        log_daemon_msg "Starting \$DESC" "\$NAME"
        do_start
        retval="\$?"
        case "\$retval" in
            0|1)
                [ "\$retval" -eq 1 ] && log_progress_msg "already started"
                log_end_msg 0
                ;;
            *)
                log_end_msg 1
                exit 1
                ;;
        esac
        ;;
    stop)
        log_daemon_msg "Stopping \$DESC" "\$NAME"
        do_stop
        retval="\$?"
        case "\$retval" in
            0|1)
                [ "\$retval" -eq 1 ] && log_progress_msg "already stopped"
                log_end_msg 0
                ;;
            *)
                log_end_msg 1
                exit 1
                ;;
        esac
        ;;
    restart|force-reload)
        "\$0" stop
        "\$0" start
        ;;
    status)
        if [ -z "\$(pgrep -f \$DAEMON)" ]
	then 
 		echo "O \$NAME NÃO esta rodando!"
	else
        	pgrep -f "SkyInfo.Agente.Servico.Agente" |awk {'print "'\$NAME': Em execução - PID: " \$1 '}
	fi
        exit "\$?"
        ;;
    *)
        echo "Usage: \$0 {start|stop|restart|force-reload|status}"
        exit 2
        ;;
esac

EOF

chmod +x /etc/init.d/$nomeServico

else 
        echo "Systema não suportado"
fi