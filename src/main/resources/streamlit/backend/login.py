import streamlit as st

details=[("admin","admin123"),("test","test123")]
def login_user():
    def is_user_authenticated():
        return st.session_state.get("authenticated", False)
    st.sidebar.title("Login")
    username = st.sidebar.text_input("Username")
    password = st.sidebar.text_input("Password", type="password")
    if st.sidebar.button("Login"):
        if (username,password) in details:
            st.sidebar.success("Login Successful")
            st.session_state.authenticated = True
        else:
            st.session_state.authenticated = False
            st.sidebar.error("Invalid credentials. Please try again.")

    if is_user_authenticated():
        return True
    else:
        return False
