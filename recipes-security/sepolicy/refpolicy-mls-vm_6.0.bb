require refpolicy-qti-common.inc

SRC_URI += " \
    file://vm/ \
"

PURGE_POLICY_MODULES:append = " acct adbd adsprpcd aide alogd alsa amtu anaconda apache apt atfwd audio_hal audio_hal_test avahi backup bacula bluetooth bootloader bootlogd brctl cache cdsprpcd certwatch cfengine chg-policy chkrootkit clock csd_server dbadm ddclient devconfig dhcp diag diag-router diagrebootapp dmidecode dnsmasq dphysswapfile dpkg fakehwclock fapolicyd firmware fs_scrub_daemon gnome gpu guest hostapd hostname hwloc ipsec iptables irsc_util iscsi kismet l2tp leprop logwatch mcelog minidlna mrtg mss mta ncftool netlabel netutils networkmanager nscd ota passenger pdmappersvc perf_hal ppp prelink pulseaudio puppet qcameradaemon qcrilNrd qdma qdmastatsd qmi_ip_multiclient qseecomd quota qwesd radvd raid rebootd recovery rkhunter rmt_storage rpm samhain sblim servicemanager sfs_config shorewall sosreport ss-ramdump ssreq-server st_hal_test sthal sxid tboot thermal-engine time_daemon tmpreaper tripwire updfstab usbguard usbmodules vbetool vpn xdg xen xserver"

EXTRA_OEMAKE:append = " ${@bb.utils.contains('MACHINE_FEATURES', 'qti-avf', 'CUSTOM_BUILDOPT=cddrestrict', '', d)}"

do_patch:append() {
    install_device_policy(d, "vm")
    if os.path.exists(os.path.join(d.getVar("WORKDIR"), d.getVar("BASEMACHINE"))):
         install_device_policy(d, d.getVar("BASEMACHINE"))
}
