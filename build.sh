#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}
# function testcase1 {

    pushd $GOPATH/kafka
    # starting zookeeper in background
    bin/zookeeper-server-start.sh config/zookeeper.properties > /tmp/kafka.log &
    pId=$!
    sleep 10

    # starting kafka server in background
    bin/kafka-server-start.sh config/server.properties > /tmp/kafka.log &
    pId1=$!
    sleep 10

    # creating kafka topic
    bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic users &
    pId2=$!
    sleep 10

    popd
	
    #executing the gateway binary
    chmod 777 event-dispatcher-router-mashling
    ./event-dispatcher-router-mashling > /tmp/test.log &
    pId4=$!
    sleep 20

    cd $GOPATH/kafka
    current_time=$(date "+%Y.%m.%d-%H.%M.%S")

    #passing message from kafka producer
    echo "{\"id\":15,\"country\":\"USA\",\"category\":{\"id\":0,\"name\":\"string\"},\"name\":\"doggie\",\"photoUrls\":[\"string\"],\"tags\":[{\"id\":0,\"name\":\"string\"}],\"status\":\"available\"}" | bin/kafka-console-producer.sh --broker-list localhost:9092 --topic users &  pId3=$!    
    sleep 20

    # starting kafka consumer in background and capturing logged messages into tmp/test file
	output={\"id\":15,\"country\":\"USA\",\"category\":{\"id\":0,\"name\":\"string\"},\"name\":\"doggie\",\"photoUrls\":[\"string\"],\"tags\":[{\"id\":0,\"name\":\"string\"}],\"status\":\"available\"}
    
	echo "kafka message value : [$(cat /tmp/test.log)]"	
    echo logs are : $(cat /tmp/test.log)

   echo $kafkaMessage;
    
    #echo "{\"country\":\"USA\",\"Current Time\" :\"$current_time\"}"

    if [ "cat /tmp/test.log | grep $output" == "$output" ] 
        then 
            echo "PASS"   
        else
            echo "FAIL"
    fi
    kill -SIGINT $pId1
    sleep 5
    kill -SIGINT $pId
    sleep 5
    kill -SIGINT $pId4
    sleep 5
    kill -SIGINT $pId5
    rm -f /tmp/test.log /tmp/kafka.log
# }
