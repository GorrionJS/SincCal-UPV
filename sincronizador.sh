#!/bin/bash

#Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function borrado_ficheros() {
	rm cookies.txt archivo_get.txt primeras_y_segundas_lineas.txt nombre_actividades.txt fichero_dias_horas.txt dias.txt horas_inicio.txt horas_finalizacion.txt 2>/dev/null
}

function ctrl_c() {
	echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
	borrado_ficheros
	tput cnorm && exit 1
}

#############################################################

# Variables globales (credenciales) - MODIFICAR POR EL USUARIO
DNI="12345678"
PASSWORD="Tu_contraseña"

# Variables globales (enlaces)
intranet_centro_deportes="https://intranet.upv.es/pls/soalu/sic_depact.HSemActividades?p_idioma=c&p_vista=intranet"
intranet_login_URL="https://intranet.upv.es/pls/soalu/est_aute.intraalucomp"

#############################################################

clear
tput civis # Ocultar el cursor
trap ctrl_c SIGINT # Asociar función a la interrupción "ctrl + c"

# Banner
toilet -f mono9 -F border GorrionJS
toilet -f pagga SincCal-UPV

sleep 4

echo -e "\n\n\n${yellowColour}[+]${endColour} ${grayColour}Se va a proceder a iniciar sesión con los datos introducidos...${endColour}"

# Nos loguemaos en la web de la UPV
curl -s -X POST -d "dni=$DNI&clau=$PASSWORD" "$intranet_login_URL" -c cookies.txt

# Comprobamos si el "cookies.txt" está vacío para saber si el inicio de sesión ha tenido éxito
linea=$(awk 'NR==5' cookies.txt)

if [[ $linea =~ ^\.upv\.es ]]; then

	# Vamos a conseguir las actividades en las que el usuario está suscrito
	curl -s -X GET "$intranet_centro_deportes" -b cookies.txt > archivo_get.txt

	nombre_usuario_logueado=$(cat archivo_get.txt | grep -a ".*ON-LINE de Actividades Deportivas</h1>" -A 5 | grep -a name | awk -F ";" '{print $2}' | sed 's/.....$//')
	echo -e "\n\n${greenColour}[+] Se ha iniciado sesión correctamente como:\t ${endColour}${redColour}${nombre_usuario_logueado}${endColour}"
	sleep 3

	sed -n '/bloque_inscritas/,/<h2>Seleccione un campus<\/h2>/p' archivo_get.txt | tail -n +17 | head -n -11 | awk 'NR%11==1 || NR%11==2' | cut -c 5- > primeras_y_segundas_lineas.txt
	echo -e "\n\n${greenColour}[+]${endColour} ${grayColour}Se han conseguido las actividades registradas correctamente.${endColour}\n"
	sleep 3

	# Obtenemos los nombres de las actividades
	awk 'NR%2==1' primeras_y_segundas_lineas.txt | awk '{print $1}' > nombre_actividades.txt

	# Obtenemos las fechas que nos interesan
	awk 'NR%2==0' primeras_y_segundas_lineas.txt | awk '{print $3"\t"$5"\t"$7}' > fichero_dias_horas.txt

	# Obtenemos dias
	awk '{print $1}' fichero_dias_horas.txt | awk -F ">" '{print $2}' > dias.txt

	# Obtenemos horas_inicio
	awk '{print $2}' fichero_dias_horas.txt > horas_inicio.txt

	# Obtenemos horas_finalizacion
	awk '{print $3}' fichero_dias_horas.txt > horas_finalizacion.txt

	#if [[ #numero de lineas de ficheros == en todos los ficheros ]] do

	echo -e "\n\n${grayColour}##############################################################################${endColour}"
	sleep 1
	echo -e "\n\n${grayColour}[+] Se va a comenzar con las reservas:${endColour}\n"

	num_lineas=$(wc -l nombre_actividades.txt | cut -d ' ' -f 1)
	for ((i = 1; i <= num_lineas; i++));
	do
		nombre_actividad=$(awk "NR==$i" ./nombre_actividades.txt)

		# Llamamos al archivo "emojiActividad.sh"
		nombre_actividad=$(source emojiActividad.sh $nombre_actividad)

		dia_actividad=$(awk "NR==$i" ./dias.txt)

		hora_inicio=$(awk "NR==$i" ./horas_inicio.txt)

		hora_finalizacion=$(awk "NR==$i" ./horas_finalizacion.txt)

		sleep 2

		echo -e "\t${blueColour}[X]${endColour}${grayColour} Se va a hacer una reserva de${endColour} ${redColour}${nombre_actividad}${endColour} ${grayColour}el${endColour} ${yellowColour}${dia_actividad}${endColour} ${grayColour}a las${endColour} ${yellowColour}${hora_inicio}${endColour}${grayColour}...${endColour}" 

		sleep 1

		# Por cada una de estas iteraciones, vamos a crear un evento
		dia_actividad=$(source diaAFecha.sh $dia_actividad)
		python3 addEvent.py "$nombre_actividad" "${dia_actividad}T${hora_inicio}:00+02:00" "${dia_actividad}T${hora_finalizacion}:00+02:00"

		num=$?

		if [[ num -eq 0 ]]; then
			echo -e "\t${redColour}[!]${endColour}${grayColour} El evento ${endColour}${redColour}ya existe en el calendario,${endColour}${grayColour} se va a proceder con la siguiente actividad.${endColour}"
		else
			echo -e "\t${greenColour}[+]${endColour}${grayColour} Se ha registrado ${greenColour}correctamente${endColour}${grayColour} el evento.${endColour}"
		fi

		echo -e "\n"

		sleep 1

	done

	borrado_ficheros

	sleep 2

	echo -e "\n\n${greenColour}[0] ¡Proceso finalizado, muchas gracias!${endColour}\n"

	tput cnorm && exit 1

else
	echo -e "\n\n${redColour}[!] Error al iniciar sesión${endColour}\n"
	echo -e "${redColour}[!] Saliendo...${endColour}\n"
	borrado_ficheros
	tput cnorm && exit 1
fi
