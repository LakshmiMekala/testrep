#!/bin/bash

cd $GOPATH
PERFPATH=$GOPATH/src/github.com/TIBCOSoftware/mashling-cicd/performance-scripts

FILENAME="PerformanceReport.html"
HTML="<!DOCTYPE html><html><head><style>table{font-family: arial, sans-serif;border-collapse: collapse;margin: auto;}td{border: 1px solid #dddddd;text-align: center;padding: 8px;}th {border: 1px solid #dddddd;text-align: left;padding: 8px;}th{background: #003399;text-align: center;color: #fff;}body{padding-right: 15px;padding-left: 15px;margin-right: auto;margin-left: auto;}label {font-weight: bold;}.test-report h1{color: #003399;font-size: 30px}.summary,.test-report{text-align: center;}.note{font-style: italic;
}.font_size{font-size: 22px;}.test-report h2{color: #003399;text-align: center;}.success{background-color: #79d279;}.error{background-color: #ff3300;}.summary-tbl{font-weight: bold;}.summary-tbl td{border: none;}.content1{border-style: hidden;width: 65em;word-wrap: break-word;}.content1 td,th{border:none;text-align: left;}</style></head><body><section class=test-report><h1>Gateway Performance Test Report</h1></section><section class=test-report><h2 class=font_size>Rest Conditional Gateway Performance Test Report</h2><table class=content1><tr><td>Gateway details</td><td>:</td><td>Gateway app is created using <a href="https://github.com/TIBCOSoftware/mashling-cicd/blob/master/performance-scripts/rest-conditional-gateway.json">Rest-Conditional-Gateway.json</a>  (one gorillamux http trigger + one GET handler)</td></tr><tr><td>Test case</td><td>:</td><td>Pre-condition: Run gateway with environment flags,<br/>FLOGO_LOG_LEVEL=ERROR<br/>FLOGO_RUNNER_TYPE=POOLED<br/>FLOGO_RUNNER_WORKERS=5<br/>FLOGO_RUNNER_QUEUE=60<br/><br/>Test details: Perform http GET operation on - http://localhost:9096/pets/24<br/>Expect response like - {"Name":"mashling","Number":"200"}</td></tr><br/><tr><td>Environment details</td><td>:</td><td><a href="https://travis-ci.org/TIBCOSoftware/mashling">Travis-Ubuntu</a> Instance with <a href="http://grinder.sourceforge.net/">Grinder</a>installed<br/>Gateway and service endpoint both running on the same Travis-Ubuntu instance.</td></tr></table></br></br></br><table><tr><th>Trigger Type</th><th>Transactions/Sec</th><th>No of Tests</th><th>Errors</th><th>Test Time(Sec)</th></tr></table></section><br /><br /><section class=test-report><h2 class=font_size>Kafka Trigger to Kafka Publisher Gateway Performance Test Report</h2><table class=content1><tr><td>Gateway details</td><td>:</td><td>gateway app is created using <a href="https://github.com/TIBCOSoftware/mashling-cicd/blob/master/performance-scripts/KafkaTrigger-To-KafkaPublisher.json">KafkaTrigger-To-KafkaPublisher.json</a> (one kafka trigger + one kafka publisher handler)</td></tr><tr><td>Test case</td><td>:</td><td>Pre-condition: Run gateway with environment flags,<br/>FLOGO_LOG_LEVEL=ERROR<br/>FLOGO_RUNNER_TYPE=POOLED<br/>FLOGO_RUNNER_WORKERS=5<br/>FLOGO_RUNNER_QUEUE=50<br/><br/>Test details: Send message to kafka topic - "publishpet" and expect same message on the topic - "subscribepet".</td></tr><tr><td>Environment details</td><td>:</td><td><a href="https://travis-ci.org/TIBCOSoftware/mashling">Travis-Ubuntu</a> Instance with <a href="https://multi-mechanize.readthedocs.io/en/latest/">Multi-mechanize</a>, <a href="https://kafka.apache.org/">Kafka</a>,<a href="https://zookeeper.apache.org/">ZooKeeper</a> <a href="https://pypi.python.org/pypi/kafka-python">Kafka Python</a> installed<br/>Gateway, kafka & zookeper running on the same Travis-Ubuntu instance.</td></tr></table></br></br></br><table><tr><th>Trigger Type</th><th>Transaction Response Summary</th><th>No of Tests</th><th>Errors</th><th>Test Time(Sec)</th></tr></table></section></html>"
echo $HTML >> $GOPATH/$FILENAME

#Kafka Performance
# cd $PERFPATH
# source ./kafkaPerformance.sh
# value=($(get_test_cases))
# for ((i=0;i < ${#value[@]};i++))
#         do
#             ${value[i]}
#             sed -i "s/<tr><th>Trigger Type<\/th><th>Transaction Response Summary<\/th><th>No of Tests<\/th><th>Errors<\/th><th>Test Time(Sec)<\/th>/<tr><th>Trigger Type<\/th><th>Transaction Response Summary<\/th><th>No of Tests<\/th><th>Errors<\/th><th>Test Time(Sec)<\/th><\/tr><tr><td>KAFKA<\/td><td>$responseTime<\/td><td>$transactions<\/td><td>$errors<\/td><td>$testTime<\/td><\/tr>/g" $GOPATH/$FILENAME
#         done

#Rest Performance
# cd $PERFPATH/rest-performance-testing
# source ./Grinder.sh
# value=($(get_test_cases))
# for ((i=0;i < ${#value[@]};i++))
#         do
#             ${value[i]}
#             sed -i "s/<tr><th>Trigger Type<\/th><th>Transactions\/Sec<\/th><th>No of Tests<\/th><th>Errors<\/th><th>Test Time(Sec)<\/th>/<tr><th>Trigger Type<\/th><th>Transactions\/Sec<\/th><th>No of Tests<\/th><th>Errors<\/th><th>Test Time(Sec)<\/th><\/tr><tr><td>REST<\/td><td>$ELE2<\/td><td>${array[0]}<\/td><td>${array[1]}<\/td><td>$testTime<\/td><\/tr>/g" $GOPATH/$FILENAME
#         done

REPOFOLDER=mashling

mkdir ${HOME}/.aws
cat > ${HOME}/.aws/credentials <<EOL
[default]
aws_access_key_id = ${SITE_KEY}
aws_secret_access_key = ${SITE_KEY_SECRET}
EOL

function create_dest_directory ()
{
    cd perf-reports/$GIT_BRANCH_LOCAL ;
    echo +++++++++++++$REPOFOLDER-${GIT_BRANCH_LOCAL}-$BUILD_NUMBER++++++++++++++
    DESTFOLDER="$REPOFOLDER-${GIT_BRANCH_LOCAL}-$BUILD_NUMBER"
    if [ ! -d "$DESTFOLDER" ]; then
        mkdir "$DESTFOLDER" "latest";
    fi
    echo "Creating folder - $DESTFOLDER /"
    cd "$DESTFOLDER";
}

GIT_BRANCH_LOCAL=$(echo $GIT_BRANCH | sed -e "s|origin/||g")
pushd $GOPATH/src/github.com/TIBCOSoftware/mashling-cicd ;
mkdir -p perf-reports/$GIT_BRANCH_LOCAL;
create_dest_directory ;
cp $GOPATH/rest-testcase1.log "$GOPATH/src/github.com/TIBCOSoftware/mashling-cicd/perf-reports/$GIT_BRANCH_LOCAL/$DESTFOLDER"
cp $GOPATH/rest-testcase2.log "$GOPATH/src/github.com/TIBCOSoftware/mashling-cicd/perf-reports/$GIT_BRANCH_LOCAL/$DESTFOLDER"
cp $GOPATH/kafka-testcase1.log "$GOPATH/src/github.com/TIBCOSoftware/mashling-cicd/perf-reports/$GIT_BRANCH_LOCAL/$DESTFOLDER"
cp $GOPATH/kafka-testcase2.log "$GOPATH/src/github.com/TIBCOSoftware/mashling-cicd/perf-reports/$GIT_BRANCH_LOCAL/$DESTFOLDER"
cp "$GOPATH/$FILENAME" "$GOPATH/src/github.com/TIBCOSoftware/mashling-cicd/perf-reports/$GIT_BRANCH_LOCAL/$DESTFOLDER"
cp "$GOPATH/$FILENAME" "$GOPATH/src/github.com/TIBCOSoftware/mashling-cicd/perf-reports/$GIT_BRANCH_LOCAL/latest"
aws s3 cp "$GOPATH/src/github.com/TIBCOSoftware/mashling-cicd/perf-reports" "s3://$AWS_BUCKET/TIBCOSoftware/mashling" --recursive
popd ;

pushd $GOPATH/src/github.com/TIBCOSoftware/mashling-cicd/perf-reports/$GIT_BRANCH_LOCAL/$DESTFOLDER
echo 11111111111111111
ls -ll
echo 22222222222222222
popd