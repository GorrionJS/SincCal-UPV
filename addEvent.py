####################################################################################
## FUENTE: https://developers.google.com/calendar/api/quickstart/python?hl=es-419 ##
####################################################################################

from __future__ import print_function
import datetime
import os.path
import pickle
import sys

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

# If modifying these SCOPES, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/calendar.events']


## COMPROBAMOS QUE EL EVENTO NO HAYA AÑADIDO ANTES
def check_duplicate_event(service, event_details):

    events_result = service.events().list(calendarId='primary', q=event_details['summary']).execute()
    events = events_result.get('items', [])

    for event in events:
        start = event['start'].get('dateTime', event['start'].get('date'))
        end = event['end'].get('dateTime', event['end'].get('date'))

        if start == event_details['start']['dateTime'] and end == event_details['end']['dateTime']:
            return True
    return False


def emojiActividad():
  if (sys.argv[1] == "󰿗 Musculación"): 
    sys.argv[1] = "💪🏻 Musculación"
  elif (sys.argv[1] == "󱗻 Bachata"):
    sys.argv[1] = "💃🏻 Bachata"
  elif (sys.argv[1] == "󱗻 Bailes Latinos"):
    sys.argv[1] = "💃🏻 Bailes Latinos"
  elif sys.argv[1] == "Acondicionamiento":
      sys.argv[1] = "Acondicionamiento"
  elif sys.argv[1] == "Aerobox":
      sys.argv[1] = "Aerobox"
  elif sys.argv[1] == " Bars Training":
      sys.argv[1] = "🥖 Bars Training"
  elif sys.argv[1] == "Body Weight Training":
      sys.argv[1] = "Body Weight Training"
  elif sys.argv[1] == "Commercial Dance":
      sys.argv[1] = "💃🏻 Commercial Dance"
  elif sys.argv[1] == "󰁬 Espalda Sana":
      sys.argv[1] = "🧘🏻 Espalda Sana"
  elif sys.argv[1] == "󰿗 Fitness":
      sys.argv[1] = "🏃🏻 Fitness"
  elif sys.argv[1] == "󰿗 GAP":
      sys.argv[1] = "🏋🏻 GAP"
  elif sys.argv[1] == "Hip Hop":
      sys.argv[1] = "🪩 Hip Hop"
  elif sys.argv[1] == "󰿗 Pilates Sport":
      sys.argv[1] = "💦 Pilates Sport"
  elif sys.argv[1] == "Sexy Style":
      sys.argv[1] = "👯‍♀️ Sexy Style"
  elif sys.argv[1] == "Step":
      sys.argv[1] = "Step"
  elif sys.argv[1] == "Tonificación":
      sys.argv[1] = "💦 Tonificación"
  elif sys.argv[1] == "Yoga":
      sys.argv[1] = "🧘🏻 Yoga"
  elif sys.argv[1] == "Zumba":
      sys.argv[1] = "💦 Zumba"
  # Solo clases libres
  elif sys.argv[1] == "󰠬 Chikung Adaptado":
    sys.argv[1] = "🤸🏻 Chikung Adaptado"
  elif sys.argv[1] == "󰿗 Sala Cardio":
    sys.argv[1] = "🏃🏻 Sala Cardio"
  elif sys.argv[1] == "󱄟 Spinning":
    sys.argv[1] = "🚴🏻 Spinning"
  elif sys.argv[1] == "󰠬 Taichi":
    sys.argv[1] = "🤸🏻 Taichi"
  elif sys.argv[1] == "Yogafit":
    sys.argv[1] = "🧘🏻 Yogafit"
  else:
    print("Nombre no reconocido")



def main():

    """Shows basic usage of the Google Calendar API.
    Adds an event to the calendar.
    """
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)

    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
      
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())

        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)

        # Save the credentials for the next run
        with open("token.json", "w") as token:
          token.write(creds.to_json())

    service = build('calendar', 'v3', credentials=creds)

    # Configuración del evento

    emojiActividad()

    event = {
      'summary': sys.argv[1], # Título
      'start': {
        'dateTime': sys.argv[2], # Hora de inicio
        'timeZone': 'Europe/Madrid',
      },
      'end': {
        'dateTime': sys.argv[3], # Hora de finalización
        'timeZone': 'Europe/Madrid',
      },
      'colorId': '10',  # Color Verde Musgo
    }

    # Verifica si el evento ya existe antes de añadirlo
    if check_duplicate_event(service, event):
      sys.exit(0)

    event = service.events().insert(calendarId='primary', body=event).execute()
    sys.exit(1)

    # SI TE INTERESA CONSULTAR EL ENLACE EN EL QUE VER EL EVENTO, DESCOMENTA LA LÍNEA SIGUIENTE
    # print('Event created: %s' % (event.get('htmlLink')))

if __name__ == '__main__':
    main()
