#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}
function testcase1 {

    pushd $GOPATH/kafka
    # starting zookeeper in background
    bin/zookeeper-server-start.sh config/zookeeper.properties > /tmp/kafka.log &
    pId=$!
    sleep 10

    # starting kafka server in background
    bin/kafka-server-start.sh config/server.properties > /tmp/kafka.log &
    pId1=$!
    sleep 10    

    popd
	
    #executing the gateway binary
    ./resttrigger-to-kafkapublisher > /tmp/output.log &
    pId3=$!
    sleep 20

    cd $GOPATH/kafka
    current_time=$(date "+%Y.%m.%d-%H.%M.%S")
	
	curl -X PUT "http://localhost:9096/pets" -H "accept: application/xml" -H "Content-Type: application/json" -d '{"category": {"id": 16,"name": "Animals"},"id": 16,"name": "SPARROW","photoUrls": ["string"],"status": "sold","tags": [{	"id": 0,"name": "string"}]}'

    #passing message from kafka producer
   bin/kafka-console-consumer.sh --topic syslog --bootstrap-server localhost:9092 --from-beginning > /tmp/test.log & pId4=$!  
    sleep 2
	
	binaryoutput=$(cat /tmp/kafka.log)
	consumer-output=$(cat /tmp/test.log)
	echo =====================================================
	echo binaryoutput
	echo =====================================================
	echo consumer-output
	echo =====================================================
	
    

   echo $kafkaMessage;
    kill -SIGINT $pId1
    sleep 5
    kill -SIGINT $pId
    sleep 5
    kill -SIGINT $pId4
    sleep 5
    kill -SIGINT $pId3
    echo "{\"country\":\"USA\",\"Current Time\" :\"$current_time\"}"

    if [ "cat /tmp/test.log | grep $output" == "$output" ] 
        then 
            echo "PASS"   
        else
            echo "FAIL"
    fi
    rm -f /tmp/test.log /tmp/kafka.log
}
