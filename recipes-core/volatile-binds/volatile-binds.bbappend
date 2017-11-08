do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','selinux','true','false',d)}; then
        echo '/sbin/restorecon -RF $''spec || true' >> ${D}${base_sbindir}/mount-copybind
    fi
}
