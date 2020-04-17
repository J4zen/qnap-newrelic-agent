#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="NewRelicInfraAgent"
QPKG_ROOT=`/sbin/getcfg $QPKG_NAME Install_Path -f ${CONF}`
APACHE_ROOT=`/sbin/getcfg SHARE_DEF defWeb -d Qweb -f /etc/config/def_share.info`
export QNAP_QPKG=$QPKG_NAME

PID_FILE=$QPKG_ROOT/var/run/newrelic-infra/newrelic-infra.pid
PLUGIN_DIR=$QPKG_ROOT/etc/newrelic-infra/integrations.d/
AGENT_DIR=$QPKG_ROOT/var/db/newrelic-infra/
LOG_FILE=$QPKG_ROOT/var/log/newrelic-infra/newrelic-infra.log
LICENSE_KEY=NO_LICENSE_KEY_SET
NEWRELIC_SETTINGS_FILE=/etc/newrelic-infra.yml


case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    fi
    : ADD START ACTIONS HERE
    ln -fs $QPKG_ROOT/web /home/Qhttpd/Web/NewRelicInfraAgent

    if test ! -f "$QPKG_ROOT/NewRelicInfraAgent.conf"; then
        # Generate New Relic agent configuration file
        echo "pid_file: $PID_FILE" > $QPKG_ROOT/NewRelicInfraAgent.conf
        echo "plugin_dir: $PLUGIN_DIR" >> $QPKG_ROOT/NewRelicInfraAgent.conf
        echo "agent_dir: $AGENT_DIR" >> $QPKG_ROOT/NewRelicInfraAgent.conf
        echo "log_file: $LOG_FILE" >> $QPKG_ROOT/NewRelicInfraAgent.conf
        echo "license_key: $LICENSE_KEY" >> $QPKG_ROOT/NewRelicInfraAgent.conf 
    fi 

    ln -fs $QPKG_ROOT/NewRelicInfraAgent.conf $NEWRELIC_SETTINGS_FILE
    touch $LOG_FILE
    chmod g+rw $QPKG_ROOT/NewRelicInfraAgent.conf
 
    if test -f "$PIDFILE"; then
        echo "Agent already running under pid $PID"
        exit
    fi

    $QPKG_ROOT/usr/bin/newrelic-infra > /dev/null 2>&1 &
    ;;

  stop)
    : ADD STOP ACTIONS HERE
    if test -f "$PID_FILE"; then
	echo "Sending KILL signal to New Relic Infrastructure agent."
        kill `cat $PID_FILE`
        rm $PID_FILE
        rm /home/Qhttpd/Web/NewRelicInfraAgent
        rm $NEWRELIC_SETTINGS_FILE
    fi
    ;;

  restart)
    $0 stop
    $0 start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
