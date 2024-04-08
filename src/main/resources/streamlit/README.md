# Setup Instructions

Follow these steps to set up and run the project:


## 1. Install the packages via:

```bash
$ pip install -r requirements.txt
```

This command will install the required Python packages listed in the `requirements.txt` file.

## 2. Start MySQL Command Line:

```bash
$ mysql -u your_username -p
```

After entering the MySQL command line, run the following SQL script:

```sql
SOURCE path/to/air_db.sql;
```

Replace `your_username` with your MySQL username and provide the correct path to the `air_db.sql` file.

## 3. In the `backend` folder, run:

```bash
$ streamlit run users_init.py
```

This command will initialize the database using Streamlit.

## 4. In the `javascript` folder, type:

```bash
$ npm install
```

This command will install the required Node.js packages.

## 5. Then run:

```bash
$ npm start
```

This command will start the JavaScript application.

## 6. In another terminal at the `frontend` folder, run:

```bash
$ streamlit run main.py
```

This command will start the frontend server using Streamlit.

Make sure to follow these instructions in the specified order to ensure the proper setup and execution of the project.


### p.s. admin login details: 

### username: admin 

### password: abc