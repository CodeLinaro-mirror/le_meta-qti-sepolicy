require refpolicy-qti-common.inc

SRC_URI += " \
    file://multimedia/ \
"
do_patch_append() {
    install_device_policy(d, "multimedia")
}
