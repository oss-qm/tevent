#!/bin/bash
GIT_URL=$1
REFSPEC=$2
shift 2

if [ -z "$GIT_URL" ]; then
	GIT_URL=git://git.samba.org/samba.git
fi

TEVENTTMP=$TMPDIR/$RANDOM.tevent.git
git clone --depth 1 $GIT_URL $TEVENTTMP
if [ ! -z "$REFSPEC" ]; then
	pushd $TEVENTTMP
	git checkout $REFSPEC || exit 1
	popd
fi
pushd $TEVENTTMP/lib/tevent
./autogen-waf.sh
./configure
make dist
popd
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )
mv $TEVENTTMP/lib/tevent/tevent-*.tar.gz tevent-$version.tar.gz
rm -rf $TEVENTTMP
