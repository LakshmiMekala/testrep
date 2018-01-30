#!/bin/bash

function get_test_cases {
    local my_list=( testcase1 testcase2 )
    echo "${my_list[@]}"
}

function testcase1 {
	cd $GOPATH/src/github.com/LakshmiMekala/testrep/rest-performance-testing
	go run server.go &	
	cd $GOPATH/rest-conditional-gateway/bin
	./rest-conditional-gateway > /tmp/testcase1.log 2>&1 &
	pId=$!
	sleep 10
	echo GATEWAY
	cd $GOPATH/grinder
	GRINDERPATH=$GOPATH/grinder
	GRINDERPROPERTIES=$GOPATH/grinder/examples/grinder.properties
	CLASSPATH=$GRINDERPATH/lib/grinder.jar:$CLASSPATH
	PATH=$JAVA_HOME/bin:$PATH
	export CLASSPATH PATH GRINDERPROPERTIES
	echo ++++++++++++++++++++++==$CLASSPATH+++++++++++++++++++++=
	sleep 5
	echo CONSOLE
	export DISPLAY=:0.0
	#cd bin
	#./startConsole.sh &	
	java -classpath $CLASSPATH net.grinder.Console -headless &
	pId1=$!
	sleep 10
	echo AGENT
	sleep 20
	#./startAgent.sh &
	java -classpath $CLASSPATH net.grinder.Grinder $GRINDERPROPERTIES &
	pId2=$!

	curl -X PUT -H "Content-Type: application/json" http://localhost:6373/properties -d '{"propertiesFile" : "grinder.properties"}'
	sleep 5
	curl -X POST http://localhost:6373/files/distribute
	sleep 5

	curl -H "Content-Type: application/json" -X POST http://localhost:6373/agents/start-workers -d '{"grinder.processes" : "2", "grinder.threads" : "1000", "grinder.runs" : "10000",  "grinder.script" : "Http-example_WithoutGateway.py" }' &
	testTime=10
	sleep $testTime
	json=$(curl -s http://localhost:6373/recording/data | jq -r '.totals | .[0,1,4]')
	set -f
	array=(${json// / })

	curl -X POST http://localhost:6373/recording/stop
	curl -X POST http://localhost:6373/agents/stop-workers

	echo json=$json
	echo ELE="${array[0]}"
	echo ELE1="${array[1]}"
	ELE2=${array[2]}
	echo ELE2="$ELE2"

	sleep 20 
	if (( $(echo "${array[2]} > 1500" | bc -l) ))
	then
		echo "PASS"
		array[3]='PASS'

	else
		echo "FAIL"
		array[3]='FAIL'
	fi
	echo pId=$pId
	echo pId1=$pId1
	echo pId2=$pId2
	kill -9 $pId
	kill -9 $pId1
	kill -9 $pId2
	kill $(lsof -t -i:9090)
	kill $(lsof -t -i:6373)
}

function testcase2 {
	cd $GOPATH/src/github.com/LakshmiMekala/testrep/rest-performance-testing
	go run server.go &
	cd $GOPATH/rest-conditional-gateway/bin
	./rest-conditional-gateway > /tmp/testcase2.log 2>&1 &
	pId=$!
	sleep 10
	echo GATEWAY
	cd $GOPATH/grinder
	GRINDERPATH=$GOPATH/grinder
	GRINDERPROPERTIES=$GOPATH/grinder/examples/grinder.properties
	CLASSPATH=$GRINDERPATH/lib/grinder.jar:$CLASSPATH
	PATH=$JAVA_HOME/bin:$PATH
	export CLASSPATH PATH GRINDERPROPERTIES
	sleep 5
	echo CONSOLE
	java -classpath $CLASSPATH net.grinder.Console -headless &
	pId1=$!
	sleep 10
	echo AGENT
	sleep 20
	java -classpath $CLASSPATH net.grinder.Grinder $GRINDERPROPERTIES &
	pId2=$!

	curl -X PUT -H "Content-Type: application/json" http://localhost:6373/properties -d '{"propertiesFile" : "grinder.properties"}'
	sleep 5
	curl -X POST http://localhost:6373/files/distribute
	sleep 5

	curl -H "Content-Type: application/json" -X POST http://localhost:6373/agents/start-workers -d '{"grinder.processes" : "2", "grinder.threads" : "1000", "grinder.runs" : "100",  "grinder.script" : "Http-example.py" }' &

	testTime=60
	sleep $testTime
	json=$(curl -s http://localhost:6373/recording/data | jq -r '.totals | .[0,1,4]')
	set -f
	array=(${json// / })

	curl -X POST http://localhost:6373/recording/stop
	curl -X POST http://localhost:6373/agents/stop-workers

	echo json=$json
	echo ELE="${array[0]}"
	echo ELE1="${array[1]}"
	ELE2=${array[2]}
	echo ELE2="$ELE2"

	sleep 20 
	if (( $(echo "${array[2]} > 1500" | bc -l) ))
	then
		echo "PASS"
		array[3]='PASS'

	else
		echo "FAIL"
		array[3]='FAIL'
	fi
	echo pId=$pId
	echo pId1=$pId1
	echo pId2=$pId2
	kill -9 $pId
	kill -9 $pId1
	kill -9 $pId2
	kill $(lsof -t -i:9090)
	kill $(lsof -t -i:6373)
}
