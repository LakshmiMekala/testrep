#!/bin/bash

# install pre-requisites

#if [[ -n $PERFORMANCETESTRUN ]] ; then
    chmod ugo+x ./pre-requisites.sh ./NewPerformance.sh
    ./pre-requisites.sh
    ./NewPerformance.sh
#fi