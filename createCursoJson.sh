#!/bin/bash
json_file="curso-info.json";
codigoPeriodo=0;
codigoMateria=0;

touch $json_file && chmod 711 $json_file;

echo "{" >> $json_file;
echo "Id: "; read id && echo "\"id\": \"$id\"," >> $json_file;
echo "Curso: "; read curso && echo "\"curso\": \"$curso\"," >> $json_file;
echo "Turno: "; read turno && echo "\"turno\": \"$turno\"," >> $json_file;
echo "Faculdade: "; read faculdade && echo "\"faculdade\": \"$faculdade\"," >> $json_file;
echo "Campus: "; read campus && echo "\"campus\": \"$campus\"," >> $json_file;
echo "\"grade\": [" >> $json_file;

while true; do
    echo "Adicionar Período? (s/N): "; read continuarLibera;
    case $continuarLibera in
        n|N)
            sed -i '$ s/.$//' $json_file;
            echo "}]" >> $json_file;
            break ;;
    esac

    codigoPeriodo=$((codigoPeriodo + 1)); echo "{ \"periodo\": \"$codigoPeriodo\"," >> $json_file;
    echo "\"materias\": [" >> $json_file;
    while true; do
        echo "Adicionar Matéria? (s/N): "; read continuarMateria;

        case $continuarMateria in
            n|N)
                sed -i '$ s/.$//' $json_file;
                echo "]}," >> $json_file;
                break ;;
        esac
        codigoMateria=$((codigoMateria + 1)); echo "{ \"codigo\": \"$codigoMateria\"," >> $json_file;
        echo "Nome: "; read nome && echo "\"nome\": \"$nome\"," >> $json_file;
        echo "Horas: "; read horas && echo "\"horas\": \"$horas\"," >> $json_file;
        echo "Creditos: "; read creditos && echo "\"creditos\": \"$creditos\"," >> $json_file;

        preRequisitoString="\"PreRequisito\": [";
        while true; do
            echo "Adicionar Pré-requisito? (s/N): "; read continuarPreReq;
            case $continuarPreReq in
                n|N)    
                    lastCharPreRequisitoString=${preRequisitoString: -1};
                    echo $lastCharPreRequisitoString;
                    case $lastCharPreRequisitoString in
                        ,) preRequisitoString=${preRequisitoString::-1} ;;
                    esac
                    preRequisitoString+="]";
                    echo $preRequisitoString >> $json_file;
                    break;;
            esac
            echo "preRequisito: "; read preRequisito;
            preRequisitoString+=" $preRequisito,";
        done
        echo "}," >> $json_file;
    done
done
echo "}" >> $json_file;
