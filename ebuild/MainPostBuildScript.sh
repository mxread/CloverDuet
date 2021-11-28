#!/bin/bash
if [[ "${imports[@]}" == *"[ebuild/MainPostBuildScript]"* ]]; then
################################################################################

MainPostBuildScript() {
  local BASETOOLS_DIR="${CLOVERROOT}/BaseTools/Source/C/bin"
  local BOOTSECTOR_BIN_DIR="${CLOVERROOT}/CloverEFI/BootSector/bin"
  local BOOTSECTOR_HFS_SRC_DIR="${CLOVERROOT}/CloverEFI/BootSectorHFS"
  local BUILD_DIR="${CLOVERROOT}/Build/Clover/RELEASE_GCC"
  local BUILD_DIR_ARCH="${CLOVERROOT}/Build/Clover/RELEASE_GCC53/X64"

  "${BASETOOLS_DIR}/LzmaCompress" -e         \
    -o "${BUILD_DIR}/FV/DUETEFIMAINFVX64.z"  \
    "${BUILD_DIR}/FV/DUETEFIMAINFVX64.Fv"

  "${BASETOOLS_DIR}/LzmaCompress" -e   \
    -o "${BUILD_DIR}/FV/DxeMainX64.z"  \
    "${BUILD_DIR_ARCH}/DxeCore.efi"

  "${BASETOOLS_DIR}/LzmaCompress" -e  \
    -o "${BUILD_DIR}/FV/DxeIplX64.z"  \
    "${BUILD_DIR_ARCH}/DxeIpl.efi"

  "${BASETOOLS_DIR}/GenFw" --rebase 0x10000  \
    -o "${BUILD_DIR_ARCH}/EfiLoader.efi"     \
    "${BUILD_DIR_ARCH}/EfiLoader.efi"

  "${BASETOOLS_DIR}/EfiLdrImage"          \
    -o "${BUILD_DIR}/FV/Efildr64"         \
    "${BUILD_DIR_ARCH}/EfiLoader.efi"     \
    "${BUILD_DIR}/FV/DxeIplX64.z"         \
    "${BUILD_DIR}/FV/DxeMainX64.z"        \
    "${BUILD_DIR}/FV/DUETEFIMAINFVX64.z"

  cat                                      \
    "${BOOTSECTOR_BIN_DIR}/Start64H5.com"  \
    "${BOOTSECTOR_BIN_DIR}/efi64.com3"     \
    "${BUILD_DIR}/FV/Efildr64"             \
    > "${BUILD_DIR}/FV/Efildr20Pure"

  "${BASETOOLS_DIR}/GenPage"        \
    "${BUILD_DIR}/FV/Efildr20Pure"  \
    -o "${BUILD_DIR}/FV/Efildr20"

  dd                               \
    if="${BUILD_DIR}/FV/Efildr20"  \
    of="${BUILD_DIR}/FV/boot6"     \
    bs=512                         \
    skip=1

  #mkdir -p "${BUILD_DIR_ARCH}/BootSectorsHFS"
  #DESTDIR="${BUILD_DIR_ARCH}/BootSectorsHFS"  \
  #  make -C "${BOOTSECTOR_HFS_SRC_DIR}"

}


################################################################################
fi
