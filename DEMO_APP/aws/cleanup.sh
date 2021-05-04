#!/bin/bash

set -e

KMS_KEY_ARN="$(aws cloudformation describe-stacks --stack-name demo-app --query "Stacks[0].Outputs[?OutputKey=='KeyArn'].OutputValue" --output text)"

aws kms schedule-key-deletion --key-id "${KMS_KEY_ARN}"

echo "delete CloudFormation stack (takes up to 15 minutes)"
aws cloudformation delete-stack --stack-name demo-app
aws cloudformation wait stack-delete-complete --stack-name demo-app
