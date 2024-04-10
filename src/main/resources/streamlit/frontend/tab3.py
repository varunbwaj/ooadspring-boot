import streamlit as st
import mysql.connector
import pathlib, sys, requests
module_dir = pathlib.Path(__file__).parent.parent
sys.path.append(str(module_dir))
from backend.dbconfig import ret_db_config as db_config
import pandas as pd
import main as mp

def get_incidents(operate_str):
    url = 'http://localhost:3000/logs/messages/'+operate_str
    response   = requests.get(url)
    json_data = response.json()
    description_values = [item['IncidentDescription'] for item in json_data]
    return description_values


def get_emergency(operate_str):
    url = 'http://localhost:3000/logs/emergency/'+operate_str
    response = requests.get(url)
    data_json = response.json()
    result_tuple = [(item['MessageSubject'], item['MessageBody']) for item in data_json]
    return result_tuple

def push_message(radios,Subject,body):
    try:
        url = 'http://localhost:3000/logs/push/'+str(radios)+'/'+Subject+'/'+body
        response = requests.post(url)
        return response.status_code
    except Exception as e:
        print("Couldn't push message :/ \t",e)


def submitted():
    st.session_state.submitted = True
def reset():
    st.session_state.submitted = False

def disp():
    st.text("")
    st.header("Communication and Announcements")
    st.text("")
    c1,c2,c3 = st.columns(3)
    with st.container():
        with c1:
            st.header(":blue[Recent Incidents]")
            operate_str = '''SELECT `IncidentDescription` FROM `IncidentReport` \
                            ORDER BY `IncidentDate` DESC LIMIT 3;'''
            for row in get_incidents(operate_str):
                st.markdown(f'''
                    - {row}
                ''')
        with c2:
            st.header(":red[Emergency]")
            operate_str = """SELECT `MessageSubject`, 
                            `MessageBody` FROM `CommunicationLog` WHERE `MessageType` 
                            LIKE ('%Emergency%') ORDER BY `SentDate` DESC LIMIT 5;"""
            rows = get_emergency(operate_str)
            for row in rows:
                st.markdown(f'''
                    - {row[1]}
                ''')
        with c3:
            st.header(":green[Notification]")
            operate_str = """SELECT `MessageSubject`, 
                            `MessageBody` FROM `CommunicationLog` WHERE `MessageType` 
                            LIKE ('%Notification%') ORDER BY `SentDate` DESC LIMIT 5;"""
            for row in get_emergency(operate_str):
                st.markdown(f'''
                    - {row[1]}
                ''')
    with st.container():
        st.write("");st.header("Push a New Message?")
        subject = st.text_input('Message Subject', key='subject')
        body = st.text_input("Message Body", key='body')
        radios = st.radio('Message Type', options=['Notification', 'Emergency'])
        if st.button('Submit'):
            if push_message(radios, subject, body)==200:
                st.success("Successfully Added")
            else:
                st.error("Please fill all fields")
            reset()  