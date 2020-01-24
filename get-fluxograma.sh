#!/bin/bash

curso_path="./cursos/jequie";
cursos_list=$(ls $curso_path);
id_curso=14202


for i in ${cursos_list}; do
    file="$curso_path/$i";
    id_curso=$((id_curso + 1));

    curso=$( grep -i "<title>" $file | cut -d "-" -f1 | cut -d ">" -f2 );
    new_curso_name="";
    tipo_curso=""

    contWord=0
    for word in $curso; do
        contWord=$((contWord + 1));

        if [[ $contWord = 1 ]]; then
            tipo_curso+=" $word";
        
        elif [[ $contWord > 2 ]]; then
            new_curso_name+=" $word";
            
        fi
    done

    curso=$(echo $new_curso_name);
    tipo_curso=$(echo $tipo_curso | sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*$//g');
    campus=$( grep -i "<title>" $file | cut -d "-" -f3 | sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*$//g');
    turno=$( grep -i "<title>" $file | cut -d "-" -f2 | sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*$//g');
    json_file="cursos.json";
    temp_file="./temp-file.txt";


    echo "{" >> "$json_file";
    echo "\"curso\": \"$curso\"," >> $json_file;
    echo "\"idCurso\": $id_curso," >> $json_file;
    echo "\"tipoCurso\": \"$tipo_curso\"," >> $json_file;
    echo "\"campus\": \"$campus\"," >> $json_file;
    echo "\"turno\": \"$turno\"," >> $json_file;
    echo "\"grade\": [" >> $json_file;

    first_line=$( cat $file | grep -in "01 semestre" | cut -d ":" -f1 );

    tail -n +$first_line $file > $temp_file;
    sed -i '/[tr+td+small><+;+}]/d' $temp_file
    sed -i 's/^\s*$/>>>>>>>>>>>/' $temp_file




    periodos=$( cat $file | grep -i "semestre" | wc -l );
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

            codigo=$(sed -n "${codigo_line}p" < $temp_file | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//');
            nome=$(sed -n "${nome_line}p" < $temp_file | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//');
            horas=$(sed -n "${horas_line}p" < $temp_file | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//');
            creditos=$(sed -n "${creditos_line}p" < $temp_file | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//');
            pre_requisito=$(sed -n "${pre_requisito_line}p" < $temp_file | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//');
            pre_requisito=$(echo $pre_requisito | sed 's/,/","/g' | sed 's/,"[[:space:]]/,"/g');

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
    echo "]}," >> $json_file;
done
