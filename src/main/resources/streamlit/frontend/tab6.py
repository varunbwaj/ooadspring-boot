import streamlit as st
import pandas as pd
import requests

def GHS():
    st.write("")
    with st.container():
        st.header("Hangar bay")
        url = 'http://localhost:3000/ghs/hangar'
        response = requests.get(url)
        json_data = response.json()
        # print(json_data)
        cols = list(json_data[0].keys())
        rows = [list(row.values()) for row in json_data]
        df = pd.DataFrame(rows, columns=cols, index=[i for i in range(1, len(rows) + 1)])
        st.dataframe(df,use_container_width=True)
        # st.write("Flagged for debugging")
    with st.container():
        st.header("Ground Handling Service Requests")
        url = 'http://localhost:3000/ghs/services'
        response = requests.get(url)
        json_data  = response.json()
        # print(json_data)
        cols = json_data[0].keys()
        rows = [list(row.values()) for row in json_data]
#         data = json_data[0]
#         cols = list(data[0].keys())
#         rows = [list(row.values()) for row in data]
#          Convert the result to a Pandas DataFrame
#         print(cols)
        st.dataframe(pd.DataFrame(rows, columns=cols,index=[i for i in range(1,len(rows)+1)]), use_container_width=True)
        # st.write("Flagged for debugging")