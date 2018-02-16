#!/bin/bash

##Installing pre requisites to run performance test
   sudo apt-get install zookeeperd
   sudo apt-get install libxml2-utils
   sudo apt-get update -q      
   sudo apt install python3.6
   sudo pip install kafka-python
   python --version
   echo ^^^^^^^^^^^^^^^^^^^^^^^^^^^
   pip freeze
   echo ^^^^^^^^^^^^^^^^^^^^^^^^^^^
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
    echo "========java -classpath $CLASSPATH net.grinder.Grinder $GRINDERPROPERTIES=========="
    #    java -classpath $CLASSPATH net.grinder.Grinder $GRINDERPROPERTIES
    #    java -classpath $CLASSPATH net.grinder.Console
    
    mkdir grinder/bin
    cd bin
    echo "java -classpath $CLASSPATH net.grinder.Grinder $GRINDERPROPERTIES" > startAgent.sh
    # Installing multi mechanize
    sudo apt-get install python-pip python-matplotlib > /tmp/install.log 2>&1
    sudo pip install -U multi-mechanize
    cp $GOPATH/src/github.com/LakshmiMekala/testrep/rest-performance-testing/Http-example.py $GOPATH/grinder
    cp $GOPATH/src/github.com/LakshmiMekala/testrep/rest-performance-testing/Http-example_WithoutGateway.py $GOPATH/grinder
    cd $GOPATH/grinder/examples
    echo ---------------------------------------
    ls -ll;
    echo ---------------------------------------
    # chmod 777 Http-example_WithoutGateway.py Http-example.py
    # chmod ugo+x Http-example_WithoutGateway.py Http-example.py  
    # os.chmod("Http-example_WithoutGateway.py", 0o777)
    # os.chmod("Http-example.py", 0o777)
    popd