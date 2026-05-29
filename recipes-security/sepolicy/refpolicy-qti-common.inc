POLICY_TYPE = "mls"

SELINUX_LAYER_DIR = "${@d.getVar('COREBASE') + '/meta-selinux' if os.path.isdir(d.getVar('COREBASE') + '/meta-selinux') else d.getVar('COREBASE') + '/../meta-selinux'}"

FILESEXTRAPATHS:prepend := "${SELINUX_LAYER_DIR}/recipes-security/refpolicy:"

FILESEXTRAPATHS:prepend := "${SELINUX_LAYER_DIR}/recipes-security/refpolicy/files:"

FILESEXTRAPATHS:prepend := "${SELINUX_LAYER_DIR}/recipes-security/refpolicy/refpolicy:"

require ${SELINUX_LAYER_DIR}/recipes-security/refpolicy/refpolicy_git.inc

FILESEXTRAPATHS:append := "${THISDIR}:${THISDIR}/patches:"

SRC_URI += "file://add-userdebug_or_eng-macro.patch \
            file://0004-selinux-update-the-getty.te-for-addressing.patch \
            file://mls-enabling-sysadmin-role-for-the-ssh-login.patch \
            file://Move-root-user-to-unconfined-context.patch \
            file://Allow-adbd-to-transition-to-root-user.patch \
            file://common/ \
            file://poky-ssd-rpmb-storage.patch \
"

PROVIDES += "sepolicy"
RPROVIDES:${PN} += "sepolicy"

EXTRA_OEMAKE += "USER_BUILD=${@oe.utils.conditional('USER_BUILD', '1', 'y', 'n', d)}"
EXTRA_OEMAKE += "SETFILES=${RECIPE_SYSROOT_NATIVE}/sbin/setfiles"
# Update userdebug_or_eng macro for VM while other machine images are validated
EXTRA_OEMAKE:append:qti-distro-user = " USER_BUILD=${@bb.utils.contains('BASEMACHINE', 'trustedvm', 'y', 'n', d)}"

# Modules outside of 'services' and 'apps' layer to be removed
PURGE_POLICY_MODULES += "cgmanager automount xguest amanda portage"
# Modules inside 'services' and 'apps' layers to keep. All others in these layers are turned off
CONTRIB_MODULES ?= "chronyd networkmanager shutdown gnome dhcp avahi apache minidlna mta dbus pulseaudio ppp dnsmasq ddclient bluetooth tinyproxy hostapd xserver nscd radvd"

def append_policy_file(src_path, dst_path):
    # Insert our policy fragment before gen_user/user declarations to avoid
    # checkmodule rejecting require{} after a user statement
    with open(src_path, 'r') as src_file:
        new_lines = [line for line in src_file.readlines() if not line.startswith('#')]

    # Skip if no actual content to add
    if not new_lines or all(not l.strip() for l in new_lines):
        os.remove(src_path)
        return

    with open(dst_path, 'r') as dst_file:
        dst_lines = dst_file.readlines()

    # Find insertion point: just before the first gen_user( or user statement
    insert_at = len(dst_lines)
    for i, line in enumerate(dst_lines):
        stripped = line.strip()
        if stripped.startswith('gen_user(') or stripped.startswith('user '):
            insert_at = i
            break

    dst_lines = dst_lines[:insert_at] + ['\n'] + new_lines + dst_lines[insert_at:]

    with open(dst_path, 'w') as dst_file:
        dst_file.writelines(dst_lines)
    os.remove(src_path)

def copy_policy_file(src_path, dst_path):
    # Copy the new file into the sepolicy compilation directory
    os.renames(src_path, dst_path)

def install_device_policy(d, src_root):
    src_dir = os.path.join(d.getVar("UNPACKDIR"), src_root)
    dst_dir = os.path.join(d.getVar("S"), "policy", "modules")
    for root, dirs, files in os.walk(src_dir):
        for file in files:
            policy_file = os.path.relpath(os.path.join(root, file), src_dir)
            src_path = os.path.join(src_dir, policy_file)
            dst_path = os.path.join(dst_dir, policy_file)
            # Ensure .fc files have non-comment content — semodule rejects empty filecon sections
            if file.endswith('.fc'):
                with open(src_path) as f:
                    has_content = any(l.strip() and not l.startswith('#') for l in f)
                if not has_content:
                    with open(src_path, 'w') as f:
                        f.write('# no entries\n')
            if os.path.exists(dst_path):
                append_policy_file(src_path, dst_path)
            else:
                copy_policy_file(src_path, dst_path)

do_patch:append() {
    install_device_policy(d, "common")
}

create_data_ubi_mounted_contexts() {
    # mkfs.ubifs does not support root path substitution like ext4 fs generation tools
    # Create a seperate file_contexts file that just contains paths for a specific
    #  mountpoint and adjust to make that the new 'root'
    sed -n '/^\/data/p' \
        ${D}/etc/selinux/mls/contexts/files/file_contexts | \
        sed 's/^\/data//g' > \
        ${D}/etc/selinux/mls/contexts/files/data_file_contexts
}
do_install[postfuncs] += "${@bb.utils.contains('IMAGE_FSTYPES', 'ubi', 'create_data_ubi_mounted_contexts', '', d)}"

python update_modules_conf () {
    contrib_modules = d.getVar("CONTRIB_MODULES").split()
    module_conf_name = os.path.join(d.getVar("S"), "policy", "modules.conf")
    new_file = ""

    with open(module_conf_name, 'r') as modules_file:
        layer = None
        for line in modules_file.readlines():
            if line.startswith('# Layer'):
                layer = line.split(':')[-1].strip()
            elif '=' in line:
                module_name = line.split('=')[0].strip()
                if (layer == "services" or layer == "apps") and module_name not in contrib_modules:
                    new_file += module_name + ' = off\n'
                    continue
            new_file += line

    # Save the updated modules.conf
    with open(module_conf_name, 'w') as modules_file:
        modules_file.write(new_file)
}
do_compile[postfuncs] += "update_modules_conf"

do_install:append() {
    rm -rf ${D}/${datadir}/selinux/${POLICY_NAME}/*.pp
}

rebuild_policy:append() {
	policy_version=35

	if ${@bb.utils.contains('MACHINE_FEATURES', 'qti-recovery', 'true', 'false', d)}; then
		policy_dir=${D}${sysconfdir}/selinux/${POLICY_NAME}/policy
		mv ${policy_dir}/policy.${policy_version} ${policy_dir}/recovery.policy.${policy_version}
	fi

	if ${@bb.utils.contains('COMBINED_FEATURES', 'qti-ab-boot', 'false', 'true', d)}; then
		manage_policy -d ota
	fi
}
