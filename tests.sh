#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 testcase2 )
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
	export FLOGO_LOG_LEVEL=ERROR
	./kafkatrigger-to-kafkapublisher > /tmp/kafka-testcase1.log 2>&1 &
	pId2=$!
	sleep 10

	testTime=180
	Threads=10
	#var="$(timeout 70s multimech-run my_project &)"
	echo started
	cd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher/my_project
	sed -i "/run_time/c\run_time = $testTime" config.cfg
	sed -i "/threads/c\threads = $Threads" config.cfg
	
	cd ..
	multimech-run my_project &
	pId3=$!	
	 sleep 200
	echo pid3=$pId3
	# var=$(ps --ppid $pId3)
	# echo var=$var
	# pId4=$(echo $var | awk '{print $5}')
	# echo 4=$pId4
	# echo completed
	# sleep 10
	# kill -9 $pId4
	#echo var=$var
	sleep 40
	echo -----------
	ps -a
	echo -----------
	pkill -9 -g $pId3
	ps -a
	echo -----------
	kill -- -$(ps -o pgid= $pId3 | grep -o [0-9]*)
	ps -a
	echo -----------
	kill -SIGINT $pId
	kill -s TERM $pId
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
	cp -r results $GOPATH/results
	rm -rf results && mkdir results
	pushd $GOPATH/KafkaTrigger-To-KafkaPublisher/bin
	cp /tmp/kafka-testcase1.log $GOPATH
	popd
	pushd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher
	cp /tmp/run1.log $GOPATH
	popd
	sleep 20
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
	export FLOGO_LOG_LEVEL=ERROR
	./kafkatrigger-to-kafkapublisher > /tmp/kafka-testcase2.log &
	pId2=$!
	sleep 10

	testTime=100
	Threads=1
	#var="$(timeout 70s multimech-run my_project &)"
	echo started
	cd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher/my_project
	sed -i "/run_time/c\run_time = $testTime" config.cfg
	sed -i "/threads/c\threads = $Threads" config.cfg
	cd ..
	multimech-run my_project & pId3=$!
	echo completed
	sleep 60
	#echo var=$var
	pkill -9 -g $pId3
	kill -SIGINT $pId
	kill -s TERM $pId
	sleep 5
	kill -SIGINT $pId1
	sleep 5
	kill -SIGINT $pId2
	kill -SIGINT $pId3

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
	cp results $GOPATH/results2
	rm -rf results && mkdir results
	pushd $GOPATH/KafkaTrigger-To-KafkaPublisher/bin
	cp /tmp/kafka-testcase2.log $GOPATH
	popd
	pushd $GOPATH/src/github.com/LakshmiMekala/testrep/KafkaTrigger-To-KafkaPublisher
	cp /tmp/run2.log $GOPATH
	popd
}