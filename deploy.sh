#! /usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
set -o errtrace

REGION="ap-southeast-2"
PROJECT="obsidian"
STAGE="prod"
REVISION="$(git rev-parse --short HEAD || die "unknown")"
if [[ "$(git diff --stat)" != "" ]]; then
	 REVISION="${REVISION}-dirty"
fi

cd "$(dirname "$0")"

aws cloudformation deploy \
  --stack-name "${PROJECT}-storage" \
  --template-file ./storage.yaml \
  --region "$REGION" \
  --capabilities CAPABILITY_IAM \
  --no-fail-on-empty-changeset \
  --parameter-overrides \
    "Stage=${STAGE}" \
    "Revision=${REVISION}" \
  --tags "Project=${PROJECT}"
