require refpolicy-qti-common.inc

CONTRIB_MODULES:append:kalama = " ssh"

SRC_URI += " \
    file://robotics/ \
    file://${BASEMACHINE}/ \
"

SRC_URI:append:kalama = " \
    file://0001-selinux-enable_ssh_sysadm_login.patch \
"

do_patch:append() {
    install_device_policy(d, "robotics")
    if os.path.exists(os.path.join(d.getVar("WORKDIR"), d.getVar("BASEMACHINE"))):
         install_device_policy(d, d.getVar("BASEMACHINE"))
}
