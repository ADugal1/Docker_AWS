#!/bin/bash

set -e

NAME_TAG="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/\
${REPO_NAME}:${CODEBUILD_RESOLVED_SOURCE_VERSION}"
docker build -t "${NAME_TAG}" -f docker/Dockerfile .
docker push "${NAME_TAG}"
cd aws
npm i
aws cloudformation package --template-file template.yml \
  --s3-bucket "${BUCKET_NAME}" --output-template-file .template.yml
aws cloudformation deploy --template-file .template.yml \
  --stack-name nodejs-express --capabilities CAPABILITY_IAM \
  --parameter-overrides "AppImage=${NAME_TAG}"
