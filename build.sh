#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}
function testcase1 {

    cd ../kafka
    
    bin/zookeeper-server-start.sh config/zookeeper.properties &
    pId=$!
    echo "zookeeper pid : [$pId]"
    sleep 10

    bin/kafka-server-start.sh config/server.properties &
    pId1=$!
    echo "kafka pid : [$pId1]"
    sleep 10

    bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic publishpet

    sleep 5

    cd ../testrep
    chmod 777 kafkatrigger-to-kafkapublisher
    ./kafkatrigger-to-kafkapublisher &
    pId4=$!
    echo "kafka gateway pid : [$pId4]"
    sleep 20

    cd ../kafka
    current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    echo "{\"country1\":\"USA\",\"Current Time\" :\"$current_time\"}" | bin/kafka-console-producer.sh --broker-list localhost:9092 --topic publishpet & kafkaProducerPID=$!
    #bin/kafka-console-producer.sh --broker-list localhost:9092 --topic syslog   --property "parse.key=true"  --property "key.separator=:"  key1:USA &
    sleep 5
    kill -SIGINT $kafkaProducerPID
    echo "After killing"
    # kafkaMessage="$(bin/kafka-console-consumer.sh --topic publishpet1 --bootstrap-server localhost:9092 --timeout-ms 9000 --consumer.config /home/ramesh/Downloads/abc/kafka/config/consumer.properties)"
    sleep 2
    echo "Test 0"
    bin/kafka-console-consumer.sh --topic subscribepet --bootstrap-server localhost:9092 --from-beginning & pid5=$!
    sleep 2
    echo "Test 1"
    kafkaMessage="$(bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic publishpet --timeout-ms 10000 --consumer.config $GOPATH/kafka/config/consumer.properties ) "
    
     echo "Test 0"
    samplevalue= $(bin/kafka-console-consumer.sh --topic subscribepet --bootstrap-server localhost:9092 --from-beginning) & pid6=$!
    sleep 2
    echo "value is : [$samplevalue]"

	echo "kafka message value : [$kafkaMessage]"

    echo "received message : [$kafkaMessage]" 
    echo "actual message : [{\"country1\":\"USA\",\"Current Time\" :\"$current_time\"}]"

    if [ "$kafkaMessage" == "{\"country1\":\"USA\",\"Current Time\" :\"$current_time\"}" ] 
        then 
            echo "PASS"   
        else
            echo "FAIL"
    fi
    cd ..
}
