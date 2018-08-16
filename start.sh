#!/bin/bash

_BASE_DIR=$(dirname $0)
_REDIS_HOME=/usr/local/redis2
_REDIS_DATA=/usr/local/var/redis2
_TIME_SLEEP=3

#start redis
Start_Redis() {

    #echo "Start_Redis"
    ${_REDIS_HOME}/bin/redis-server ${_REDIS_HOME}/conf/redis.conf

    while [ ! -f ${_REDIS_DATA}/redis.pid ]; do
        sleep ${_TIME_SLEEP} 
    done

    [ $? -eq 0 ] && touch ${_REDIS_DATA}/redis 
    
}


#exec trap and bash 
Trap_And_Bash() {

    #trap terminal signal when docker stop
    case $1 in
        exec)
         echo "trap 'pkill -SIGTERM -F ${_REDIS_DATA}/redis.pid; sleep ${_TIME_SLEEP}; rm -f ${_REDIS_DATA}/redis; exit 0' TERM" >> /home/redis/.bashrc
         exec /bin/bash
         ;;
        daemon)
         trap 'pkill -SIGTERM -F ${_REDIS_DATA}/redis.pid; sleep ${_TIME_SLEEP}; rm -f ${_REDIS_DATA}/redis; exit 0' TERM
         #loop...
         while : ; do
             :
         done
         ;;
        *)
         Error
         ;;
    esac


}


Error() {
    echo -e "Usage: $0 [ exec | daemon ]\nexec is to start Redis in bg\ndaemon is to start Redis in daemon"
    exit 1
}


if [ $# -eq 0 ] || [ $1 != "exec" -a $1 != "daemon" ]; then
    Error
fi

Start_Redis
Trap_And_Bash $1

exit $?
