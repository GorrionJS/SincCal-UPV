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

from emojiActividad import emojiActividad

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
            try:
                creds.refresh(Request())
            except Exception as e:
                sys.exit(2)

        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)

        # Save the credentials for the next run
        with open("token.json", "w") as token:
          token.write(creds.to_json())

    service = build('calendar', 'v3', credentials=creds)

    # Configuración del evento

    sys.argv[1] = emojiActividad(sys.argv[1])

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
      'reminders': {
        'useDefault': False,  # No usar recordatorios por defecto
        'overrides': [
            {
                'method': 'popup',  # Tipo de recordatorio (puede ser "email" o "popup")
                'minutes': 120  # 2 horas antes del evento
            }
        ]
    }
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
