require refpolicy-qti-common.inc

SRC_URI += " \
    file://disable-mls-constraints.patch \
    file://allow-systemd-tmpfiles-manage-all.patch \
    file://Add-hostapd-service-module.patch \
"
