require refpolicy-qti-common.inc

SRC_URI += " \
    file://multimedia/ \
    file://${BASEMACHINE}/ \
"
do_patch_append() {
    install_device_policy(d, "multimedia")
    if os.path.exists(os.path.join(d.getVar("WORKDIR"), d.getVar("BASEMACHINE"))):
         install_device_policy(d, d.getVar("BASEMACHINE"))
}
