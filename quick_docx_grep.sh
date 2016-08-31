#!/bin/bash
cleanup ()
{
    echo $dir
    if [ "$doclean" eq "1" ]
    then
        rm -r $dir
    fi    
}


fail() {
    cleanup
    exit "$1"
}

verbosity=0
doclean=1
if [ -z "$3" ]
then
    verbosity=$3
fi

if [ -z "$4" ]
then
    doclean=$4
fi

err=0;

if [ -z "$2" ]
then
    echo "No search term present"
    fail 1
fi

dir=`mktemp -d`
if [ ! -f $1 ]
then
    echo "File doesn't exist\n"
    fail 2
fi

if [ ! -d $dir ]
then
    echo "Failed to create temp directory\n"
    fail 3
fi

unzip $1 -d $dir > /dev/null



if [ $? -gt 0 ]
then
    echo "Unzip failed with status $?\n"
    exit 4
fi

file="$dir/word/document.xml";

if [ ! -e $file ]
then
   echo "Zip file didn't contain document.xml"
   fail 5
fi

command="grep -i $2 $file"

out=$(exec $command)
if [ ! -z "$out" ]
then
    echo "found in $1"
fi

exit 0

