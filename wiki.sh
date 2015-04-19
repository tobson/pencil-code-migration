#!/bin/bash

random=$RANDOM

wiki=wiki-$random

echo "Cloning SVN repository $1 into Git repository at $wiki ..."
rm -rf $wiki
git svn clone -T wiki -A authors.txt --no-metadata file://$(realpath $1) $wiki
echo

echo "Converting all wiki pages to markdown ..."
cd $wiki
for file in *.wiki
do
    python ../wiki2gfm.py --input_file ${file} --output_file ${file/.wiki/.md}
    mv ${file/.wiki/.md} ${file}
done
git add -A
git commit -m "Dummy."
for file in *.wiki
do
    git mv ${file} ${file/.wiki/.md}
done
git add -A
git commit --amend -m "Auto-converted all wiki pages to markdown"
cd -
echo

echo "Done."
