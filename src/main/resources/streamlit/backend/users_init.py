import mysql.connector
import streamlit_authenticator as stauth
# Database connection parameters
from dbconfig import ret_db_config as db_config


try:
    # Establish a connection to the MySQL database
    connection = mysql.connector.connect(**db_config())

    # Create a cursor object to interact with the database
    cursor = connection.cursor()

    f_names, minits, l_names, usernames, Passes, auth_levels = [],[],[],[],[],[]

    operate_str = 'SELECT f_name, minit, l_name, username, hashed_pass as Pass, auth_level FROM airport.usr_info1;'
    cursor.execute(operate_str)

    user_data = cursor.fetchall()
    for f_name, minit, l_name, username, Pass, auth_level in user_data:
        f_names.append(f_name)
        minits.append(minit)
        l_names.append(l_name)
        usernames.append(username)
        Passes.append(Pass)
        auth_levels.append(auth_level)

    hashed_passes = stauth.Hasher(Passes).generate()

    # print(usernames,"\n",Passes,"\n",hashed_passes,"\n")

    for i in range(len(usernames)):
        operate_str1 = 'INSERT INTO usr_info (f_name,minit,l_name,username,hashed_pass,auth_level) VALUES (%s,%s,%s,%s,%s,%s)'
        data = (f_names[i],minits[i],l_names[i],usernames[i],hashed_passes[i],auth_levels[i])
        cursor.execute(operate_str1,data)
        cursor.fetchall()

except mysql.connector.Error as err:
    print(f"Error: {err}")
finally:
    if connection:
        # Close the cursor and the database connection
        connection.commit()
        cursor.close()
        connection.close()