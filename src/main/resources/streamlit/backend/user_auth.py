import streamlit as st
import time
import streamlit_authenticator as stauth
import pathlib, sys
module_dir = pathlib.Path(__file__).parent.parent
sys.path.append(str(module_dir))
from backend import get_keys as gk

def login_user():
    try:
        # Attempt to retrieve user information, handle any errors
        names, usernames, hashed_passwords = gk.get_usr_info()
    except Exception as e:
        st.error("Server down")
        return (0, None)

    credentials = {"usernames": {}}

    for uname, name, pwd in zip(usernames, names, hashed_passwords):
        user_dict = {"name": name, "password": pwd}
        credentials["usernames"].update({uname: user_dict})

    authenticator = stauth.Authenticate(credentials, "cookkkie", "random_key", cookie_expiry_days=1)

    st.title("Airport Staff Management")

    name, authentications_status, username = authenticator.login("Login", "main")

    if authentications_status is False:
        error = st.error("Username/password is incorrect")
        time.sleep(2)
        error.empty()
        return (0, username,authenticator)

    if authentications_status is None:
        warn = st.warning("Please enter Username and password")
        time.sleep(2)
        warn.empty()

    if authentications_status:
        # authenticator.logout("Logout", "main")
        return (1, username,authenticator)
    
def get_options(username):
    auth_lvl = gk.get_level(username)
    acc_auth_options=["General","Statistics","Logs","Inventory","Maintenance","GHS","Settings"]
    acc_auth_icons=['1-circle-fill','2-circle-fill','3-circle-fill','4-circle-fill','5-circle-fill','6-circle-fill','7-circle-fill']
    if auth_lvl == "2":
        auth_icons = acc_auth_icons[:4]
        auth_options = acc_auth_options[:4]
    elif auth_lvl =="1":
        auth_icons = acc_auth_icons[:6]
        auth_options = acc_auth_options[:6]
    else:
        auth_icons = acc_auth_icons
        auth_options = acc_auth_options
    return (auth_icons,auth_options)
