# Replace coreutils and findutils
RDEPENDS:${BPN}-fixfiles:remove = "grep findutils"
RDEPENDS:${BPN}-fixfiles:append = " ${PREFERRED_PROVIDER_virtual/base-utils}"
RDEPENDS:${BPN}:remove = "grep findutils"
RDEPENDS:${BPN}:append = " ${PREFERRED_PROVIDER_virtual/base-utils}"
