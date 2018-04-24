#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 testcase2 )
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
	export FLOGO_LOG_LEVEL=ERROR
	export FLOGO_RUNNER_TYPE=POOLED
	export FLOGO_RUNNER_WORKERS=5
	export FLOGO_RUNNER_QUEUE=50
	cd $GOPATH/src/github.com/TIBCOSoftware/mashling
	./bin/mashling-gateway -c $PERFPATH/KafkaTrigger-To-KafkaPublisher.json > /tmp/kafka-testcase1.log 2>&1 &
	pId2=$!
	sleep 10

	testTime=5
	Threads=1
	echo started
	cd $PERFPATH/KafkaTrigger-To-KafkaPublisher/my_project
	sed -i "/run_time/c\run_time = $testTime" config.cfg
	sed -i "/threads/c\threads = $Threads" config.cfg
	cd ..
	multimech-run my_project &
	pId3=$!    
    sleep 30
    echo pid3=$pId3
    var=$(ps --ppid $pId3)
    echo var=$var
    pId4=$(echo $var | awk '{print $5}')
    echo 4=$pId4
    echo completed
    sleep 10
    kill -9 $pId4
	kill -9 $pId
	sleep 5
	kill -9 $pId1
	sleep 5
	kill -SIGINT $pId2

	cd $PERFPATH/KafkaTrigger-To-KafkaPublisher/my_project/results
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
	pushd $GOPATH/src/github.com/TIBCOSoftware/mashling
	cp /tmp/kafka-testcase1.log $GOPATH
	popd
	rm -rf results && mkdir results
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
	export FLOGO_LOG_LEVEL=ERROR
	export FLOGO_RUNNER_TYPE=POOLED
	export FLOGO_RUNNER_WORKERS=5
	export FLOGO_RUNNER_QUEUE=50	
	cd $GOPATH/src/github.com/TIBCOSoftware/mashling
	./bin/mashling-gateway -c $PERFPATH/KafkaTrigger-To-KafkaPublisher.json > /tmp/kafka-testcase2.log 2>&1 &
	pId2=$!
	sleep 10

	testTime=1800
    Threads=100
	echo started
	cd $PERFPATH/KafkaTrigger-To-KafkaPublisher/my_project
	sed -i "/run_time/c\run_time = $testTime" config.cfg
    sed -i "/threads/c\threads = $Threads" config.cfg
	cd ..
	multimech-run my_project &
	pId3=$!    
    sleep 2200
    echo pid3=$pId3
    var=$(ps --ppid $pId3)
    echo var=$var
    pId4=$(echo $var | awk '{print $5}')
    echo 4=$pId4
    echo completed
    sleep 10
    kill -9 $pId4
	kill -9 $pId4
	#echo var=$var
	kill -9 $pId
	sleep 5
	kill -9 $pId1
	sleep 5
	kill -SIGINT $pId2

	cd $PERFPATH/KafkaTrigger-To-KafkaPublisher/my_project/results
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
	pushd $GOPATH/src/github.com/TIBCOSoftware/mashling
	cp /tmp/kafka-testcase2.log $GOPATH
	popd
	rm -rf results && mkdir results
}