IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES','selinux', 'packagegroup-selinux-minimal', '', d)}"
IMAGE_INSTALL_append_msm = " ${@bb.utils.contains('DISTRO_FEATURES','selinux', 'sepolicy', '', d)}"
IMAGE_INSTALL_append_msm = " ${@bb.utils.contains('DISTRO_FEATURES','selinux', 'selinux-init', '', d)}"
IMAGE_INSTALL_append_msm = " ${@bb.utils.contains('DISTRO_FEATURES','selinux', 'selinux-autorelabel', '', d)}"

IMAGE_INSTALL_remove_sa2150p = " ${@bb.utils.contains('DISTRO_FEATURES','selinux', 'selinux-init selinux-autorelabel', '', d)}"
SELINUX_FILE_CONTEXTS ?= "${IMAGE_ROOTFS}/etc/selinux/mls/contexts/files/file_contexts"
IMAGE_EXT4_SELINUX_OPTIONS = "${@bb.utils.contains('DISTRO_FEATURES','selinux',' -a / -S ${SELINUX_FILE_CONTEXTS} ','', d)}"
