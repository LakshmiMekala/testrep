#!/bin/bash

# install pre-requisites

#if [[ -n $PERFORMANCETESTRUN ]] ; then
    chmod ugo+x ./pre-requisites.sh ./NewPerformance.sh ./kafkaPerformance.sh ./repo.sh ./kafkaPerf.sh
    echo =================++++++++++++++++==========
	ps -a
	echo ===============+++++++++++++++++++++============
    ./pre-requisites.sh
    ./NewPerformance.sh
#fi