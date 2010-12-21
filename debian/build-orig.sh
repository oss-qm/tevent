#!/bin/bash -e

if [ -z "$SAMBA_GIT_URL" ]; then
	SAMBA_GIT_URL=git://git.samba.org/samba.git
fi

TEVENTTMP=`mktemp -d`
if [ -d $SAMBA_GIT_URL/.bzr ]; then
	bzr co --lightweight $SAMBA_GIT_URL $TEVENTTMP
else
	git clone --depth 1 $SAMBA_GIT_URL $TEVENTTMP
fi
pushd $TEVENTTMP/lib/tevent
./configure
make dist
popd
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9]\+$//' )
mv $TEVENTTMP/lib/tevent/tevent-*.tar.gz tevent_$version.orig.tar.gz
rm -rf $TEVENTTMP
