FILESEXTRAPATHS:prepend := "${THISDIR}/systemd:"

SRC_URI:append += " \
    file://label-cache.service \
    file://label-persist.service \
    file://label-systemrw.service \
    file://label-data.service \
"

append_selinux_mount_option() {
    mount_file="$1"
    context="$2"

    # Check to see if the mount file already defines an SELinux context
    if ! grep -q -e "context=" $mount_file; then
        # Append context to the Options= line of the mount file
        sed -i "/^Options=/ s/$/,${context}/" $mount_file
    fi
}

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','selinux','true','false',d)}; then
        install -d ${D}${systemd_system_unitdir}/local-fs.target.wants
        install -d ${D}${systemd_system_unitdir}/multi-user.target.wants

        mount_file="${D}${systemd_system_unitdir}/data.mount"
        label_file=label-data.service
        if [ -e $mount_file ]; then
            append_selinux_mount_option $mount_file rootcontext=system_u:object_r:data_t:s0
            install -m 0644 ${UNPACKDIR}/${label_file} ${D}${systemd_system_unitdir}/${label_file}
            ln -sf  ../${label_file}  ${D}${systemd_system_unitdir}/local-fs.target.wants/${label_file}
        fi

        mount_file="${D}${systemd_system_unitdir}/systemrw.mount"
        if [ -e $mount_file ]; then
            append_selinux_mount_option $mount_file rootcontext=system_u:object_r:system_data_t:s0
            # Not labeling /systemrw, mount-copybind preserves context assigned in read-only partitions
        fi

        mount_file="${D}${systemd_system_unitdir}/cache.mount"
        label_file=label-cache.service
        if [ -e $mount_file ]; then
            append_selinux_mount_option $mount_file rootcontext=system_u:object_r:cache_t:s0
            install -m 0644 ${UNPACKDIR}/${label_file} ${D}${systemd_system_unitdir}/${label_file}
            ln -sf  ../${label_file}  ${D}${systemd_system_unitdir}/multi-user.target.wants/${label_file}
        fi

        mount_file="${D}${systemd_system_unitdir}/persist.mount"
        label_file=label-persist.service
        if [ -e $mount_file ]; then
            append_selinux_mount_option $mount_file rootcontext=system_u:object_r:persist_t:s0
            install -m 0644 ${UNPACKDIR}/${label_file} ${D}${systemd_system_unitdir}/${label_file}
            ln -sf  ../${label_file}  ${D}${systemd_system_unitdir}/multi-user.target.wants/${label_file}
        fi

        mount_file="${D}${systemd_system_unitdir}/firmware.mount"
        if [ -e $mount_file ]; then
            append_selinux_mount_option $mount_file context=system_u:object_r:firmware_t:s0
            # Not all firmware filesystems support xattrs. Don't use restorecon or rootcontext here
        fi

        mount_file="${D}${systemd_system_unitdir}/bt_firmware.mount"
        if [ -e $mount_file ]; then
            append_selinux_mount_option $mount_file context=system_u:object_r:firmware_t:s0
            # Not all firmware filesystems support xattrs. Don't use restorecon or rootcontext here
        fi

        mount_file="${D}${systemd_system_unitdir}/dsp.mount"
        if [ -e $mount_file ]; then
            append_selinux_mount_option $mount_file context=system_u:object_r:adsprpcd_t:s0
            # Not all firmware filesystems support xattrs. Don't use restorecon or rootcontext here
        fi

    fi
}
