#!/bin/bash

##Installing pre requisites to run performance test
   sudo apt-get install zookeeperd
   sudo apt-get install libxml2-utils
   sudo pip install kafka-python
   sudo apt-get update q
   pushd $GOPATH   
   wget http://www-eu.apache.org/dist/kafka/1.0.0/kafka_2.11-1.0.0.tgz -O $GOPATH/kafka.tgz
   mkdir -p $GOPATH/kafka && cd $GOPATH/kafka
   tar -xvzf $GOPATH/kafka.tgz --strip 1 > /tmp/kafka.log
   cd $GOPATH
   ls
   wget https://sourceforge.net/projects/grinder/files/latest/download $GOPATH/download.zip
   unzip $GOPATH/download > /tmp/grinder.log
   rm -f download
   mv grinder-* grinder
   #setting grinder paths
    GRINDERPATH=$GOPATH/grinder
    GRINDERPROPERTIES=$GOPATH/grinder/examples/grinder.properties
    CLASSPATH=$GRINDERPATH/lib/grinder.jar:$CLASSPATH
    JAVA_HOME=$JAVA_HOME
    PATH=$JAVA_HOME/bin:$PATH
    export CLASSPATH PATH GRINDERPROPERTIES
    #    java -classpath $CLASSPATH net.grinder.Grinder $GRINDERPROPERTIES
    #    java -classpath $CLASSPATH net.grinder.Console
    
    # Installing multi mechanize
    sudo apt-get install python-pip python-matplotlib
    sudo pip install -U multi-mechanize
    cp $GOPATH/src/github.com/LakshmiMekala/testrep/rest-performance-testing/Http-example.py $GOPATH/grinder/examples
    cp $GOPATH/src/github.com/LakshmiMekala/testrep/rest-performance-testing/Http-example_WithoutGateway.py $GOPATH/grinder/examples
    cd $GOPATH/grinder/examples
    chmod 777 Http-example_WithoutGateway.py Http-example.py
    chmod ugo+x Http-example_WithoutGateway.py Http-example.py  
    popd