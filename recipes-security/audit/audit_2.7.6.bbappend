EXTRA_OECONF += "--without-prelude \
        --with-libwrap \
        --enable-gssapi-krb5=no \
        --with-libcap-ng=no \
        --with-python=no \
        --libdir=${base_libdir} \
        --sbindir=${base_sbindir} \
        --without-python3 \
        --disable-zos-remote \
        "

do_gzip_tarball() {
    # The format of the downloaded audit tarball does not always match the
    #  file extension. Correct this before the bitbake unpacker runs.
    filetype=`file -bi ${DL_DIR}/${BPN}-${PV}.tar.gz`
    if [[ "${filetype}" == "application/x-tar; charset=binary" ]]; then
        mv ${DL_DIR}/${BPN}-${PV}.tar.gz ${DL_DIR}/${BPN}-${PV}.tar
        gzip ${DL_DIR}/${BPN}-${PV}.tar
    fi
}
do_unpack[prefuncs] += "do_gzip_tarball"

SRC_URI[md5sum] = "f1ffa0cb5d578cc9f188049a94e0638b"
SRC_URI[sha256sum] = "9fe9d23cceabd94ec89b3d40ac3816f6ab0538535c146ed01f3f0f2fc2181caf"
