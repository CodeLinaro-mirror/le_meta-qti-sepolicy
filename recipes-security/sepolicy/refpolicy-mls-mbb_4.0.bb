require refpolicy-qti-common.inc

SRC_URI += "file://../../mbb/${BASEMACHINE}/ \
"
do_patch_append() {
    if os.path.exists(os.path.join(d.getVar("WORKDIR"), "../../mbb/",d.getVar("BASEMACHINE"))):
         install_device_policy(d, "../../mbb/"+d.getVar("BASEMACHINE"))
}
