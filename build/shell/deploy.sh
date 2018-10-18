#!/usr/bin/env bash

# This script is designed to be run from with-in the build agent container.

# Get cluster from metadata file.
#CLUSTER=`cat /opt/ecs/metadata/*/ecs-container-metadata.json | jq -r '.Cluster'`
CLUSTER="teamcity-stack"

# Get task arn from metadata file.
#TASK_ARN=`cat /opt/ecs/metadata/*/ecs-container-metadata.json | jq -r '.TaskARN'`
TASK_ARN="arn:aws:ecs:us-west-2:017170649993:task/bf7fd184-5150-4ab9-b03b-fb5d627a7f59"

# Get task definition arn from aws ecs cli.
TASK_DEFINITION_ARN=`aws ecs describe-tasks --cluster ${CLUSTER} --tasks ${TASK_ARN} --profile lasso-ops | jq -r '.tasks[0].taskDefinitionArn'`

# Get service ARNs from aws ecs cli.
SERVICES=`aws ecs list-services --cluster ${CLUSTER} --profile lasso-ops | jq -r '.serviceArns | @tsv'`

# Loop over services until we find the service with the same task definition then break out of loop.
for row in ${SERVICES}; do
    export SERVICE_NAME=`aws ecs describe-services --cluster ${CLUSTER} --service ${row} --profile lasso-ops | \
    jq -r --arg TASK_DEFINITION_ARN ${TASK_DEFINITION_ARN} 'select(.services[0].taskDefinition==$TASK_DEFINITION_ARN) | .services[0].serviceName'`
    if [ -z ${SERVICE_NAME} ]; then continue; else break; fi
done

# Update service with aws ecs cli, this pulls the latest version of the Docker image and deploys it.
aws ecs update-service --cluster ${CLUSTER} --service ${SERVICE_NAME} --force-new-deployment --profile lasso-ops

# Wait for service deployment result.
echo "--- waiting for service deployment to stabilize ---"
echo "--- https://docs.aws.amazon.com/cli/latest/reference/ecs/wait/index.html ---"
aws ecs wait services-stable --cluster ${CLUSTER} --services ${SERVICE_NAME} --profile lasso-ops