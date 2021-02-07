#!/usr/bin/env bash

NAME="$1"
CHART="$2"
REPO="$3"

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR="${PWD}/.tmp"
fi
mkdir -p "${TMP_DIR}"

if [[ -z "${BIN_DIR}" ]]; then
  BIN_DIR="${TMP_DIR}/bin"
fi
mkdir -p "${BIN_DIR}"

HELM=$(command -v helm)
if [[ -z "${HELM}" ]]; then
  HELM=$(command -v "${BIN_DIR}/helm")
fi

if [[ -z "${HELM}" ]]; then
  curl -sLo "helm.tar.gz" https://get.helm.sh/helm-v3.5.2-linux-amd64.tar.gz
  tar xzf helm.tar.gz
  mv linux-amd64/helm "${BIN_DIR}"
  rm -rf linux-amd64/ && rm -rf helm.tar.gz
  HELM="${BIN_DIR}/helm"
fi

helm template "${NAME}" "${CHART}" --repo "${REPO}" --set license=true
