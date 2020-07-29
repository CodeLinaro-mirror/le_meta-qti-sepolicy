# Replace coreutils and findutils with busybox
RDEPENDS_${BPN}-fixfiles_remove = "grep findutils"
RDEPENDS_${BPN}-fixfiles_append = " busybox"
RDEPENDS_${BPN}_remove = "grep findutils"
RDEPENDS_${BPN}_append = " busybox"
