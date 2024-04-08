import streamlit as st
import pandas as pd
import mysql.connector
import numpy as np
import time
import requests

def disp():
    st.text("")
    st.header("Resource Inventory")
    st.text("")
    def submitted():
        st.session_state.submitted = True
    def reset():
        st.session_state.submitted = False
    def selected():
        st.session_state.selected = True
    resource_dict = get_resource_dict()
    resource_names_list = list(resource_dict.keys())
    st.selectbox(label='Resource Name',options = resource_names_list,index=None,key='resource_name',on_change=selected,placeholder='Select a resource')
    if st.session_state.selected == True:
        with st.container():
            c1,c2 = st.columns([0.70,0.30])
            with c1:
                def graph():
                    operate_str = '''SELECT  `MinimumQuantity`, `Quantity`,`MaximumQuantity` FROM `ResourceInventory`
                                    WHERE `ResourceID` = %s;'''
                    graph = get_df(resource_dict[st.session_state.resource_name],operate_str)
                    columns = graph.columns.to_list()
                    rows = graph.values.tolist()[0]
                    data = {
                        'Category' : columns,
                        'Value' : rows
                    }
                    min1 = int(graph['MinimumQuantity'].values[0])
                    currval = int(graph['Quantity'].values[0])
                    max1 = int(graph['MaximumQuantity'].values[0])
                    st.bar_chart(pd.DataFrame(data).set_index("Category"), height=400, color='#91c2f9')
                    return (min1,currval,max1)
                min1,currval,max1 = graph()
            with c2:
                operate_str = '''SELECT NextScheduledMaintenance FROM 
                                ResourceInventory WHERE `ResourceID`=%s;'''
                graph = get_df(resource_dict[st.session_state.resource_name],operate_str)
                date = str(graph.NextScheduledMaintenance.values[0]).split("T")[0]
                time = str(graph.NextScheduledMaintenance.values[0]).split("T")[1].split(".")[0]
                st.write("");st.write("");st.write("");st.write("");st.write("");st.write("")
                st.write(f"The next scheduled Maintenance is on :red[{date}] at {time}")

                operate_str = '''SELECT LastUpdated FROM 
                                ResourceInventory WHERE `ResourceID`=%s;'''            
                graph = get_df(resource_dict[st.session_state.resource_name],operate_str)
                date = str(graph.LastUpdated.values[0]).split("T")[0]
                time = str(graph.LastUpdated.values[0]).split("T")[1].split(".")[0]; st.write("")
                st.write(f"The Last Scheduled Maintenance was on :green[{date}] at {time}")
        with st.container():
            with st.form("my_form1"):
                val = st.select_slider("Restock Quantity",options=[i for i in range(min1, max1-currval+1)])
                submitt = st.form_submit_button("Submit")
                if submitt:
                    # graph["Quantity"] = int(graph['Quantity'].values[0])+int(val)
                    st.write("Selected Value is : ",val)
                    # data = (currval+val,resource_dict[st.session_state.resource_name])
                    code = update_stock(currval+val,resource_dict[st.session_state.resource_name] )
                    if code ==200:
                        st.write("Successfull")
                        st.success(":green[Restocked!]")
                    reset()


def get_resource_dict():
    try:
        url = 'http://localhost:3000/inventory/resource'
        response = requests.get(url)
        json_data = response.json()
        result_dict = {item['ResourceName']: item['ResourceID'] for item in json_data}
        return result_dict
    except Exception as err:
        print(f"Error: {err}")

def get_df(char, operate_str):
    try:
        url = "http://localhost:3000/inventory/"+operate_str+"/"+str(char)
        response = requests.get(url)
        json_data = response.json()

        sample_df = pd.DataFrame(json_data)

        return sample_df
    except Exception as e:
        print("Get Dataframe Error",e)
    return None

def update_stock(value, id):
    try:
        # print(data)
        # print(type(data))
        url = "http://localhost:3000/inventory/restock/"+str(value)+"/"+str(id)
        # print(url)
        response = requests.put(url)
        return int(response.status_code)
    except Exception as e:
        print("Couldn't update stock :/ \t:",e)