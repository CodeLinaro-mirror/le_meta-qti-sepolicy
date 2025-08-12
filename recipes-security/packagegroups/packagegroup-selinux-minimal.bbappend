RDEPENDS:${PN}:remove = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", "selinux-init selinux-labeldev", "", d)}"

# Replace coreutils
RDEPENDS:${PN}:remove = "coreutils"
RDEPENDS:${PN}:append = "${PREFERRED_PROVIDER_virtual/base-utils}"
RDEPENDS:${PN}:remove = "refpolicy"
