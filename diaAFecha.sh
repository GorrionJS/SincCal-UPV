#!/bin/bash

# Variables globales para almacenar los parámetros obtenidos
diaReservaOriginal="$1"

arrayDiasSemana=("lunes" "martes" "miércoles" "jueves" "viernes")
arrayDiasSemanaUPV=("Lunes" "Martes" "Miércoles" "Jueves" "Viernes")

# Queremos obtener el índice del día de la reserva para compararlo
# con el día actual.
function get_dia_semana_UPV() {
    for i in ${!arrayDiasSemanaUPV[@]}; do
        if [[ $diaReservaOriginal == ${arrayDiasSemanaUPV[$i]} || ($i -eq 2 && $diaReservaOriginal == Mi*) ]]; then
            diaReservaIndiceUPV=$i
        fi
    done
}

# Queremos obtener el índice del día actual para compararlo
# con el día de la reserva.
function get_dia_semana() {
    for i in ${!arrayDiasSemanaUPV[@]}; do
        if [ $diaActual = ${arrayDiasSemana[$i]} ]; then
            diaActualIndice=$i
        fi
    done
}

# Comparamos los ÍNDICES de ambos días (reserva y actual),
# y obtenemos:
# 1 (Positivo): si el día de la reserva ocurre en el futuro.
# -1 (negativo): el día de la reserva ya pasó.
# 0 (neutro): es el mismo día.
function comparar_dias() {
    if [ $diaReservaIndiceUPV -gt $diaActualIndice ]; then
        echo "1" # Aún no ha pasado el día de la reserva
    elif [ $diaReservaIndiceUPV -lt $diaActualIndice ]; then
        echo "-1" # El día ya ha pasado
    else
        echo "0" # Es el mismo día"
    fi
}

# Obtenemos el nombre del día en el que estamos.
function es_para_hoy() {
    date -d "today" "+%Y-%m-%d"
}

es_entre_semana() {
    
    # 1. Tenemos que comprobar qué día de la semana es (tanto para el que nos encontramos como para la UPV)
    get_dia_semana
    get_dia_semana_UPV

    resultadoComparar=$(comparar_dias)

    # 2. Según el día que sea, elegimos la reserva según el día de la reserva
    case "$diaReservaIndiceUPV" in
        0)
            # if [ $resultadoComparar -gt 0 ]; then
            #     #echo "La reserva es el lunes y es en el futuro"
            #     date -d "next monday" "+%Y-%m-%d"
            if [ $resultadoComparar -lt 0 ]; then
                #echo "La reserva es el lunes pero el día de la reserva ya es pasado"
                date -d "last monday" "+%Y-%m-%d"
            else
                #echo "Es lunes y es el mismo día de la reserva"
                es_para_hoy
            fi
            ;;
        1)
            if [ $resultadoComparar -gt 0 ]; then
                #echo "La reserva es el martes y será en un día futuro a este"
                date -d "next tuesday" "+%Y-%m-%d"
            elif [ $resultadoComparar -lt 0 ]; then
                #echo "La reserva es el martes pero el día de la reserva ya es pasado"
                date -d "last tuesday" "+%Y-%m-%d"
            else
                #echo "Es martes y es el mismo día de la reserva"
                es_para_hoy
            fi
            ;;
        2)
            if [ $resultadoComparar -gt 0 ]; then
                #echo "La reserva es el miércoles y será en un día futuro a este"
                date -d "next wednesday" "+%Y-%m-%d"
            elif [ $resultadoComparar -lt 0 ]; then
                #echo "La reserva es el miércoles pero el día de la reserva ya es pasado"
                date -d "last wednesday" "+%Y-%m-%d"
            else
                #echo "Es miércoles y es el mismo día de la reserva"
                es_para_hoy
            fi
            ;;
        3)
            if [ $resultadoComparar -gt 0 ]; then
                #echo "La reserva es el jueves y será en un día futuro a este"
                date -d "next thursday" "+%Y-%m-%d"
            elif [ $resultadoComparar -lt 0 ]; then
                #echo "La reserva es el jueves pero el día de la reserva ya es pasado"
                date -d "last thursday" "+%Y-%m-%d"
            else
                #echo "Es jueves y es el mismo día de la reserva"
                es_para_hoy
            fi
            ;;
        4)
            if [ $resultadoComparar -gt 0 ]; then
                #echo "La reserva es el viernes y será en un día futuro a este"
                date -d "next friday" "+%Y-%m-%d"
            #elif [ $resultadoComparar -lt 0 ]; then
            #    #echo "La reserva es el viernes pero el día de la reserva ya es pasado"
            #    date -d "last friday" "+%Y-%m-%d"
            else
                #echo "Es viernes y es el mismo día de la reserva"
                es_para_hoy
            fi
            ;;
        *)
            #echo "El día introducido es incorrecto"
    esac
}

es_fin_de_semana() {
    case "$diaReservaOriginal" in
        "Lunes")
            #echo "Es el lunes siguiente"
            date -d "next Monday" "+%Y-%m-%d"
            ;;
        "Martes")
            #echo "Es el martes siguiente"
            date -d "next Tuesday" "+%Y-%m-%d"
            ;;
        Mi*)
            #echo "Es el miércoles siguiente"
            date -d "next Wednesday" "+%Y-%m-%d"
            ;;
        "Jueves")
            #echo "Es el jueves siguiente"
            date -d "next Thursday" "+%Y-%m-%d"
            ;;
        "Viernes")
            #echo "Es el viernes siguiente"
            date -d "next Friday" "+%Y-%m-%d"
            ;;
        *)
            exit 1
            ;;
    esac
}

comprobar_si_es_semana() {
    diaActual=$(date -d "today" "+%A")

    #if [[ "$diaActual" != "sábado" && "$diaActual" != "domingo" ]]; then
    if [[ "$diaActual" != "sábado" && "$diaActual" != "domingo" ]]; then
        # Es semana
        es_entre_semana
    else
        # Fin de semana
        es_fin_de_semana
    fi
}

# Llama a la función para convertir el día de la semana a fecha
comprobar_si_es_semana "$1"