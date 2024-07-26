#!/bin/bash

# This script creates a diff of current HEAD and the last commit we processed last time

### Validate parameters
if [ -z "$GIT_REPO" ]; then
  echo "GIT_REPO is not set. Exiting."
  exit 11
fi

if [ -z "$PARAMETER_NAME" ]; then
  echo "PARAMETER_NAME is not set. Exiting."
  exit 22
fi

if [ -z "$RESULTS_BUCKET" ]; then
  echo "RESULTS_BUCKET is not set. Exiting."
  exit 33
fi

# Strip last slash if it's there
RESULTS_BUCKET=${RESULTS_BUCKET%/}
echo "RESULTS_BUCKET: $RESULTS_BUCKET"

### Get the last commit or empty commit if this is the first run
LAST_COMMIT=$(aws ssm get-parameter --name $PARAMETER_NAME --query Parameter.Value --output text || true)
if [ -z "$LAST_COMMIT" ]; then
  # Empty tree hash, see https://stackoverflow.com/a/73793394
  LAST_COMMIT=$(git hash-object -t tree /dev/null)
fi

echo "Last commit: $LAST_COMMIT"

### Clone and create diff
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
git clone $GIT_REPO /tmp/repo
cd /tmp/repo
git diff $LAST_COMMIT..HEAD > /tmp/changes.diff

### Store data in SSM and S3
# Example S3 key: 2024-06-06-2137_8fbbe55-6b11430.diff
PREV_COMMIT=${LAST_COMMIT:0:7}
CURRENT_COMMIT=$(git rev-parse --short HEAD)
NOW_DATE=$(date -u +"%Y-%m-%d-%H%M")
S3_KEY="${NOW_DATE}_${PREV_COMMIT}-${CURRENT_COMMIT}.diff"

aws s3 cp /tmp/changes.diff s3://$RESULTS_BUCKET/$S3_KEY
aws ssm put-parameter --name $PARAMETER_NAME --value $(git rev-parse HEAD) --type String --overwrite