#!/bin/sh 

set -e

dir=$1

if [ $# -lt 1 ]
then	echo "Usage: $0 packagedir"
	exit 1
fi

if [ ! -d "$dir" ]
then	echo "Error: $dir isn't a directory."
	exit 1
fi

here=`pwd`
srcdir=$here/$dir
packagestart=$srcdir/now
findlist=$srcdir/findlist
tarfile=${dir}.tar
tar=$srcdir/$tarfile
targz=$tarfile.gz

binsizes big
touch $packagestart
sleep 1
cd $dir

if [ ! -f build ]
then	echo "Error: No build script in $dir."
	exit 1
fi

sh build
cd /
echo " * Making file index, writing $targz"
find / -cnewer $packagestart | grep -v "^$srcdir" | grep -v "^/dev" | grep -v "^/tmp" | grep -v "^/usr/tmp" | pax -w -d -z >$targz
echo " * Ok. Cleanup.."
rm -f $packagestart $findlist $tarcmd
binsizes normal
mv $targz $here
ls -al $here/$targz
exit 0
