#!/bin/bash

cd ../.. ;
git clone https://GITHUB_USER_TOKEN@github.com/TIBCOSoftware/mashling-cicd.git ;
pwd ;
mkdir -p tmp ;
echo "alert 1";
cp -r mashling-cicd/sample-recipes/builds/latest/rest-conditional-gateway/rest-conditional-gateway-osx.zip /tmp
echo "alert 2" ;
cd tmp ;
echo "alert 3" ;
chmod 755 rest-conditional-gateway-linux.zip ;
echo "alert 4" ;
unzip -o rest-conditional-gateway-linux.zip ;
echo "alert 5" ;
cd rest-conditional-gateway-linux ;
echo "alert 6" ;
./rest-conditional-gateway-linux ;

echo "alert 7" ;
curl -I -X GET http://localhost:9096/pets/2













#if [ -n "${TRAVIS_TAG}" ]; then
#docker pull tibdocker.tibco.com/mashling/mashling-sample:latest
#docker run -it -p 9096:9096 tibdocker.tibco.com/mashling/mashling-sample:latest
#fi

#if [ -z "${TRAVIS_TAG}" ]; then
#docker pull tibdocker.tibco.com/mashling/mashling-sample:master
#docker run -it -p 9096:9096 tibdocker.tibco.com/mashling/mashling-sample:master
#fi

#curl -I -X GET http://localhost:9096/pets/2
#curl -I -X PUT -d '{"name":"CAT"}' http://localhost:9096/pets
#curl -I -X PUT -d '{"name":"CATs"}' http://localhost:9096/pets