RDEPENDS_${PN}_remove = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", "selinux-labeldev", "", d)}"
