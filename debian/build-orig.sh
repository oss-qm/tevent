#!/bin/bash
REFSPEC=$1
GIT_URL=$2
shift 2

if [ -z "$GIT_URL" ]; then
	GIT_URL=git://git.samba.org/samba.git
fi

if [ -z "$REFSPEC" ]; then
	REFSPEC=origin/master
fi

TEVENTTMP=$TMPDIR/$RANDOM.tevent.git
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )
git clone --depth 1 -l $GIT_URL $TEVENTTMP
if [ ! -z "$REFSPEC" ]; then
	pushd $TEVENTTMP
	git checkout $REFSPEC || exit 1
	popd
fi

mv $TEVENTTMP/lib/tevent "tevent-$version"
mv $TEVENTTMP/lib/replace "tevent-$version/libreplace"
rm -rf $TEVENTTMP
pushd "tevent-$version" && ./autogen.sh && popd
tar cvz "tevent-$version" > "tevent_$version.orig.tar.gz"
rm -rf "tevent-$version"
