#!/bin/bash -e

if [ -z "$GIT_URL" ]; then
	GIT_URL=git://git.samba.org/samba.git
fi

TEVENTTMP=`mktemp -d`
git clone --depth 1 $GIT_URL $TEVENTTMP
if [ ! -z "$REFSPEC" ]; then
	pushd $TEVENTTMP
	git checkout $REFSPEC || exit 1
	popd
fi
pushd $TEVENTTMP/lib/tevent
./configure
make dist
popd
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9]\+$//' )
mv $TEVENTTMP/lib/tevent/tevent-*.tar.gz tevent_$version.orig.tar.gz
rm -rf $TEVENTTMP
