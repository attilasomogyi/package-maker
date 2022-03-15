#!/bin/bash
package_name=$(basename `git rev-parse --show-toplevel`)
package_version=$(git describe --abbrev=0 | sed 's/v//')
maintainer_name=$(git config --get user.name)
maintainer_email=$(git config --get user.email)
arch="noarch"
license=$(licensee detect $(git rev-parse --show-toplevel) | grep License: | head -1 | sed 's/ //g' | awk -F ':' '{print $2}')
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
pandoc -f gfm -t plain $(git rev-parse --show-toplevel)/README.md>>$spec 
echo "%prep">>$spec
echo "%build">>$spec
echo "%install">>$spec
echo "%check">>$spec
echo "%files">>$spec
echo "%license LICENSE.md">>$spec
echo "%changelog">>$spec
pandoc -f gfm -t plain $(git rev-parse --show-toplevel)/CHANGELOG.md>>$spec
mkdir -p debian
pandoc -f gfm -t plain $(git rev-parse --show-toplevel)/CHANGELOG.md>>$debian_changelog
echo "$debian_compact_level">$debian_compact
echo -n>$debian_control
echo "Source: $package_name">>$debian_control
echo "Maintainer: $maintainer_name <$maintainer_email>">>$debian_control
