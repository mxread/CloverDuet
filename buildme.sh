#!/bin/bash
imports=(
  [buildme/Common]
)
for i in "${imports[@]}"; do
  l=$((${#i}-2))
  s="$(dirname $0)/${i:1:$l}.sh"
  [[ -f "${s}" ]] && source "${s}"
done
################################################################################

function print_banner() {

  local lsha1="not a git repo" && [[ -d "${CLOVERROOT}/.git" ]] && lsha1=$(cd ${CLOVERROOT} && git rev-parse --short HEAD)
  local cvers="XXXX" && [[ -d "${CLOVERROOT}/.git" ]] && $(cd ${CLOVERROOT} && git describe --tags $(git rev-list --tags --max-count=1))
  local banner="

    ${COL_GREEN}$(printf '%.0s-'  {1..60})                                                       ${COL_RESET}
    ${COL_GREEN}$(printf '%.0s '  {1..2})🍀CloverDuet r${cvers}$COL_WHITE (SHA: $lsha1)          ${COL_RESET}
    ${COL_CYAN}$(printf '%.0s '   {1..4} )TOOLCHAIN: GCC53                                       ${COL_RESET}
    ${COL_GREEN}$(printf '%.0s-'  {1..60})                                                       ${COL_RESET}


  "

  printf "${banner}"                \
  | tail -n+2                       \
  | head -n-1                       \
  | sed -e 's/^[[:blank:]]\{4\}//g'

}

function menu() {

  local -r options=(
    'quit'
    'build CloverDuet'
  )

  print_banner
  PS3="$(printf "\n%s: " "Please enter your choice")"
  select opt in "${options[@]}"; do
    case $opt in
      "quit")
        exit 0
        ;;
      "build CloverDuet")
        "${CLOVERROOT}/ebuild.sh"
        break
        ;;
      *)
        echo "invalid option $REPLY"
        break
      ;;
    esac
  done
  menu

}

menu
