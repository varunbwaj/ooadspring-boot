import streamlit as st
import mysql.connector
import main as mp
import pandas as pd
import requests

def inp_disp():
    st.text("")
    st.header("Airline Stastictics")
    st.text("")
    def submitted():
        st.session_state.submitted = True
    def reset():
        st.session_state.submitted = False
    air_names_dict = get_names_dict()
    air_name_list = list(air_names_dict.keys())
    st.selectbox(label='Airline name',options=air_name_list,index=None,key='air_name',on_change=submitted, placeholder="Select Any Airline")
    if 'submitted' in st.session_state and st.session_state.submitted == True:    
        with st.container():
            c1,c2 = st.columns([0.40,0.60])
            with c1:
                operate_str = '''SELECT  a0.`AirplaneRegistration`, a0.`AirplaneType`
                        FROM `Airplanes` as a0
                        JOIN `Airlines` as a1
                        ON a0.`AirlineID`=a1.`AirlineID`
                        WHERE a0.`AirlineID` = %s;'''
                st.markdown(f'<p class="big-font">Different Airplanes in this Airline</p>', unsafe_allow_html=True)
                st.dataframe(get_df(air_names_dict[st.session_state.air_name],operate_str), use_container_width=True)
                reset()
            with c2:
                st.write("");st.write("");st.write("")
                st.markdown("""
                            <style>
                            .big-font {
                                font-size:25px !important;
                                font:"Sans serif";
                            }
                            </style>
                            """, unsafe_allow_html=True)
                st.markdown("""
                            <style>
                            .fontcolor {
                                font-size: 22px !important;
                                font-family: "Sans-serif";
                                color: #0C74EB;
                            }
                            </style>
                            """, unsafe_allow_html=True)
                operate_str='''
                    SELECT GetNumberOfPassengersForAirline(%s);
                '''
                

                NumberOfPassengers=get_number(operate_str,air_names_dict[st.session_state.air_name])
                operate_str1=""" SELECT GetRoundedAverageAirplaneCount(%s);"""
                avgPlanes = get_number(operate_str1,air_names_dict[st.session_state.air_name])
                # print(avgPlanes)
                operate_str2='''
                    SELECT GetNumberOfEmployeesForAirline(%s);
                '''
                NumberOfEmployees=get_number(operate_str2,air_names_dict[st.session_state.air_name])
                # print(NumberOfEmployees)
                st.markdown(f'<p class="big-font"> - Total Number of Passengers travelled in this Airline : \
                            <span class="fontcolor">&emsp;&emsp;{NumberOfPassengers}</span></p>', unsafe_allow_html=True)
                st.markdown(f'<p class="big-font"> - Average Number of AirPlanes in this Airline : \
                            <span class="fontcolor">&emsp;&emsp;{avgPlanes}</span></p>', unsafe_allow_html=True)
                st.markdown(f'<p class="big-font"> - Total Number of Employees working in this Airline : \
                            <span class="fontcolor">&emsp;&emsp;{NumberOfEmployees}</span></p>', unsafe_allow_html=True)
        with st.container():
            st.header("Airplane Count over the months")
            operate_str="""SELECT mac.`AirplaneCount`,mac.`Month`
                        FROM MonthlyAirplaneCount as mac
                        JOIN Airlines as a0 ON mac.AirlineID = a0.AirlineID
                        WHERE mac.AirlineID = %s
                        ORDER BY (mac.Month);"""
            st.area_chart(get_df(air_names_dict[st.session_state.air_name],operate_str).set_index("Month"), color='#91c2f9')
            reset()

        

def get_names_dict():
    try:
        url = 'http://localhost:3000/stats/airnames'
        response = requests.get(url)
        json_data = response.json()
        result_dict = {item['AirlineName']: item['AirlineID'] for item in json_data}
        return result_dict
    except Exception as err:
        print(f"Error: {err}")

def get_number(operate_str, chars):
    try:
        url = 'http://localhost:3000/stats/getCount/'+operate_str+"/"+str(chars)
        response = requests.get(url)
        data =response.json()
        number = list(data[0].values())[0]
        return number
    except Exception as e:
        print("Exception: ",e)

def get_df(char, operate_str):
    try:
        # print(type(char))
        # print(char)
        url = "http://localhost:3000/inventory/"+operate_str+"/"+str(char)
        response = requests.get(url)
        json_data = response.json()
        sample_df = pd.DataFrame(json_data)
        sample_df.index = sample_df.index+1
        return sample_df
    except Exception as e:
        print("Get Dataframe Error",e)
    return None