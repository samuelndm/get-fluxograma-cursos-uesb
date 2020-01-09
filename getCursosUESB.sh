#!/bin/bash


file="./curso-uesb.txt";
curso=$( grep -i "<title>" $file | cut -d "-" -f1 | cut -d ">" -f2 );
campus=$( grep -i "<title>" $file | cut -d "-" -f2 );
turno=$( grep -i "<title>" $file | cut -d "-" -f3 );


first_line=$( cat curso-uesb.txt | grep -in "01 semestre" | cut -d ":" -f1 );

tail -n +$first_line $file > ./temp-file.txt;
sed -i '/[tr+td+\</small>\+\;\+}]/d' ./temp-file.txt
sed -i 's/^\s*$/>>>>>>>>>>>/' ./temp-file.txt
