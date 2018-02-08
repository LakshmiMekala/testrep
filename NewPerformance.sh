#!/bin/bash

cd $GOPATH

Gateway=( rest-conditional-gateway KafkaTrigger-To-KafkaPublisher )   

for ((p=0;p < ${#Gateway[@]};p++))
        do
            mashling create -f $GOPATH/src/github.com/LakshmiMekala/testrep/${Gateway[$p]}/${Gateway[$p]}.json ${Gateway[$p]} 
        done


FILENAME="PerformanceReport.html"
HTML="<!DOCTYPE html>
<html><head><style>table {font-family: arial, sans-serif;border-collapse: collapse;margin: auto;}td {border: 1px solid #dddddd;text-align: center;padding: 8px;}th {border: 1px solid #dddddd;text-align: left;padding: 8px;}th {background: #003399;text-align: center;color: #fff;}body {padding-right: 15px;padding-left: 15px;margin-right: auto;margin-left: auto;}label {font-weight: bold;}.test-report h1 {color: #003399;}.summary,.test-report {text-align: center;}.success {background-color: #79d279;}.error {background-color: #ff3300;}.summary-tbl {font-weight: bold;}.summary-tbl td {border: none;}</style></head><body>    
<section class=test-report><h1>Gateway Performance Report</h1></section>
<section class=test-report><table><tr><th>Trigger Type</th><th>Transactions/Sec</th><th>No of Tests</th><th>Errors</th><th>Test Time(Sec)</th></tr> </table></section><br /><br />
<section class=test-report><table><tr><th>Trigger Type</th><th>Transaction Response Summary</th><th>No of Tests</th><th>Errors</th><th>Test Time(Sec)</th></tr></table></section></html>"
echo $HTML >> $GOPATH/$FILENAME

#Kafka Performance
cd $GOPATH/src/github.com/LakshmiMekala/testrep/
source ./kafkaPerf.sh
value=($(get_test_cases))
for ((i=0;i < ${#value[@]};i++))
        do
            #source ./kafkaPerf.sh
            ${value[i]}
           # cd /home/ramesh/Documents/Performance\ Automation/
            sed -i "s/<tr><th>Trigger Type<\/th><th>Transaction Response Summary<\/th><th>No of Tests<\/th><th>Errors<\/th><th>Test Time(Sec)<\/th>/<tr><th>Trigger Type<\/th><th>Transaction Response Summary<\/th><th>No of Tests<\/th><th>Errors<\/th><th>Test Time(Sec)<\/th><\/tr><tr><td>KAFKA<\/td><td>$responseTime<\/td><td>$transactions<\/td><td>$errors<\/td><td>$testTime<\/td><\/tr>/g" $GOPATH/$FILENAME
        done

#Rest Performance
cd $GOPATH/src/github.com/LakshmiMekala/testrep/rest-performance-testing
source ./Grinder.sh
value=($(get_test_cases))
for ((i=0;i < ${#value[@]};i++))
        do
            #source ./Grinder.sh
            ${value[i]}
            #cd /home/ramesh/Documents/Performance\ Automation/
            sed -i "s/<tr><th>Trigger Type<\/th><th>Transactions\/Sec<\/th><th>No of Tests<\/th><th>Errors<\/th><th>Test Time(Sec)<\/th>/<tr><th>Trigger Type<\/th><th>Transactions\/Sec<\/th><th>No of Tests<\/th><th>Errors<\/th><th>Test Time(Sec)<\/th><\/tr><tr><td>REST<\/td><td>$ELE2<\/td><td>${array[0]}<\/td><td>${array[1]}<\/td><td>$testTime<\/td><\/tr>/g" $GOPATH/$FILENAME
        done

REPONAME="${TRAVIS_REPO_SLUG}" ;
REPOFOLDER=${REPONAME:14} ;

mkdir ${HOME}/.aws
cat > ${HOME}/.aws/credentials <<EOL
[default]
aws_access_key_id = ${SITE_KEY}
aws_secret_access_key = ${SITE_KEY_SECRET}
EOL

function create_dest_directory ()
{
    cd perf-reports ;
    if [ -n "${TRAVIS_TAG}" ]; then
        DESTFOLDER="$REPOFOLDER-${TRAVIS_TAG}"
    elif [ -z "${TRAVIS_TAG}" ]; then
        DESTFOLDER="$REPOFOLDER-${TRAVIS_BUILD_NUMBER}"
    fi

    if [ ! -d "$DESTFOLDER" ]; then
        mkdir "$DESTFOLDER" "latest";
    fi
    echo "Creating folder - $DESTFOLDER /"
    cd "$DESTFOLDER";
}

pushd $GOPATH/src/github.com/TIBCOSoftware/mashling ;
mkdir perf-reports;
create_dest_directory ;
cp $GOPATH/KafkaTrigger-To-KafkaPublisher/bin/tmp/kafka-*.log "$GOPATH/src/github.com/TIBCOSoftware/mashling/perf-reports/$DESTFOLDER"
#cp $GOPATH/KafkaTrigger-To-KafkaPublisher/bin/tmp/kafka-testcase2.log "$GOPATH/src/github.com/TIBCOSoftware/mashling/perf-reports/$DESTFOLDER"
cp $GOPATH/rest-conditional-gateway/bin/tmp/rest-*.log "$GOPATH/src/github.com/TIBCOSoftware/mashling/perf-reports/$DESTFOLDER"
#cp $GOPATH/rest-conditional-gateway/bin/tmp/rest-testcase2.log
cp "$GOPATH/$FILENAME" "$GOPATH/src/github.com/TIBCOSoftware/mashling/perf-reports/$DESTFOLDER"
cp "$GOPATH/$FILENAME" "$GOPATH/src/github.com/TIBCOSoftware/mashling/perf-reports/latest"
aws s3 cp "$GOPATH/src/github.com/TIBCOSoftware/mashling/perf-reports" "s3://$AWS_BUCKET/LakshmiMekala/remoterecipes" --recursive
popd ;
