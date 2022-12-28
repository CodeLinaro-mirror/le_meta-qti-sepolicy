FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

# todo: cleanup commented line
#SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'file://Do-not-install-ypasswd-headers.patch', '', d)}"
