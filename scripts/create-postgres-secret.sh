#!/usr/bin/env bash

set -Eeuo pipefail

NAMESPACE="${NAMESPACE:-kanboard}"
SECRET_NAME="${SECRET_NAME:-postgres-secret}"

DB_NAME="${DB_NAME:-kanboard}"
DB_USER="${DB_USER:-kanboard}"
DB_HOST="${DB_HOST:-kanboard-postgres}"
DB_PORT="${DB_PORT:-5432}"

for command_name in kubectl openssl; do
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    echo "Required command not found: ${command_name}" >&2
    exit 1
  fi
done

if ! kubectl get namespace "${NAMESPACE}" >/dev/null 2>&1; then
  echo "Namespace '${NAMESPACE}' does not exist." >&2
  echo "Create or synchronize the Kanboard Argo CD Application first." >&2
  exit 1
fi

# Use a supplied password when POSTGRES_PASSWORD is set.
# Otherwise generate a URL-safe 64-character hexadecimal password.
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-$(openssl rand -hex 32)}"

DATABASE_URL="postgres://${DB_USER}:${POSTGRES_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"

# Create temporary files with owner-only permissions.
umask 077
TEMP_DIRECTORY="$(mktemp -d)"

cleanup() {
  rm -rf "${TEMP_DIRECTORY}"
}

trap cleanup EXIT

printf '%s' "${POSTGRES_PASSWORD}" \
  > "${TEMP_DIRECTORY}/postgres-password"

printf '%s' "${DATABASE_URL}" \
  > "${TEMP_DIRECTORY}/database-url"

kubectl create secret generic "${SECRET_NAME}" \
  --namespace "${NAMESPACE}" \
  --from-file="postgres-password=${TEMP_DIRECTORY}/postgres-password" \
  --from-file="database-url=${TEMP_DIRECTORY}/database-url" \
  --dry-run=client \
  --output yaml \
  | kubectl apply --filename -

kubectl get secret "${SECRET_NAME}" \
  --namespace "${NAMESPACE}" \
  --output custom-columns='NAME:.metadata.name,TYPE:.type,KEYS:.data'

echo
echo "PostgreSQL Secret created or updated successfully."
echo "Namespace: ${NAMESPACE}"
echo "Secret: ${SECRET_NAME}"
echo "The password was not printed."
