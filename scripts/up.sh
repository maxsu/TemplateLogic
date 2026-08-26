#!/bin/bash

# Navigate to project root
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Start docker
echo "Starting payload-multi-tenant-template"
docker compose up --detach