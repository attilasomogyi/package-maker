#!/bin/bash
package_name=$(basename `git rev-parse --show-toplevel`)
package_version=$(git describe --abbrev=0 | sed 's/v//')
license=$(licensee | grep License: | head -1 | sed 's/ //g' | awk -F ':' '{print $2}')
spec=rpmbuild/SPECS/$package_name.spec
mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}|| exit 1
echo -n >$spec
echo "Name:    $package_name">>$spec
echo "Version: 1%{?dist}">>$spec
echo "Summary: ">>$spec
echo "License: $license">>$spec
echo -n >>$spec
