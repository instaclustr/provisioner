#!/bin/bash

provisionCluster(){
	cd $CERTDIRECTORY/instaclustrAPI
	provisionRequest=$CUROUTPUT/provisionRequest.json
	mkdir -p "$(dirname "$provisionRequest")" && touch "$provisionRequest"
	gsed -e s/@@NAME@@/$NAME/g $CERTDIRECTORY/instaclustrAPI/provisionRequest.json > $provisionRequest
	gsed -i s/@@SIZE@@/$SIZE/g $provisionRequest
	gsed -i s/@@NODES@@/$NODES/g $provisionRequest
	gsed -i s/@@NODESPERRACK@@/$((NODES/3))/g $provisionRequest
	gsed -i s/@@EXTERNALIP@@/`dig +short myip.opendns.com @resolver1.opendns.com`/g $provisionRequest
	gsed -i s/@@VERSION@@/$VERSION/g $provisionRequest
	gsed -i s/@@DATACENTRE@@/$DATACENTRE/g $provisionRequest
	gsed -i s/@@BUNDLE@@/$BUNDLE/g $provisionRequest
	gsed -i s/@@RULE_TYPE@@/$RULE_TYPE/g $provisionRequest
	responseFile=$CUROUTPUT/provresponse.json
	echo `curl -s -u ${USERNAME}:${PASSWORD} -X POST \
		${URL}/extended \
		-H 'Cache-Control: no-cache' \
		-H 'Content-Type: application/json' \
		-d @$provisionRequest` > $responseFile
	id=`python -c "from provisionCluster import clusterProvisioned; clusterProvisioned(\"${responseFile}\")"`
	if [[ $? -ne 0 ]]; then
		echo "The cluster has failed to provision."
		exit 1
	fi
	echo $id
}

waitForClusterProvision(){
	LIMIT=$(($NODES*3))
	cd $CERTDIRECTORY/instaclustrAPI	
	RETRY=0
	CLUSTERSTATUS=""
	while [[ $CLUSTERSTATUS != 'RUNNING' ]];
	do
		if [[ $LIMIT == $RETRY ]]; then
			echo "The cluster has failed to provision inside time limit."
			echo "Check console for details: https://console.instaclustr.com/dashboard/"
			exit 1
		fi
		CLUSTERSTATUS=$(clusterStatus)
		echo "Cluster status:"$CLUSTERSTATUS
		if [[ $CLUSTERSTATUS != 'RUNNING' ]];
		then
			echo "waiting for cluster to be ready"
			sleep 70s
		fi
		RETRY=$(($RETRY+1))
	done
}

clusterStatus(){
	nodesFile=$CUROUTPUT/node_list.txt
	cd $CERTDIRECTORY/instaclustrAPI	
	responseFile=$CUROUTPUT/clusterStatus.json
	echo `curl -s -u ${USERNAME}:${PASSWORD} -X GET \
		${URL}/${CLUSTERID} \
		-H 'Cache-Control: no-cache'` > $responseFile
	CLUSTERSTATUS=`python -c "from provisionCluster import clusterStatus; clusterStatus(\"${responseFile}\")"`
	if [[ $? -ne 0 ]]; then
		exit 1
	fi

	if [[ $CLUSTERSTATUS == 'RUNNING' ]]; then
		nodes=`python -c "from provisionCluster import getNodeIp; getNodeIp(\"${responseFile}\")"`
		echo "" > $nodesFile
		for node in $nodes
		do
			echo $node >> $nodesFile
		done
	fi
	echo ${CLUSTERSTATUS}
}

