import mysql.connector
import streamlit_authenticator as stauth
import pathlib, sys, requests
module_dir = pathlib.Path(__file__).parent.parent
sys.path.append(str(module_dir))


import mysql.connector

def get_usr_info():
    try:
        url = "http://localhost:3000/auth"
        response = requests.get(url)

        data  = response.json()

        usernames = [entry.get('username', '') for entry in data]
        passwords = [entry.get('password', '') for entry in data]
        names = [entry.get('names', '') for entry in data]
    except Exception as e:
        print("Get Keys user info: ",e)
    finally:
        return (names, usernames, passwords)


def add_usr(uname,Pass,f_name,minit,l_name,auth_lvl):
    try:    

        dummy_list = []
        dummy_list.append(Pass)
        hash_pass = stauth.Hasher(dummy_list).generate()[0]
        data_dict = {
            'username': uname,      
            'hpass': hash_pass,
            'pass': Pass,
            'fname': f_name,
            'minit': minit,
            'lname': l_name,
            'authlvl': auth_lvl 
        }
        url = 'http://localhost:3000/auth/add_usr'
        response = requests.post(url,json=data_dict)
        print(response.status_code)
        print("new user added\n")
    except Exception as err:
        print(f"Error: {err}")

def get_level(username):
    try:
        url = "http://localhost:3000/auth/level/"+username
        response = requests.get(url)
        data_json = response.json()
        level = data_json[0]['auth_level']
        return level
    
    except Exception as err:
        print("Error", err)