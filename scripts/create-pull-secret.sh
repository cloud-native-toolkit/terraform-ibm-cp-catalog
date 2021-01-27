#!/usr/bin/env bash

NAMESPACE="${1}"
NAME="${2:-ibm-entitlement-key}"
USERNAME="cp"
SERVER="cp.icr.io"

if [[ -z "${ENTITLEMENT_KEY}" ]]; then
  echo "ENTITLEMENT_KEY not set"
  exit 1
fi

echo "Checking for existing pull secret with entitlement key"
if oc get secret "${NAME}" --namespace="${NAMESPACE}" 1> /dev/null 2> /dev/null; then
  echo "** Existing pull secret found. Removing..."
  oc delete secret "${NAME}" --namespace="${NAMESPACE}"
fi

echo "Creating pull secret with entitlement key: ${NAMESPACE}/${NAME}"
oc create secret docker-registry "${NAME}" \
  --docker-username="${USERNAME}" \
  --docker-password="${ENTITLEMENT_KEY}" \
  --docker-server="${SERVER}" \
  --namespace="${NAMESPACE}"
