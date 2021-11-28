#!/bin/bash
if [[ "${imports[@]}" == *"[ebuild/MainBuildScript]"* ]]; then
################################################################################

MainBuildScript() {
  local CMD=""

  # Set edk2 environment vars and copy edk2 conf templates
  cd "${CLOVERROOT}"
  rm -rf "${CLOVERROOT}/Conf" && mkdir "${CLOVERROOT}/Conf"
  source edksetup.sh BaseTools

  # Create edk2 tools if necessary
  if  [[ ! -x "${CLOVERROOT}/BaseTools/Source/C/bin/GenFv" ]]; then
    echo "Building tools as they are not found"
    make -C "${CLOVERROOT}/BaseTools" CC="gcc -Wno-deprecated-declarations"
  fi

  # Compose build command
  CMD="build"
  CMD="${CMD} -fr --cmd-len=50000 -D HAVE_LEGACY_EMURUNTIMEDXE -D NO_GRUB_DRIVERS_EMBEDDED -D LESS_DEBUG"
  CMD="${CMD} -p ${CLOVERROOT}/Clover.dsc -a X64 -b RELEASE"
  CMD="${CMD} -t GCC53 -n $(( $(nproc) + 1 ))"

  # Build Clover
  #echo "${CMD}"
  eval "${CMD}"

}


################################################################################
fi
