# SincCal-UPV

**¿Eres alumno de la UPV y te gusta realizar deporte? ¿Estás cansado de tener que añadir a mano todos los días que vas a hacer ejercicio?** Pues SincCal-UPV es la solución para tus problemas.

- **SincCal-UPV** es una aplicación desarrollada en **Bash y Python** con el objetivo de sincronizar todas las actividades a las que un usuario de la UPV se inscriba, a su calendario personal de Google Calendar.



<img src="/images/logo_prototipo.png" alt="Imagen del logo de la aplicación" width="100">
<img src="/images/portada.png" alt="Imagen de la portada dónde se ven los logos" witdh="100">
<img src="/images/actividades_registradas.png" alt="Imagen dónde se pueden las actividades reservadas correctamente" witdh="">
<img src="/images/activiades_existentes.png" alt="Imagen dónde se pueden ver las actividades que se quieren registrar pero ya están añadidas" witdh="100">


## Antes de empezar - Dependencias

- Instala las siguientes dependencias:

```
sudo apt-get update
sudo apt install curl
sudo apt-get install python3-pip
sudo apt install toilet
```
```
pip install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib
```

## Antes de empezar - Requisitos
1. [Crea un nuevo proyecto](https://console.developers.google.com/projectcreate) en la consola de desarrolladores de Google

    - Pulsa sobre el botón **Crear**.

2. [Habilita la API de Google Calendar](https://console.developers.google.com/apis/api/calendar-json.googleapis.com/)
   
    - Pulsa sobre el botón **Crear**.


3. En la pestaña [Pantalla de consentimiento de OAuth](https://console.developers.google.com/apis/credentials/consent/edit;newAppInternalUser=false), deberás:
   
    3.1. Dentro de la sección Pantalla de consentimiento de OAuth / OAuth consent screen:

      - Rellenar la Información de la aplicación

        - Especificar el nombre de la aplicación. Ejemplo: "*sinccal*".

        - Especificar el correo electrónico de asistencia de usuario. Ejemplo: *tuEmail@gmail.com*.

      - Rellenar la Información de contacto del desarrollador

        - Especificar el correo electrónico de asistencia de usuario. Ejemplo: *tuEmail@gmail.com*.
   
      - Pulsa el botón **Guardar y continuar**.
   

   3.2. Dentro de la sección Permisos:

      - Pulsa sobre Agregar permisos y busca aquel cuyo:

        - API: **Google Calendar API**

        - Alcance: **.../auth/calendar.events**
         
        - Descripción para el usuario: **Ver y editar eventos en tus calendarios**.
   
      - Una vez agregado el permiso, pulsa el botón **Guardar y continuar**.
   

   3.3. Dentro de la sección Usuarios de prueba / Test users:

      - Añade un usuario. Ejemplo: *tuEmail@gmail.com*.

      - Pulsa el botón **Guardar y continuar**.
   

4. [Crea un nuevo usuario](https://console.developers.google.com/apis/credentials/oauthclient) (accesible a través del enlace anterior o a través de la pestaña Credenciales -> Crear credenciales -> ID de cliente de OAuth):

    - Aplica la siguiente configuración:
   
      - Tipo de aplicación: **App de escritorio**.
      - (Opcional) Elige un nombre.
   
   - Pulsa el botón Guardar y continuar.


5. Una vez que tengas el usuario creado, descarga los **Secretos del cliente** en formato JSON dentro del repositorio, con el nombre "**credentials**".


6. Por último, **introduce tu DNI** y **tu contraseña** en el fichero *credenciales.txt*.

7. Añade los permisos de ejecución para el ejecutable:

```
chmod +x ./sincronizador.sh
```

8. Ejecuta el ejecutable:

```
./sincronizador.sh
```

## Renovación de credenciales
> [!WARNING]
> Las credenciales deberán renovarse cada dos semanas, aproximadamente.

Para renovar las credenciales, borra el fichero _token.json_ y vuelve a lanzar el ejecutable:

```
rm -f token.json
./sincronizador.sh
```

## Creación de una tarea cron
> [!NOTE]
> Puedes crear una tarea cron para que el ejecutable se ejecute periódicamente sin necesidad de estar ejecutando constantemente la aplicación. 

Para ello ejecuta:

1. Crear o Editar el archivo Crontab

```
crontab -e
```

2. Elige el editor de textos que más te guste, en mi caso, elegiré **nano**.

3. Queremos que se ejecute cada a las 10:30, cualquier día del mes, cualquier mes y los sábados.

```
30 10 * * 6 ruta/a/SincCal-UPV/sincronizador.sh
```

- Por ejemplo, si lo tienes dentro de la carpeta personal de usuario:

```
30 10 * * 6 ~/SincCal-UPV/sincronizador.sh
```

(Opcional) Si quieres eliminar la salida del programa, simplemente añade `> /dev/null 2>&1` al final del comando. Quedaría:

```
30 10 * * 6 ~/SincCal-UPV/sincronizador.sh > /dev/null 2>&1
```

## Modificaciones
> [!NOTE]
> Puedes modificar el nombre de las actividades y el color asociado a los eventos. En mi caso, me gusta usar los nombres para las actividades y un color Verde Musgo, que asocio al deporte. Puedes cambiar el color en la sección de Referencias.


## Referencias

1. [Colores Calendar](https://developers.google.com/apps-script/reference/calendar/event-color?hl=es-419)

2. [Github oficial de Gcalcli](https://github.com/insanum/gcalcli)

3. [Código de Python](https://developers.google.com/calendar/api/quickstart/python?hl=es-419)

4. [Vídeo usando la API de Google Calendar pero en el lenguaje de desarrollo Java](https://www.youtube.com/watch?v=zPsSUEGDfVY)

5. [Cómo hacer una tarea cron](https://phoenixnap.com/kb/set-up-cron-job-linux)
