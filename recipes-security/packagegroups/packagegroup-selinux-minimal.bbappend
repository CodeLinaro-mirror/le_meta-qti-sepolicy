RDEPENDS_${PN}_remove_mdm = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", "selinux-labeldev", "", d)}"
