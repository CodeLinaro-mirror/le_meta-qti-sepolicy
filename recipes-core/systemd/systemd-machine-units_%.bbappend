FILESEXTRAPATHS_prepend := "${THISDIR}/systemd:"

SRC_URI_append += " \
    file://label-cache.service \
    file://label-persist.service \
    file://label-systemrw.service \
    file://label-data.service \
"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','selinux','true','false',d)}; then
        if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
            install -d ${D}${systemd_system_unitdir}/local-fs.target.wants
            if ${@bb.utils.contains('DISTRO_FEATURES','nand-boot','false','true',d)}; then
                install -m 0644 ${WORKDIR}/label-cache.service ${D}${systemd_system_unitdir}/label-cache.service
                ln -sf  ../label-cache.service  ${D}${systemd_system_unitdir}/local-fs.target.wants/label-cache.service
                install -m 0644 ${WORKDIR}/label-systemrw.service ${D}${systemd_system_unitdir}/label-systemrw.service
                ln -sf  ../label-systemrw.service  ${D}${systemd_system_unitdir}/local-fs.target.wants/label-systemrw.service
            fi
            if ${@bb.utils.contains('DISTRO_FEATURES','persist-volume','true','false',d)}; then
                install -m 0644 ${WORKDIR}/label-persist.service ${D}${systemd_system_unitdir}/label-persist.service
                ln -sf  ../label-persist.service  ${D}${systemd_system_unitdir}/local-fs.target.wants/label-persist.service
            fi
            install -m 0644 ${WORKDIR}/label-data.service ${D}${systemd_system_unitdir}/label-data.service
            ln -sf  ../label-data.service  ${D}${systemd_system_unitdir}/local-fs.target.wants/label-data.service
        fi
    fi
}
