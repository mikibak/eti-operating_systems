#!/bin/bash

grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4 | sort | uniq | cut -d '"' -f 2 | sed "s#.*/##" | grep "\.is" >> ftp.txt
grep '" 200' cdlinux.www.log | grep -v "mirror" | cut -d ":" -f 2,3,4,5 | cut -d " " -f 1,7 | grep "\.iso" | sort | grep -v "compatible" | uniq | sed "s#.*/##" >> ftp.txt
sort ftp.txt | sed "s#.*/##" | uniq -c | sort -nr
rm -r ftp.txt
