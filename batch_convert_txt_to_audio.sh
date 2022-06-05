#!/bin/bash

cd ~/txt
book=$(ls -1t | head -1)

while [ ! -z "$book" ]
do
    echo "$book"
    cd $book

    for file in *.txt
    do
        filename="${file%.*}"
        say -f $file -r $1 -v Karen -o "$filename.aiff"
        /usr/local/bin/ffmpeg -i "$filename.aiff" "$filename.wav" &>/dev/null

        echo "    $filename"
    done
    total=0
    while read -r f; do
        d=$(soxi -D "$f")
        total=$(echo "$total + $d" | bc)
    done < <(find * -iname "*.wav")

    echo ""
    echo "    $book"
    echo "    Total $(date -d@$total -u +%H:%M:%S) "
    echo ""

    find . -type f -name '*.aiff' -delete
    find . -type f -name '*.txt' -delete
    cd ~/txt
    mv $book ~/Audio
    book=$(ls -1t | head -1)
done
