inherit enable-selinux

PACKAGECONFIG[selinux] = "--enable-selinux,--disable-selinux,libselinux"

do_configure:append() {
    # Enable selinux by turning off TOYBOX_LSM_NONE and replacing with TOYBOX_SELINUX
    #  This enables functionality such as ls -Z and ps -Z.
    sed -e 's/CONFIG_TOYBOX_LSM_NONE=y/# CONFIG_TOYBOX_LSM_NONE is not set/' -i .config
    sed -e 's/# CONFIG_TOYBOX_SELINUX is not set/CONFIG_TOYBOX_SELINUX=y/' -i .config
}

