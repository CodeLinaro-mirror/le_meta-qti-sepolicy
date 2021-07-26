IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES','selinux', 'packagegroup-selinux-minimal', '', d)}"
IMAGE_INSTALL_append_msm = " ${@bb.utils.contains('DISTRO_FEATURES','selinux', 'sepolicy', '', d)}"
IMAGE_INSTALL_append_msm = " ${@bb.utils.contains('DISTRO_FEATURES','selinux', 'selinux-init', '', d)}"
IMAGE_INSTALL_append_msm = " ${@bb.utils.contains('DISTRO_FEATURES','selinux', 'selinux-autorelabel', '', d)}"

SELINUX_FILE_CONTEXTS ?= "${IMAGE_ROOTFS}/etc/selinux/mls/contexts/files/file_contexts"
IMAGE_EXT4_SELINUX_OPTIONS = "${@bb.utils.contains('DISTRO_FEATURES','selinux',' -a / -S ${SELINUX_FILE_CONTEXTS} ','', d)}"

do_cleanup_sepolicy() {
    policy_version=30
    policy_type=mls
    policy_dir=${IMAGE_ROOTFS}/etc/selinux/${policy_type}/policy
    recovery_policy=${policy_dir}/recovery.policy.${policy_version}
    if ${@oe.utils.conditional('RECOVERY_IMAGE', '1', 'true', 'false', d)}; then
        mv -f ${recovery_policy} ${policy_dir}/policy.${policy_version}
    else
        if [ -f ${recovery_policy} ]; then
            rm ${recovery_policy}
        fi
    fi
}

ROOTFS_POSTPROCESS_COMMAND += "${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'do_cleanup_sepolicy;', '', d)}"
