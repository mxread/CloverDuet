#!/bin/bash
imports=(
  [ebuild/Common]
  [ebuild/MainBuildScript]
  [ebuild/MainPostBuildScript]
)
for i in "${imports[@]}"; do
  l=$((${#i}-2))
  s="$(dirname $0)/${i:1:$l}.sh"
  [[ -f "${s}" ]] && source "${s}"
done
################################################################################

MainBuildScript $@
MainPostBuildScript

################################################################################
