do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','selinux','true','false',d)}; then
        # Remove recursive restorecon calls from populate_volatile.sh
        sed -i '/^test ! -x \/sbin\/restorecon/ d' ${D}${sysconfdir}/init.d/populate-volatile.sh
        # read_only_rootfs_hook does not mount fstab and therefore will not
        #  have the correct context when writing to /var/log/lastlog. Attempt
        #  to label this, but do not abort on failure.
        echo "/sbin/restorecon -F /var/log || true" >> ${D}${sysconfdir}/init.d/populate-volatile.sh
    fi
}
