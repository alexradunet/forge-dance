#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

tools=(
  firebase_get_project
  firebase_get_environment
  firebase_list_apps
  firebase_get_sdk_config
  firebase_validate_security_rules
  firebase_get_security_rules
  firebase_read_resources
  auth_get_users
  auth_update_user
  firestore_get_document
  firestore_list_documents
  firestore_list_collections
  firestore_query_collection
  firestore_run_aggregation_query
  firestore_add_document
  firestore_update_document
  firestore_delete_document
  firestore_create_index
  firestore_get_index
  firestore_list_indexes
  firestore_delete_index
)
tool_list="$(IFS=,; printf '%s' "${tools[*]}")"

exec npx -y firebase-tools@15.28.2 mcp \
  --dir "$PWD" \
  --tools "$tool_list"
