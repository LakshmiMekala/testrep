#!/bin/bash

##Installing pre requisites to run performance test
   sudo aptget install zookeeperd
   sudo aptget update q
   cd $GOPATH
   wget http://wwweu.apache.org/dist/kafka/1.0.0/kafka_2.111.0.0.tgz O $GOPATH/kafka.tgz
   mkdir p $GOPATH/kafka && cd $GOPATH/kafka
   tar xvzf $GOPATH/kafka.tgz strip 1 > /tmp/kafka.log
   cd $GOPATH
   wget https://sourceforge.net/projects/grinder/files/latest/download $GOPATH/grinder.zip
   mkdir p $GOPATH/grinder && cd $GOPATH/grinder
   unzip $GOPATH/grinder.zip strip 1 > /tmp/grinder.log
   cd $GOPATH 
   touch setGrinderEnv.sh
   echo "#!/usr/bin/ksh
        GRINDERPATH=$GOPATH/grinder
        GRINDERPROPERTIES=<em>(full path to grinder.properties)</em>/grinder.properties
        CLASSPATH=$GRINDERPATH/lib/grinder.jar:$CLASSPATH
        JAVA_HOME=<em>(full path to java installation directory)</em>
        PATH=$JAVA_HOME/bin:$PATH
        export CLASSPATH PATH GRINDERPROPERTIES" >> $GOPATH/setGrinderEnv.sh