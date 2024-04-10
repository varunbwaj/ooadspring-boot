import streamlit as st
import time
import traceback
import mysql.connector
import pandas as pd
import pathlib, sys
from streamlit_option_menu import option_menu

module_dir = pathlib.Path(__file__).parent.parent
sys.path.append(str(module_dir))

from backend import user_auth as ua

import tab1 as tb1, \
       tab2 as tb2, \
       tab3 as tb3, \
       tab4 as tb4, \
       tab5 as tb5, \
       tab6 as tb6, \
       tab7 as tb7

def homepage(boolean,username,authenticator):
    if boolean:
        progressbar = st.progress(0)
        for i in range(100):
            progressbar.progress(i+1)
            time.sleep(0.01)
        try:

            auth_icons, auth_options = ua.get_options(username)
            selected_tab = option_menu(
                menu_title="Main Menu",
                options=auth_options,
                icons=auth_icons,
                menu_icon="cast",
                orientation="horizontal",
                default_index=0,
                # styles={
                #     "container":{"background-color":"#2b2bed"},
                #     "nav-link-selected": {"background-color": "green"}
                # }
            )
            
            if selected_tab == "General":
                tb1.display()
            elif selected_tab == "Statistics":
                tb2.inp_disp()
            elif selected_tab=="Logs":
                tb3.disp()
            elif selected_tab=="Inventory":
                tb4.disp()
                # tb4.disp(cursor=cursor, conn=conn)
            elif selected_tab=="Maintenance":
                tb5.Maintenance()
            elif selected_tab=="GHS":
                tb6.GHS()
            elif selected_tab=="Settings":
                try:
                    tb7.disp()
                except mysql.connector.ProgrammingError as err:
                    st.error("Wrong query!")
            authenticator.logout("Logout","main")
        except Exception as e:
            print("Main File error:",e)
            traceback.print_exc()


if __name__=="__main__":
    st.set_page_config(layout="wide")
    try:        
        boolean, username, authenticator=ua.login_user()
        homepage(boolean,username,authenticator)
    except Exception as e:
        pass
        

