FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += " \
    file://systemd/label-cache.service \
    file://systemd/label-persist.service \
    file://systemd/label-systemrw.service \
    file://systemd/label-data.service \
"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','selinux','true','false',d)}; then
        if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
            install -d ${D}${systemd_system_unitdir}
            if ${@bb.utils.contains('DISTRO_FEATURES','nand-boot','false','true',d)}; then
                install -m 0644 ${WORKDIR}/systemd/label-cache.service ${D}${systemd_system_unitdir}/label-cache.service
                install -m 0644 ${WORKDIR}/systemd/label-systemrw.service ${D}${systemd_system_unitdir}/label-systemrw.service
            fi
            if ${@bb.utils.contains('DISTRO_FEATURES','persist-volume','true','false',d)}; then
                install -m 0644 ${WORKDIR}/systemd/label-persist.service ${D}${systemd_system_unitdir}/label-persist.service
            fi
            install -m 0644 ${WORKDIR}/systemd/label-data.service ${D}${systemd_system_unitdir}/label-data.service
        fi
    fi
}
