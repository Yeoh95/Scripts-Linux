#!/bin/bash
# description: Tomcat Start Stop Restart
# processname: tomcat
# chkconfig: 234 20 80
CATALINA_HOME=/usr/local/tomcat
case $1 in
start)
sh $CATALINA_HOME/bin/startup.sh
;;
stop)
sh $CATALINA_HOME/bin/shutdown.sh
kill -9 $(ps -ef | grep java | grep tomcat | cut -c10-14)
;;
restart)
sh $CATALINA_HOME/bin/shutdown.sh
kill -9 $(ps -ef | grep java | grep tomcat | cut -c10-14)
sh $CATALINA_HOME/bin/startup.sh
;;
esac
exit 0

