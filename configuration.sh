#!/bin/bash
NAME=projectX
declare -a SIZES=("t2.small-20/3")
VERSION=apache-kafka:1.1.0.ic1
BUNDLE=KAFKA
RULE_TYPE=KAFKA
#declare -a SIZES=("t2.small/3")
#VERSION=apache-cassandra-3.11.2.2
#BUNDLE=APACHE_CASSANDRA
#RULE_TYPE=CASSANDRA
URL='https://api.instaclustr.com/provisioning/v1'
TESTMODE=true
DELETE_CLUSTERS=true
USE_RESIZE=true
DATACENTRE=US_WEST_2
