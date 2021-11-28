#!/bin/bash
if [[ "${imports[@]}" == *"[ebuild/Common]"* ]]; then
################################################################################

# Default values
export LC_ALL="POSIX"
export PATH="/usr/bin:${PATH}"

# Global variables
declare -r CLOVERROOT="$(dirname $0)/wspace"

# Bash options
set -e # errexit
set -u # Blow on unbound variable


################################################################################
fi