#!/bin/bash

random=$RANDOM

temp=temp-$random
trunk=trunk-$random

echo "Cloning SVN repository $1 into Git repository at $temp ..."
rm -rf $temp
git svn clone -T trunk -A authors.txt --no-metadata file://$(realpath $1) $temp
echo

echo "Removing large files ..."
list=$(cat filter.txt)
cd $temp
git filter-branch --prune-empty \
    --index-filter "git rm --cached -rf --ignore-unmatch $(echo $list)" \
    --tag-name-filter cat -- --all
cd -
echo

echo "Cloning $temp without hardlinks into $trunk"
git clone --no-hardlinks file://$(realpath $temp) $trunk
echo
