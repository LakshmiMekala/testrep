#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 )
    echo "${my_list[@]}"
}

function testcase1 {
	cd $GOPATH/kafka
	echo zookeeper
	bin/zookeeper-server-start.sh config/zookeeper.properties > /tmp/kafka.log &
	pId=$!
	sleep 10

	# starting kafka server in background
	echo server
	bin/kafka-server-start.sh config/server.properties > /tmp/kafka.log &
	pId1=$!
	sleep 10

	echo gateway
	cd $GOPATH/KafkaTrigger-To-KafkaPublisher/bin
	env FLOGO_LOG_LEVEL=ERROR
	./kafkatrigger-to-kafkapublisher > /tmp/gateway.log 2>&1 &
	pId2=$!
	sleep 10

	testTime=5
	#var="$(timeout 70s multimech-run my_project &)"
	echo started
	cd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher
	sed -i "/run_time/c\run_time = $testTime" config.cfg
	cd ..
	multimech-run my_project
	echo completed
	sleep 30
	#echo var=$var
	kill -SIGINT $pId
	sleep 5
	kill -SIGINT $pId1
	sleep 5
	kill -SIGINT $pId2

	cd my_project/results
	cd */

	echo results
	transactions=$(xmllint --html -xpath "string(/html/body/table[1]/tr[2]/td[1])" results.html)
	text=$(xmllint --html -xpath "string(/html/body/div)" results.html)
	responseTime=$(xmllint --html -xpath "string(/html/body/table[1]/tr[2]/td[3])" results.html)
	echo transactions=$transactions
	echo text=$text
	echo responseTime=$responseTime
	errors=$(echo $text | awk '{print $4}')
	echo errors=$errors
	cd ..
	cd ..
	rm -rf results && mkdir results
}

function testcase2 {
	cd $GOPATH/kafka
	echo zookeeper
	bin/zookeeper-server-start.sh config/zookeeper.properties > /tmp/kafka.log &
	pId=$!
	sleep 10

	# starting kafka server in background
	echo server
	bin/kafka-server-start.sh config/server.properties > /tmp/kafka.log &
	pId1=$!
	sleep 10

	echo gateway
	cd $GOPATH/KafkaTrigger-To-KafkaPublisher/bin
	env FLOGO_LOG_LEVEL=ERROR
	./kafkatrigger-to-kafkapublisher > /tmp/gateway.log 2>&1 &
	pId2=$!
	sleep 10

	testTime=10
	#var="$(timeout 70s multimech-run my_project &)"
	echo started
	cd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher
	sed -i "/run_time/c\run_time = $testTime" config.cfg
	cd ..
	multimech-run my_project
	echo completed
	sleep 30
	#echo var=$var
	kill -SIGINT $pId
	sleep 5
	kill -SIGINT $pId1
	sleep 5
	kill -SIGINT $pId2

	cd my_project/results
	cd */

	echo results
	#sed -n 's/.*src="\([^"]*\).*/\1/p' results.html

	#cat results.html | grep -Eo "(transactions:|errors:)://[a-zA-Z0-9./?=_-]*" | sort | uniq

	#tidy -q -asxml --numeric-entities yes results.html >results.xml
	transactions=$(xmllint --html -xpath "string(/html/body/table[1]/tr[2]/td[1])" results.html)
	text=$(xmllint --html -xpath "string(/html/body/div)" results.html)
	responseTime=$(xmllint --html -xpath "string(/html/body/table[1]/tr[2]/td[3])" results.html)
	echo transactions=$transactions
	echo text=$text
	echo responseTime=$responseTime
	errors=$(echo $text | awk '{print $4}')
	echo errors=$errors
	cd ..
	cd ..
	rm -rf results && mkdir results
}
