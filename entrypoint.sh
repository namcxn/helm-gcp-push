#!/bin/bash
set -e
set -x

if [[ -z "$CHART_FOLDER" ]]; then
  echo "Chart folder is required but not defined."
  exit 1
fi

if [[ -z "$REGISTRY_URL" ]]; then
  echo "Repository url is required but not defined."
  exit 1
fi

if [[ -z "$REGISTRY_USER" ]]; then
  echo "CHARTMUSEUM_USER is not set. Quitting."
  exit 1
fi

if [[ -z "$GCP_LOCATION" ]]; then
  echo "LOCATION is not set. Quitting."
  exit 1
fi

if [[ -z "$SOURCE_DIR" ]]; then
  SOURCE_DIR="."
fi

cd ${SOURCE_DIR}/${CHART_FOLDER}

helm version -c

helm lint .

helm inspect chart *.tgz

helm dependency update .

helm package .

if [[ "$GCP_ACCESS_TOKEN" == "TRUE" ]]; then
  echo "$REGISTRY_TOKEN" | helm registry login -u "$REGISTRY_USER" \
      --password-stdin https://"$GCP_LOCATION"-docker.pkg.dev
  _local_push
fi

if [[ "$GCP_WIP_DOCKER" == "TRUE" ]]; then
  # Need setup GCP WIP and login at github action
  # gcloud auth configure-docker [location]-docker.pkg.dev -q
  _local_push
fi

_local_push (
  helm push ${CHART_FOLDER}-* ${REGISTRY_URL}
)
_
