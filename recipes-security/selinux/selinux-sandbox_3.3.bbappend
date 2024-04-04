#Fetch sources from codelinaro
SRC_URI:remove = "git://github.com/SELinuxProject/selinux.git;branch=master;protocol=https"
SRC_URI:prepend = " ${CLO_YOCTO_MIRROR}/selinux;protocol=https;branch=master;protocol=https "
