FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://selinux-labeldev.conf"

do_install_append_mdm() {
    install -d ${D}/etc/tmpfiles.d/
    install -m 0644 ${WORKDIR}/selinux-labeldev.conf -D ${D}/etc/tmpfiles.d/selinux-labeldev.conf
}
