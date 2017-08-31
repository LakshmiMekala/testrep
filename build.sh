#!/bin/bash

if [ -n "${TRAVIS_TAG}" ]; then
#docker pull tibdocker.tibco.com/mashling/mashling-sample:latest
docker run -it -p 9096:9096 tibdocker.tibco.com/mashling/mashling-sample:latest
fi

if [ -z "${TRAVIS_TAG}" ]; then
#docker pull tibdocker.tibco.com/mashling/mashling-sample:master
docker run -it -p 9096:9096 tibdocker.tibco.com/mashling/mashling-sample:master
fi

#curl -I -X GET http://localhost:9096/pets/2
#curl -I -X PUT -d '{"name":"CAT"}' http://localhost:9096/pets
curl -I -X PUT -d '{"name":"CATs"}' http://localhost:9096/pets