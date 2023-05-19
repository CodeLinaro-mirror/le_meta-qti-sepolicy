FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://selinux-labeldev.conf \
    file://label-tmp.service \
"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','selinux','true','false',d)}; then
        install -d ${D}${systemd_system_unitdir}
        install -d ${D}${systemd_system_unitdir}/tmp.mount.wants
        install -m 0644 ${WORKDIR}/label-tmp.service ${D}${systemd_system_unitdir}
        ln -sf  ../label-tmp.service ${D}${systemd_system_unitdir}/tmp.mount.wants/label-tmp.service
    fi
}

do_install_append_mdm() {
    install -d ${D}/etc/tmpfiles.d/
    install -m 0644 ${WORKDIR}/selinux-labeldev.conf -D ${D}/etc/tmpfiles.d/selinux-labeldev.conf
}
