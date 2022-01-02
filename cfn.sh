#!/bin/sh

if ! aws cloudformation describe-stacks --stack-name $serviceName-stack ; then
    echo "1"
    type_formation='create-stack'
else
    type_formation='update-stack'
fi

aws --debug cloudformation  $type_formation --stack-name "$serviceName-stack" \
    --template-body file://ecs.yaml \
    --region 'us-east-1' \
    --parameters ParameterKey=Stage,ParameterValue=dev \
        ParameterKey=ContainerPort,ParameterValue=8080 \
        ParameterKey=ImageURI,ParameterValue=$ImageURI \
        ParameterKey=ServiceName,ParameterValue=$serviceName \
    --capabilities CAPABILITY_NAMED_IAM
