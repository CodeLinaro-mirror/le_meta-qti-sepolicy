require refpolicy-qti-common.inc

SRC_URI += " \
    file://vm/ \
"

PURGE_POLICY_MODULES:append = " adbd adkcfg adk_message_monitor adk_message_send adsprpcd agm_server alexa alljoyn allplay alm alogd atfwd audio_hal audio_hal_test audio_manager bootlogd btdaemon button_manager cache cdsprpcd chg-policy connectivity_manager csd_server dataadpl data_path_opt dataqti_ppp ddclient devconfig diag diagrebootapp diag-router dlsc dnsmasq emac ethagent firmware fs_scrub_daemon gpu hostapd iotd iotsys ipacm irsc_util led_manager leprop location mbim mcm_ril_service mediaplayer_cli mediaplayer_test minidlna msdc mss mtd_tools networkmanager nfdlna ota pdmappersvc perf_hal port_bridge ppp pulseaudio qbt qcameradaemon qcmap_cm qcrilNrd qdma qdmastatsd qesdk_manager qesdk_one qmmf-server qmi_ip_multiclient qmi-shutdown-modem qmuxbridge qnetmgrd qrtr_ns qsap_dcfd qsap_sanity qseecomd qtether qti-audio-server-daemon qwesd rebootd recovery rmt_storage rules_manager sfs_config splitxr_service spotify sprhd ss-ramdump ssreq-server sthal st_hal_test thermal-engine time_daemon voice-ui-app weston wlan"

EXTRA_OEMAKE:append = " ${@bb.utils.contains('MACHINE_FEATURES', 'qti-avf', 'CUSTOM_BUILDOPT=cddrestrict', '', d)}"

do_patch:append() {
    install_device_policy(d, "vm")
    if os.path.exists(os.path.join(d.getVar("WORKDIR"), d.getVar("BASEMACHINE"))):
         install_device_policy(d, d.getVar("BASEMACHINE"))
}
