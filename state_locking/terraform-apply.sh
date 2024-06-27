#!/bin/bash

WORKSPACE=$(terraform workspace show)
LOCK_FILE="s3://my-terraform-state/release1/${WORKSPACE}/terraform.lock"

# Check if the lock file exists
if aws s3 ls "${LOCK_FILE}" >/dev/null 2>&1; then
  echo "Another terraform apply is in progress. Exiting."
  exit 1
fi

# Create a lock file
aws s3 cp /dev/null "${LOCK_FILE}"

# Run terraform apply
terraform apply "$@"

# Remove the lock file
aws s3 rm "${LOCK_FILE}"

