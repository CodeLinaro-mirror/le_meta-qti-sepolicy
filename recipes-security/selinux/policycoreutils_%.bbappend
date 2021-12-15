# Replace coreutils and findutils
RDEPENDS_${BPN}-fixfiles_remove = "grep findutils"
RDEPENDS_${BPN}-fixfiles_append = " ${PREFERRED_PROVIDER_virtual/base-utils}"
RDEPENDS_${BPN}_remove = "grep findutils"
RDEPENDS_${BPN}_append = " ${PREFERRED_PROVIDER_virtual/base-utils}"
