#!/usr/bin/env bash

CLUSTER_TYPE="$1"
NAMESPACE="$2"
NAME="$3"

if [[ ! "${CLUSTER_TYPE}" =~ ocp4 ]]; then
  echo "The cluster is not an OpenShift 4.x cluster. Skipping global pull secret"
  exit 0
fi

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR="${PWD}/tmp"
fi
mkdir -p "${TMP_DIR}"

GLOBAL_DIR="${TMP_DIR}/pull-secret/global"
ICR_DIR="${TMP_DIR}/pull-secret/new-secret"
RESULT_FILE="${TMP_DIR}/pull-secret/config.json"

mkdir -p "${GLOBAL_DIR}"
mkdir -p "${ICR_DIR}"

if ! oc get "secret/${NAME}" -n "${NAMESPACE}" 1> /dev/null 2> /dev/null; then
  echo "Target pull secret does not exist. Exiting"
  exit 0
fi

echo "Getting current global pull secret"
oc extract secret/pull-secret -n openshift-config --to="${GLOBAL_DIR}"
if [[ ! -f "${GLOBAL_DIR}/.dockerconfigjson" ]]; then
  echo "Error retrieving global pull secret"
  exit 0
fi

echo "Getting target pull secret"
oc extract "secret/${NAME}" -n "${NAMESPACE}" --to="${ICR_DIR}"
if [[ ! -f "${ICR_DIR}/.dockerconfigjson" ]]; then
  echo "Error retrieving target pull secret"
  exit 0
fi

echo "Merging pull secrets"
jq -s '.[0] * .[1]' "${GLOBAL_DIR}/.dockerconfigjson" "${ICR_DIR}/.dockerconfigjson" > "${RESULT_FILE}"


echo "Updating global pull secret"
oc set data secret/pull-secret -n openshift-config --from-file=".dockerconfigjson=${RESULT_FILE}"
