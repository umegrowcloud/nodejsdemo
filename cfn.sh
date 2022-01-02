#!/bin/sh

aws --debug cloudformation create-stack --stack-name "$serviceName-stack" \
    --template-body file://ecs.yaml \
    --region 'us-east-1' \
    --parameters ParameterKey=Stage,ParameterValue=dev \
        ParameterKey=ContainerPort,ParameterValue=8080 \
        ParameterKey=ImageURI,ParameterValue=8080 \
        ParameterKey=ServiceName,ParameterValue=$serviceName 
    --capabilities CAPABILITY_NAMED_IAM
