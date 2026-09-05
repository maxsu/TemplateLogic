#!/bin/bash

# Navigate to project root
cd "$(dirname "${BASH_SOURCE[0]}")/.."

[[ -z $BUN_VERSION ]] &&
    export BUN_VERSION=$(awk '/^bun / { print $2; exit }' .tool-versions)

echo "Starting payload-multi-tenant-template"
docker compose up --detach