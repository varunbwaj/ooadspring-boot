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
        Subject=None;body=None;radios=None
        with st.form("my_form2", clear_on_submit=True):
            st.text_input('Message Subject',key='Subject')
            st.text_input("Message Body",key='body')
            radios = st.radio('Message Type',options=['Notification', 'Emergency'])
            st.form_submit_button('Submit',on_click=submitted)
            Subject=str(st.session_state.Subject)
            body=str(st.session_state.body)
        if Subject!=None and radios!=None and body!=None and Subject!="" and body!="" and radios!="":
            if 'submitted' in st.session_state and st.session_state.submitted==True:
                operate_str=f"INSERT INTO CommunicationLog (MessageType,\
                            MessageSubject, MessageBody, SentDate)\
                            VALUES ('{radios}', '{Subject}', '{body}', CURRENT_TIMESTAMP);"
                if push_message(radios,Subject,body) == 200:
                    st.success("New message added")
                reset()