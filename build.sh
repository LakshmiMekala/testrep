#!/bin/bash

# install pre-requisites

if [[ -n $PERFORMANCETESTRUN ]] ; then
    chmod ugo+x ./pre-requisites.sh
    ./pre-requisites.sh
fi