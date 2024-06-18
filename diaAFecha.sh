#!/bin/bash

# Función para convertir días de la semana a formato de fecha
day_to_date() {
    case "$1" in
        "Lunes")
            date -d "next Monday" "+%Y-%m-%d"
            ;;
        "Martes")
            date -d "next Tuesday" "+%Y-%m-%d"
            ;;
        "Mi�rcoles")
            # Pasa a ser la de defecto, ya que no podemos capturar cuándo es miércoles correctamente por la tilde, 
            # aprovechamos que es la única opción restante ya que no puede ser ni sábado ni domingo
            ;;
        "Jueves")
            date -d "next Thursday" "+%Y-%m-%d"
            ;;
        "Viernes")
            date -d "next Friday" "+%Y-%m-%d"
            ;;
        *)
            date -d "next Wednesday" "+%Y-%m-%d"
            exit 1
            ;;
    esac
}

# Verifica que se haya pasado un día de la semana como argumento
# "$#" servía para saber el número total de argumentos pasados
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 'Día de la semana'"
    exit 1
fi

# Llama a la función para convertir el día de la semana a fecha
day_to_date "$1"