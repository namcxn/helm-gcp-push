#!/bin/bash
set -e
set -x

_local_push (
  helm push ${CHART_FOLDER}-* ${REGISTRY_URL}
)

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

if [[ "$GCP_WIP" == "FALSE" ]]; then
  gcloud auth application-default print-access-token | helm registry login -u "$REGISTRY_USER" \
      --password-stdin https://"$GCP_LOCATION"-docker.pkg.dev
  _local_push
fi

if [[ "$GCP_WIP" == "TRUE" ]]; then
  gcloud auth configure-docker "$GCP_LOCATION"-docker.pkg.dev
  _local_push
fi

