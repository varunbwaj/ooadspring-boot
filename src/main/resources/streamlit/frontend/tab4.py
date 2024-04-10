import streamlit as st
import pandas as pd
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
    st.selectbox(label='Resource Name', options=resource_names_list, index=None, key='resource_name', on_change=selected, placeholder='Select a resource')

    if st.session_state.selected == True:
        with st.container():
            c1, c2 = st.columns([0.70, 0.30])
            with c1:
                def graph():
                    resource_data = get_resource_inventory(resource_dict[st.session_state.resource_name])
                    min1 = int(resource_data['MinimumQuantity'])
                    currval = int(resource_data['Quantity'])
                    max1 = int(resource_data['MaximumQuantity'])
                    st.bar_chart(pd.DataFrame({'Category': ['Minimum', 'Current', 'Maximum'], 'Value': [min1, currval, max1]}).set_index("Category"), height=400, color='#91c2f9')
                    return (min1, currval, max1)

                min1, currval, max1 = graph()

            with c2:
                resource_data = get_resource_inventory(resource_dict[st.session_state.resource_name])
                date = str(resource_data['NextScheduledMaintenance']).split("T")[0]
                time = str(resource_data['NextScheduledMaintenance']).split("T")[1].split(".")[0]
                st.write(""); st.write(""); st.write(""); st.write(""); st.write(""); st.write("")
                st.write(f"The next scheduled Maintenance is on :red[{date}] at {time}")

                date = str(resource_data['LastUpdated']).split("T")[0]
                time = str(resource_data['LastUpdated']).split("T")[1].split(".")[0]
                st.write("")
                st.write(f"The Last Scheduled Maintenance was on :green[{date}] at {time}")

        with st.container():
            with st.form("my_form1"):
                val = st.select_slider("Restock Quantity", options=[i for i in range(min1, max1-currval+1)])
                submitt = st.form_submit_button("Submit")
                if submitt:
                    code = restock_resource(val, resource_dict[st.session_state.resource_name])
                    if code == 200:
                        st.write("Successful")
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


def get_resource_inventory(resource_id):
    try:
        url = f"http://localhost:3000/inventory/resource/{resource_id}"
        response = requests.get(url)
        json_data = response.json()
        return json_data
    except Exception as e:
        print("Get Resource Data Error", e)
    return None



def restock_resource(value, id):
    try:
        url = f"http://localhost:3000/inventory/restock/{value}/{id}"
        response = requests.put(url)
        return int(response.status_code)
    except Exception as e:
        print("Couldn't update stock :/ \t:", e)