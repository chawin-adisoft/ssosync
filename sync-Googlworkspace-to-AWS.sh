#!/bin/bash

# Load .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "🚨 .env file not found! Make sure it's in the same directory as this script."
  exit 1
fi

# Use the environment variables in your command
echo "Running with the following configuration:"
echo "GOOGLE_ADMIN: $GOOGLE_ADMIN"
echo "REGION: $REGION"
echo "ENDPOINT: $ENDPOINT"


# Get the script's directory
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Define a local path relative to the script
COMMAND_PATH="$SCRIPT_DIR/ssosync"

echo "The local path is: $COMMAND_PATH"

# Execute the main command
$COMMAND_PATH \
  --google-admin "$GOOGLE_ADMIN" \
  --google-credentials "$GOOGLE_CREDENTIALS" \
  --region "$REGION" \
  --access-token "$ACCESS_TOKEN" \
  --endpoint "$ENDPOINT" \
  --identity-store-id "$IDENTITY_STORE_ID" \
  --sync-method "$SYNC_METHOD"
