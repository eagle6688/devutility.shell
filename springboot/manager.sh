#!/bin/sh
APP_NAME=sutanghome

##Java environment
JAVA_HOME=/usr/local/java
JRE_HOME=$JAVA_HOME/jre

APP_JAR=$APP_NAME\.jar
APP_PID=$APP_NAME\.pid

#Description for this shell.
usage() {
    echo "Usage: sh springboot.sh [start|stop|restart|status]"
    exit 0
}

#App is running or not?
is_running() {
    pid=`ps -ef|grep $APP_JAR|grep -v grep|awk '{print $2}' `;

    if [ -z "${pid}" ]; then
        return 1
    else
        return 0
    fi
}

#Start
start() {
    is_running

    if [ $? -eq "0" ]; then
        echo ">>> ${APP_JAR} is already running PID=${pid} <<<"
    else
        nohup $JRE_HOME/bin/java -jar $APP_JAR >/dev/null 2>&1 &
        echo $! > $APP_PID
        echo ">>> Start $APP_JAR successed PID=$! <<<"
    fi
}

#Stop
stop() {
    app_pid=$(cat $APP_PID)
    echo ">>> Start kill $app_pid <<<"
    kill $app_pid
    rm -rf $APP_PID
    
    sleep 2
    is_running

    if [ $? -eq "0" ]; then
        echo ">>> Start kill -9 $app_pid  <<<"
        kill -9 $app_pid
        sleep 2
    fi

    echo ">>> ${APP_JAR} process stopped <<<"
}

#Status of App
status() {
    is_running

    if [ $? -eq "0" ]; then
        echo ">>> ${APP_JAR} is running PID is ${pid} <<<"
    else
        echo ">>> ${APP_JAR} is not running <<<"
    fi
}

#Restart App
restart() {
    stop
    start
}

case "$1" in
  "start")
    start
    ;;
  "stop")
    stop
    ;;
  "status")
    status
    ;;
  "restart")
    restart
    ;;
  *)
    usage
    ;;
esac
exit 0