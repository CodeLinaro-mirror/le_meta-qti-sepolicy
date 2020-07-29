RDEPENDS_${PN}_remove = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", "selinux-init selinux-labeldev", "", d)}"

# Replace coreutils with busybox utilities
RDEPENDS_${PN}_remove = "coreutils"
RDEPENDS_${PN}_append = "busybox"
