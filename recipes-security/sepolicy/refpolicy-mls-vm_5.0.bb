require refpolicy-qti-common.inc

SRC_URI += " \
    file://vm/ \
"

do_patch:append() {
    install_device_policy(d, "vm")
    if os.path.exists(os.path.join(d.getVar("WORKDIR"), d.getVar("BASEMACHINE"))):
         install_device_policy(d, d.getVar("BASEMACHINE"))
}
