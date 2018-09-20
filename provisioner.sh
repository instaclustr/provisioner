#!/bin/bash

while getopts "u:p:c:o:" opt; do
    case "$opt" in
	u)  USERNAME=$OPTARG
		;;
	p)  PASSWORD=$OPTARG
		;;
	c)  CONFIG=$OPTARG
		;;
	o)  OUTPUTFOLDER=$OPTARG
		;;
    esac
done

echo "CONFIG:"$CONFIG

# Load in the Configuration
. ${CONFIG}

CERTDIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CUROUTPUT=$OUTPUTFOLDER/$NAME/$VERSION

#Echo back the configuration
echo "CLUSTER NAME $NAME"
echo "BUNDLE $BUNDLE"
echo "VERSION $VERSION" 
echo "RULE_TYPE $RULE_TYPE"
echo "SIZES ${SIZES[@]}"
echo "USERNAME $USERNAME"
echo "CERTDIRECTORY $CERTDIRECTORY"
echo "CUROUTPUT $CUROUTPUT"
echo "OUTPUTFOLDER $OUTPUTFOLDER"
echo "CONFIG $CONFIG"


mkdir -p $CUROUTPUT

for size in ${SIZES[@]}
do
	SIZE=$(echo ${size} | cut -d "/" -f1)
	NODES=$(echo ${size} | cut -d "/" -f2)

	. $CERTDIRECTORY/instaclustrAPI/ProvisionCluster.sh

	CLUSTERID=`provisionCluster`
	if [[  $? -ne 0 ]]; then
		echo "Cluster failed to provision"
		exit 1
	else
		echo "Cluster started provisioning with ID :$CLUSTERID"
	fi
	
	waitForClusterProvision
	
done

