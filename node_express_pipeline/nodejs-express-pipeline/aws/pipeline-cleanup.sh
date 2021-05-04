#!bin/bash

set -e

KMS_KEY_ARN="$(aws cloudformation describe-stacks --stack-name nodejs-express --query "Stacks[0].Outputs[?OutputKey=='KeyArn'].OutputValue" --output text)"

aws kms schedule-key-deletion --key-id "${KMS_KEY_ARN}"

echo "delete CloudFormation stack (takes up to 15 minutes)"
aws cloudformation delete-stack --stack-name nodejs-express
aws cloudformation wait stack-delete-complete --stack-name nodejs-express

BUCKET_ARTIFACTS_NAME="$(aws cloudformation describe-stacks --stack-name nodejs-express-pipeline --query "Stacks[0].Outputs[?OutputKey=='BucketArtifactsName'].OutputValue" --output text)"
REPOSITORY_NAME="$(aws cloudformation describe-stacks --stack-name nodejs-express-pipeline --query "Stacks[0].Outputs[?OutputKey=='RepositoryName'].OutputValue" --output text)"

aws s3 rm "s3://${BUCKET_ARTIFACTS_NAME}" --recursive

aws ecr delete-repository --repository-name "${REPOSITORY_NAME}" --force

aws codecommit delete-repository --repository-name nodejs-express

echo "delete CloudFormation stack (takes up to 5 minutes)"
aws cloudformation delete-stack --stack-name nodejs-express-pipeline
aws cloudformation wait stack-delete-complete --stack-name nodejs-express-pipeline
