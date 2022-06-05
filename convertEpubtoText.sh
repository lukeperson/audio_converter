#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

top=2
mininum_words=10

cd ~/Downloads
epub="$(ls *.epub -1t | head -1)"
cp ~/Downloads/"$epub" ~/Epubs
epubName="${epub%.*}"

rm -rf tmp
unzip "$epub" -d tmp
cd tmp
find ~/Downloads/tmp/ -depth -name '* *' -exec sh -c '
    for file do
      dir=${file%/*};
      file=${x##*/};
      without_spaces=$(printf %s "$file." | sed "s/ //g")
      mv "$dir/$file" "$dir/${without_spaces%.}";
    done
' _ {} +



echo ======================================================== Finished unzip
source_files=$(find * -type f -name "*html")
echo $source_files

OIFS="$IFS"
IFS=$'\n'
for file in $source_files
do
    echo $file
    textutil -convert txt $file
    fi
done
IFS="$OIFS"

echo ======================================================== Finished processing


finalDir=$(echo $epubName | sed "s/ /_/g" | sed "s/['\"‘’“”…,!@#$%^&*().<>]//g" )
rm -rf ~/txt/$finalDir
rm -rf ~/Audio/$finalDir
mkdir -p ~/txt/$finalDir
find * -type f -name "*.txt" -exec mv {} ~/txt/$finalDir \;

for file in *.txt
do
    linecnt=$(cat "$file"| wc -w )
    if [ $linecnt -lt $mininum_words ] || [[ "$file" == *copyright* ]]; then
        continue
    fi
    echo "${green}$file${reset}"
    head $file
    echo ====================================
done

echo "${green}Min word filter${reset}"

# Delete empty files
numDeletedFiles=0
cd ~/txt/$finalDir
for file in *.txt
do
    linecnt=$(cat "$file"| wc -w )
    if [ $linecnt -lt $mininum_words ] || [[ "$file" == *copyright* ]]; then
        echo "Deleting file $numDeletedFiles: ${red}$file - $linecnt words${reset}"
        echo $(cat $file)
        echo --------------------------------------------------------------------
        rm "$file"
        let "numDeletedFiles+=1"
        echo 
    fi
done

# Move images
imgDir=~/images/"$finalDir"_images
rm -rf $imgDir
mkdir $imgDir
find ~/Downloads/tmp -iname "*.jpg" -exec mv {} $imgDir \;
find ~/Downloads/tmp -iname "*.jpeg" -exec mv {} $imgDir \;
find ~/Downloads/tmp -iname "*.png" -exec mv {} $imgDir \;
numImgs=$(ls $imgDir | wc -l)

if [ $numImgs -eq 0 ]; then
    rm -rf $imgDir
fi

echo

echo ---------------------------------------------------------
echo "${green}Images${reset}"
ls -1v $imgDir
echo ---------------------------------------------------------
echo "${green}Files${reset}"
ls -1v ~/txt/$finalDir
echo ---------------------------------------------------------

words=$(cat ~/txt/$finalDir/* | wc -w)
numPages=$(($words/300))

if [ $words -eq 0 ]; then
    words="${red}$words${reset}"
fi
if [ $numDeletedFiles -gt 0 ]; then
    numDeletedFiles="${red}$numDeletedFiles${reset}"
fi
if [ $numImgs -gt 0 ]; then
    numImgs="${green}$numImgs${reset}"
fi

echo -e "${green}Statistics${reset}"
echo "Number of files: $(ls ~/txt/$finalDir | wc -l)"
echo "Number of deleted files: $numDeletedFiles"
echo "Number of images: $numImgs"
echo "Number of words: $words"
echo "Number of pages: $numPages"
echo ---------------------------------------------------------
