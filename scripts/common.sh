#!/bin/bash

# common.sh
# This script contains shared variables and functions used across multiple scripts.
# It provides utilities for managing and interacting with the services.

# Set environment variables that are common across scripts.
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export COMPOSE_PROJECT_NAME=payload-turbo-bun-template
export APPS_DIR="apps"  # Ensure this is correctly defined

# Bun image tag for Docker builds — single source: repo-root `.tool-versions`.
_SCRIPT_DIR_FOR_BUN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_ROOT_FOR_BUN="$(cd "${_SCRIPT_DIR_FOR_BUN}/.." && pwd)"
if [[ -z "${BUN_VERSION:-}" && -f "${_ROOT_FOR_BUN}/.tool-versions" ]]; then
  BUN_VERSION="$(awk '/^bun / { print $2; exit }' "${_ROOT_FOR_BUN}/.tool-versions")"
  export BUN_VERSION
fi
unset _SCRIPT_DIR_FOR_BUN _ROOT_FOR_BUN

# Get the full path of the directory containing this script
get_script_dir() {
    echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
}

# Get the parent directory of the given directory
get_parent_dir() {
    local dir="$1"
    echo "$(dirname "$dir")"
}

# Get the name of the given directory
get_dir_name() {
    local dir="$1"
    echo "$(basename "$dir")"
}

# Function to check for the existence of a specific file within a service's directory.
# Arguments:
#   $1: service name
#   $2: filename to check for
# Returns:
#   0 if file exists, 1 otherwise.
check_file_in_service_dir() {
    local service="$1"
    local file="$2"
    local service_dir="${APPS_DIR}/${service}"

    [[ -e "${service_dir}/${file}" ]] && return 0 || return 1
}

# Function to list services directory names.
SERVICES=("${APPS_DIR}"/*/)
SERVICES=("${SERVICES[@]%/}")
SERVICES=("${SERVICES[@]##*/}")

# Function to loop over all services and execute a given callback.
# Arguments:
#   $1: Name of the callback function to execute for each service.
#   $2: Service to loop (if specified), otherwise all services.
loop_services() {
    local callback="$1"
    local specific_service="$2"

    if [ -n "$specific_service" ]; then
        "$callback" "$specific_service"
    else
        for service in "${SERVICES[@]}"; do
            "$callback" "$service"
        done
    fi
}