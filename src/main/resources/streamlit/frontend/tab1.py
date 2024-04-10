import streamlit as st
import pandas as pd
import requests
def display():
    st.text("")
    st.header("General Airport Information")
    st.text("")
    x1,x2 = st.columns([0.25,0.75])
    with x1:
        with st.container():
            st.dataframe(get_names(), use_container_width=True)
    with x2:
        with st.container():
            st.header("Number of Airplanes in each Airline")
            # # st.bar_chart(graph,color='#768b69')
            st.bar_chart(get_graph(),color='#91c2f9')
            

def get_names():
    try:
        url = "http://localhost:3000/general/airnames"
        response = requests.get(url)
        json_data = response.json()
        result_dict = {item['AirlineName'] for item in json_data}
        df = pd.DataFrame(result_dict,columns = ["Airline Name"])
        df.index +=1
        return df
    except Exception as e:
        print("Execption on get_names",e)

def get_graph():
    try:
        url = "http://localhost:3000/general/graph"
        response = requests.get(url)
        json_data = response.json()
        df = pd.DataFrame(json_data)
        df.set_index('AirlineName',inplace=True)
        return df
    except Exception as e:
        print("Exception on get_graph",e)