require refpolicy-qti-common.inc

# Enable URM (Userspace Resource Manager) module for seraph
CONTRIB_MODULES:append = " urm"

SRC_URI += " \
    file://xr/ \
    file://${BASEMACHINE}/ \
"
do_patch:append() {
    install_device_policy(d, "xr")
    if os.path.exists(os.path.join(d.getVar("WORKDIR"), d.getVar("BASEMACHINE"))):
         install_device_policy(d, d.getVar("BASEMACHINE"))
}
