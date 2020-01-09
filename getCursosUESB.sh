#!/bin/bash


file="./curso-uesb.txt";
curso=$( grep -i "<title>" $file | cut -d "-" -f1 | cut -d ">" -f2 );
id_curso=$( cat curso-uesb.txt | grep "/storage/fluxogramas/" | cut -d "_" -f1 | cut -d "/" -f4 );
campus=$( grep -i "<title>" $file | cut -d "-" -f2 );
turno=$( grep -i "<title>" $file | cut -d "-" -f3 );
json_file="$id_curso.json";
temp_file="./temp-file.txt";


echo "{" >> "$json_file";
echo "\"curso\": \"$curso\"," >> $json_file;
echo "\"idCurso\": \"$id_curso\"," >> $json_file;
echo "\"campus\": \"$campus\"," >> $json_file;
echo "\"turno\": \"$turno\"," >> $json_file;
echo "\"grade\": [" >> $json_file;

first_line=$( cat curso-uesb.txt | grep -in "01 semestre" | cut -d ":" -f1 );

tail -n +$first_line $file > $temp_file;
sed -i '/[tr+td+\</small>\+\;\+}]/d' $temp_file
sed -i 's/^\s*$/>>>>>>>>>>>/' $temp_file




periodos=$( cat curso-uesb.txt | grep -i "semestre" | wc -l );
line_number=1;
for periodo in $(seq $periodos); do
    echo "{" >> "$json_file";
    echo "\"periodo\": \"$periodo\"," >> $json_file;
    echo "\"materias\": [" >> $json_file;

    while true; do
        

        line=$(sed -n "${line_number}p" < $temp_file);

        
        if ( echo $line | grep ">" ); then
            sed -i '$ s/.$//' $json_file;
            echo "]}," >> "$json_file";
            line_number=$((line_number + 2));
            break;
        fi
        echo "{" >> $json_file;
        
        codigo_line=$line_number;
        nome_line=$((line_number + 1));
        horas_line=$((line_number + 2));
        creditos_line=$((line_number + 3));
        pre_requisito_line=$((line_number + 4));

        codigo=$(sed -n "${codigo_line}p" < $temp_file);
        nome=$(sed -n "${nome_line}p" < $temp_file);
        horas=$(sed -n "${horas_line}p" < $temp_file);
        creditos=$(sed -n "${creditos_line}p" < $temp_file);
        pre_requisito=$(sed -n "${pre_requisito_line}p" < $temp_file);

        echo "\"codigo\": \"$codigo\"," >> $json_file;
        echo "\"nome\": \"$nome\"," >> $json_file;
        echo "\"horas\": \"$horas\"," >> $json_file;
        echo "\"creditos\": \"$creditos\"," >> $json_file;
        echo "\"preRequisito\": [\"$pre_requisito\"" >> $json_file;
        echo "]}," >> $json_file;
        line_number=$((line_number + 5));

        
    done
done

sed -i '$ s/.$//' $json_file;
echo "]}" >> $json_file;
