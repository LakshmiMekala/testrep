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
	cd $GOPATH/KafkaTrigger-To-KafkaPublisher/bin
	export FLOGO_LOG_LEVEL=ERROR
	export FLOGO_RUNNER_TYPE=POOLED
	export FLOGO_RUNNER_WORKERS=5
	export FLOGO_RUNNER_QUEUE=50
	./kafkatrigger-to-kafkapublisher > /tmp/kafka-testcase1.log 2>&1 &
	pId2=$! &
	sleep 10

	testTime=5
	Threads=1
	echo started
	cd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher/my_project
	sed -i "/run_time/c\run_time = $testTime" config.cfg
	sed -i "/threads/c\threads = $Threads" config.cfg
	cd ..
	ps -a
	multimech-run my_project > /tmp/test-1.log 2>&1 & pid9=$!
	echo +++++++++++++++++++
	ps -a
	echo +++++++++++++++++++
	sleep 30	
	echo completed
	sleep 10
	kill -s TERM $pid9
	kill -s TERM $pId
	sleep 5
	kill -s TERM $pId1
	sleep 5
	kill -s TERM $pId2
	sleep 5
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
	pushd $GOPATH/KafkaTrigger-To-KafkaPublisher/bin
	cp /tmp/kafka-testcase1.log $GOPATH
	popd
	rm -rf results && mkdir results
	sleep 20
	echo ===========================
	ps -a
	echo ===========================
	sleep 20	
}

function testcase2 {
	cd $GOPATH/kafka
	echo ===========================-----------------
	ps -a
	echo ===========================-----------------------
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
	export FLOGO_RUNNER_TYPE=POOLED
	export FLOGO_RUNNER_WORKERS=5
	export FLOGO_RUNNER_QUEUE=50
	./kafkatrigger-to-kafkapublisher > /tmp/kafka-testcase2.log 2>&1 &	pId2=$!
	sleep 10

	testTime=180
    Threads=100
	echo started
	cd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher/my_project
	sed -i "/run_time/c\run_time = $testTime" config.cfg
    sed -i "/threads/c\threads = $Threads" config.cfg
	cd ..
	ps -a
	multimech-run my_project  & 
	pId3=$!
	echo !!!!!!!!!!!!!!!!!
	ps -a
    sleep 190
    echo pid3=$pId3
    var=$(ps --ppid $pId3)
    echo var=$var
    pId4=$(echo $var | awk '{print $5}')
    echo 4=$pId4
    echo completed
    sleep 10
    kill -9 $pId4
	#echo var=$var
	kill -s TERM $pId
	sleep 5
	kill -s TERM $pId1
	sleep 5
	kill -9 $pId2

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
	pushd $GOPATH/KafkaTrigger-To-KafkaPublisher/bin
	cp /tmp/kafka-testcase2.log $GOPATH
	popd
	rm -rf results && mkdir results
	
	cd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher
	cat /tmp/test-2.log

	echo ===========================-----------------
	ps -a
	echo ===========================-----------------------
}
