require refpolicy-qti-common.inc

SRC_URI += " \
    file://generic/ \
"

do_patch:append() {
    install_device_policy(d, "generic")
}
