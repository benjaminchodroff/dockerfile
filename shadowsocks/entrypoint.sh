#!/bin/bash

PORT=8388
PASS=88888888
SS_CONFIG=${SS_CONFIG:-"-s 0.0.0.0 -p $PORT -m salsa20 -k $PASS --fast-open --no-delay --plugin obfs-server --plugin-opts 'obfs=http'"}
SS_MODULE=${SS_MODULE:-"ss-server"}
KCP_CONFIG=${KCP_CONFIG:-"-t 0.0.0.0:$PORT -l :$PORT -mode fast2 -key $PASS -crypt salsa20"}
KCP_MODULE=${KCP_MODULE:-"kcpserver"}
KCP_FLAG=${KCP_FLAG:-"true"}

while getopts "s:m:k:e:x" OPT; do
    case $OPT in
        s)
            SS_CONFIG=$OPTARG;;
        m)
            SS_MODULE=$OPTARG;;
        k)
            KCP_CONFIG=$OPTARG;;
        e)
            KCP_MODULE=$OPTARG;;
        x)
            KCP_FLAG="true";;
    esac
done

if [ "$KCP_FLAG" == "true" ] && [ "$KCP_CONFIG" != "" ]; then
    echo -e "\033[32mStarting kcptun......\033[0m"
    $KCP_MODULE $KCP_CONFIG 2>&1 &
else
    echo -e "\033[33mKcptun not started......\033[0m"
fi

if [ "$SS_CONFIG" != "" ]; then
    echo -e "\033[32mStarting shadowsocks......\033[0m"
    $SS_MODULE $SS_CONFIG
else
    echo -e "\033[31mError: SS_CONFIG is blank!\033[0m"
    exit 1
fi
