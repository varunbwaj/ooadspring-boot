import streamlit as st
import pandas as pd
import requests
# Reports and Energency - ATC
def Maintenance():
        st.text("")
        st.header("Aircraft Maintenance")
        st.text("")
        #     cursor.callproc("GetMaintenanceData")
        #     cursor.nextset()
        #     cols = [i[0] for i in cursor.description]
        #     rows = cursor.fetchall()
        response = requests.get(url="http://localhost:3000/maintenance")
        json_data = response.json()
        data = json_data
        cols = list(data[0].keys())
        rows = [list(row.values()) for row in data]
        st.dataframe(pd.DataFrame(rows,columns=cols,index=[i for i in range(1,len(rows)+1)]), use_container_width=True)