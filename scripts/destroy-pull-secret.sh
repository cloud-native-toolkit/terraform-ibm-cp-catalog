#!/usr/bin/env bash

NAMESPACE="${1}"
NAME="${2:-ibm-entitlement-key}"

echo "Checking for existing pull secret with entitlement key"
if oc get secret "${NAME}" --namespace="${NAMESPACE}" 1> /dev/null 2> /dev/null; then
  echo "** Existing pull secret found. Removing..."
  oc delete secret "${NAME}" --namespace="${NAMESPACE}"
fi
