#!/bin/bash
package_name=$(basename `git rev-parse --show-toplevel`)
git_root=$(git rev-parse --show-toplevel)
package_version=$(git describe --abbrev=0 | sed 's/v//')
maintainer_name=$(git config --get user.name)
maintainer_email=$(git config --get user.email)
arch="noarch"
license=$(licensee detect $git_root | grep License: | head -1 | sed 's/ //g' | awk -F ':' '{print $2}')
summary=$(gh repo view --json description | jq -r '.description')
spec=rpmbuild/SPECS/$package_name.spec
url=$(gh repo view --json url | jq -r '.url')
build_requires=""
requires=""
source_url=""
debian_changelog=debian/changelog
debian_compact=debian/compact
debian_compact_level=10
debian_control=debian/control
debian_section=misc
debian_arch="all"
debian_copyright=debian/copyright
mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}|| exit 1
echo -n >$spec
echo "Name:          $package_name">>$spec
echo "Version:       $package_version">>$spec
echo "Release:       1%{?dist}">>$spec
echo "Summary:       $summary">>$spec
echo "License:       $license">>$spec
echo "URL:           $url" >>$spec
echo "Source0:       $source_url" >>$spec
echo "BuildArch:     $arch">>$spec
echo "BuildRequires: $build_requires">>$spec
echo "Requires:      $requires">>$spec
echo "%description">>$spec
pandoc -f gfm -t plain $git_root/README.md>>$spec 
echo "%prep">>$spec
echo "%build">>$spec
echo "%install">>$spec
echo "%check">>$spec
echo "%files">>$spec
echo "%license LICENSE.md">>$spec
echo "%changelog">>$spec
pandoc -f gfm -t plain $git_root/CHANGELOG.md>>$spec
mkdir -p debian
pandoc -f gfm -t plain $git_root/README.md>>$debian_changelog
echo "$debian_compact_level">$debian_compact
echo -n>$debian_control
echo "Source: $package_name">>$debian_control
echo "Maintainer: $maintainer_name <$maintainer_email>">>$debian_control
echo "Section: $debian_section">>$debian_control
echo "Priority: optional">>$debian_control
echo "Standards-Version: $package_version">>$debian_control
echo "Build-Depends: debhelper (>= 9)">>$debian_control
echo "Package: $package_name">>$debian_control
echo "Architecture: $debian_arch">>$debian_control
echo "Depends: \${shlibs:Depends}, \${misc:Depends}">>$debian_control
echo "Description: $summary">>$debian_control
pandoc -f gfm -t plain $git_root/README.md>>$debian_control
echo -n >$debian_copyright
echo "Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/">>$debian_copyright
echo "Upstream-Name: $package_name">>$debian_copyright
echo "Upstream-Contact: $maintainer_name <$maintainer_email>">>$debian_copyright
echo "Source: $url">>$debian_copyright
