RDEPENDS_${PN}_remove_mdm = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", "selinux-labeldev", "", d)}"
RDEPENDS_${PN}_remove_sa2150p = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", "selinux-labeldev", "", d)}"

