do_cleanup_sepolicy() {

        policy_version=31
        policy_type=mls
        policy_dir=${IMAGE_ROOTFS}/etc/selinux/${policy_type}/policy
        recovery_policy=${policy_dir}/recovery.policy.${policy_version}
        mv -f ${recovery_policy} ${policy_dir}/policy.${policy_version}
}

ROOTFS_POSTPROCESS_COMMAND += "${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'do_cleanup_sepolicy;', '', d)}"
