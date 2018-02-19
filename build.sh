#!/bin/bash

# install pre-requisites

#if [[ -n $PERFORMANCETESTRUN ]] ; then
    chmod ugo+x ./pre-requisites.sh ./NewPerformance.sh ./kafkaPerformance.sh ./repo.sh ./kafkaPerf.sh
    ./pre-requisites.sh
    ./NewPerformance.sh
#fi