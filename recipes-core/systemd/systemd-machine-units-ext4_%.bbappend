FILESEXTRAPATHS:prepend := "${THISDIR}/systemd:"

SRC_URI += "file://label-persist.service"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','selinux','true','false',d)}; then
        install -d ${D}${systemd_system_unitdir}/multi-user.target.wants

        mount_file="${D}${systemd_system_unitdir}/persist-ext4.mount"
        label_file=label-persist.service
        if [ -e $mount_file ]; then
            install -m 0644 ${WORKDIR}/${label_file} ${D}${systemd_system_unitdir}/${label_file}
            ln -sf  ../${label_file}  ${D}${systemd_system_unitdir}/multi-user.target.wants/${label_file}
        fi
    fi
}
