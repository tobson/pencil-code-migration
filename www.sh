#!/bin/bash

random=$RANDOM

temp=temp-$random
www=www-$random

echo "Cloning SVN repository $1 into Git repository at $temp ..."
rm -rf $temp
git svn clone -T branches/www -A authors.txt --no-metadata file://$(realpath $1) $temp
echo

echo "Removing large files ..."
cd $temp
git filter-branch --prune-empty --tree-filter 'rm -f pics/Anders.gif' HEAD
cd -
echo

echo "Cloning $temp without hardlinks into $www"
git clone --no-hardlinks file://$(realpath $temp) $www
echo

echo "Done."
