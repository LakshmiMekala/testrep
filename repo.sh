#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}

function testcase1 {
	cd $GOPATH/kafka
	echo zookeeper
	bin/zookeeper-server-start.sh config/zookeeper.properties > /tmp/zookeeper.log &
	pId=$!
	sleep 10

	# starting kafka server in background
	echo server
	bin/kafka-server-start.sh config/server.properties > /tmp/kafka.log &
	pId1=$!
	sleep 10

	echo gateway
	cd $GOPATH/KafkaTrigger-To-KafkaPublisher/bin
	export FLOGO_LOG_LEVEL=ERROR
	./kafkatrigger-to-kafkapublisher > /tmp/kafka-testcase1.log 2>&1 &
	pId2=$!
	sleep 10

	testTime=5
	echo started
	cd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher/my_project
	sed -i "/run_time/c\run_time = $testTime" config.cfg
	cd ..
	multimech-run my_project &
    pId9=$!
	echo completed
	sleep 30
	kill -SIGINT $pId
    kill -9 $pId9
	sleep 5
	kill -SIGINT $pId1
	sleep 5
	kill -SIGINT $pId2

	cd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher/my_project/results
	cd */
	transactions=$(xmllint --html -xpath "string(/html/body/table[1]/tr[2]/td[1])" results.html)
	text=$(xmllint --html -xpath "string(/html/body/div)" results.html)
	responseTime=$(xmllint --html -xpath "string(/html/body/table[1]/tr[2]/td[3])" results.html)
	echo transactions=$transactions
	echo text=$text
	echo responseTime=$responseTime
	errors=$(echo $text | awk '{print $4}')
	echo errors=$errors
	cd ../..
	rm -rf results && mkdir results
    pushd $GOPATH/KafkaTrigger-To-KafkaPublisher/bin
    cp /tmp/kafka-testcase1.log $GOPATH
    popd
}

function testcase2 {
	cd $GOPATH/kafka
	echo zookeeper
	bin/zookeeper-server-start.sh config/zookeeper.properties > /tmp/zookeeper.log &
	pId=$!
	sleep 10

	# starting kafka server in background
	echo server
	bin/kafka-server-start.sh config/server.properties > /tmp/kafka.log &
	pId1=$!
	sleep 10

	echo gateway
	cd $GOPATH/KafkaTrigger-To-KafkaPublisher/bin
	export FLOGO_LOG_LEVEL=ERROR
	./kafkatrigger-to-kafkapublisher > /tmp/kafka-testcase2.log 2>&1 &
	pId2=$!
    ps -a &
	sleep 10

	testTime=180
    Threads=100
	echo started
	cd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher/my_project
	sed -i "/run_time/c\run_time = $testTime" config.cfg
    sed -i "/threads/c\threads = $Threads" config.cfg
	cd ..
	multimech-run my_project &
    pId9=$!
	echo completed
	sleep 190
	#echo var=$var
	kill -SIGINT $pId
	sleep 5
    kill -9 $pId9
	kill -SIGINT $pId1
	sleep 5
	kill -SIGINT $pId2

	cd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher/my_project/results
	cd */
	transactions=$(xmllint --html -xpath "string(/html/body/table[1]/tr[2]/td[1])" results.html)
	text=$(xmllint --html -xpath "string(/html/body/div)" results.html)
	responseTime=$(xmllint --html -xpath "string(/html/body/table[1]/tr[2]/td[3])" results.html)
	echo transactions=$transactions
	echo text=$text
	echo responseTime=$responseTime
	errors=$(echo $text | awk '{print $4}')
	echo errors=$errors
	cd ../..
	rm -rf results && mkdir results
    pushd $GOPATH/KafkaTrigger-To-KafkaPublisher/bin
    cp /tmp/kafka-testcase2.log $GOPATH
    popd
}