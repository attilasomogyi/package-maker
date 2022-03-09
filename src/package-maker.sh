#!/bin/bash
package_name=$(basename `git rev-parse --show-toplevel`)
package_version=$(git describe --abbrev=0 | sed 's/v//')
arch="noarch"
license=$(licensee detect $(git rev-parse --show-toplevel) | grep License: | head -1 | sed 's/ //g' | awk -F ':' '{print $2}')
summary=$(gh repo view --json description | jq -r '.description')
spec=rpmbuild/SPECS/$package_name.spec
url=$(git config --get remote.origin.url)
mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}|| exit 1
echo -n >$spec
echo "Name:      $package_name">>$spec
echo "Version:   $package_version">>$spec
echo "Release:   1%{?dist}">>$spec
echo "Summary:   $summary">>$spec
echo "License:   $license">>$spec
echo "URL:       $url" >>$spec
echo "Source0:   $url" >>$spec
echo "Patch0:    $url" >>$spec
echo "BuildArch: $arch">>$spec
