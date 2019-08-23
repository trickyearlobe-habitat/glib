pkg_origin=trickyearlobe
pkg_name=glib
pkg_version="1.3.15"
pkg_description="$(cat << EOF
  GLib is a general-purpose utility library, which provides many useful data
  types, macros, type conversions, string utilities, file utilities, a
  mainloop abstraction, and so on. It works on many UNIX-like platforms, as
  well as Windows and OS X.
EOF
)"
pkg_source="https://download.gnome.org/sources/${pkg_name}/${pkg_version%.*}/${pkg_name}-${pkg_version}.tar.gz"
pkg_license=('LGPL-2.0')
pkg_maintainer='The Habitat Maintainers <humans@habitat.sh>'
pkg_upstream_url="https://developer.gnome.org/glib/"
pkg_shasum="aff60aab07699dea69b7ded77a1afd936e29ebe71395659aa954ec0af02748d7"
pkg_deps=(
  core/coreutils
  core/elfutils
  core/glibc
  core/libffi
  core/libiconv
  core/pcre
  core/python
  core/util-linux
  core/zlib
)
pkg_build_deps=(
  core/dbus
  core/diffutils
  core/file
  core/gcc
  core/gettext
  core/libxslt
  core/make
  core/perl
  core/pkg-config
)
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_pconfig_dirs=(lib/pkgconfig)
pkg_interpreters=(core/coreutils)

do_prepare() {
  if [[ ! -r /usr/bin/file ]]; then
    ln -sv "$(pkg_path_for file)/bin/file" /usr/bin/file
    _clean_file=true
  fi
}

do_build() {
  ./configure \
    --prefix="$pkg_prefix" \
    --with-libiconv \
    --disable-gtk-doc \
    --disable-fam
  make
}

do_after() {
  fix_interpreter "$pkg_prefix/bin/*" core/coreutils bin/env
}

do_end() {
  if [[ -n "$_clean_file" ]]; then
    rm -fv /usr/bin/file
  fi
}