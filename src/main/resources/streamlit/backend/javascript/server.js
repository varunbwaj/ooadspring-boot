const express = require('express');
const cors = require('cors');
// const mysql = require('mysql');
const mysql2 = require('mysql2');
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

app.use(express.json());

app.use(cors({
  origin: 'http://localhost:8501',
  methods: ["POST", "GET", "DELETE", "PUT"],
  credentials: true
}));

// Configure MySQL connection
const sql = mysql2.createConnection({
  host:'localhost',
  user: 'ooadproj',
  password: 'ooadproj',
  database: 'airport',
  charset: 'utf8mb4' // Handle special characters and emojis
});

// API endpoint to retrieve airport data
app.get('/airports', async (req, res) => {
    sql.query('SELECT * FROM usr_info1', (error, results) => {
    if (error) {
      console.error(error);
      res.status(500).send('Error retrieving data');
    } else {
      res.json(results);
    }
  });
});

app.get('/ghs/hangar', async (req, res) => {
    sql.query('CALL GetMaintenanceData1;', (error, results) => {
    if (error) {
      console.error(error);
      res.status(500).send('Error retrieving data');
    } else {
      res.json(results);
    }
  });
});

app.get('/ghs/services', async (req, res) => {
  sql.query('CALL GetGroundHandlingServiceData;', (error, results) => {
  if (error) {
    console.error(error);
    res.status(500).send('Error retrieving data');
  } else {
    res.json(results);
  }
});
});

app.get('/maintenance', async (req, res) => {
  sql.query('CALL getMaintenanceData;', (error, results) => {
  if (error) {
    console.error(error);
    res.status(500).send('Error retrieving data');
  } else {

    res.json(results);
  }
});
});

app.get('/inventory/:query/:chars', async (req, res) => {
    const sqlQuery = req.params.query;
    const chars = req.params.chars;

  const finalQuery = sqlQuery.replace('%s',chars)

    sql.query(finalQuery, (error,results)=> {
      if (error){
        console.error(error);
        res.status(500).send('Error retrieving data')
      }
      else {
        res.json(results);
      }
    })
});

app.get('/inventory/resource', async (req,res) =>{
    const sqlQuery = 'SELECT `ResourceID`, `ResourceName` FROM ResourceInventory;';
    sql.query(sqlQuery, (error, results) => {
      if (error){
        console.error(error);
        res.status(500).send('Error retrieving data')
      }
      else{
        res.json(results)
      }
    })
});

app.get('/stats/airnames', async (req,res) =>{
  const sqlQuery = 'SELECT AirlineID,AirlineName FROM Airlines';
  sql.query(sqlQuery, (error, results) => {
    if (error){
      console.error(error);
      res.status(500).send('Error retrieving data')
    }
    else{
      res.json(results)
    }
  })
});

app.get('/general/airnames', async (req,res) =>{
  const sqlQuery = 'select AirlineName from airlines;';
  sql.query(sqlQuery, (error, results) => {
    if (error){
      console.error(error);
      res.status(500).send('Error retrieving data')
    }
    else{
      res.json(results)
    }
  })
});


app.get('/general/graph', async (req,res) =>{
  const sqlQuery = "select * from unique_airplanes;"

  sql.query(sqlQuery, (error,results)=>{
    if (error){
      console.error(error);
      res.status(500).send('Error retrieving data')
    }
    else{
      res.json(results)
    }
  });

})


app.get('/stats/getCount/:query/:chars', async(req,res)=> {
    const sqlQuery = req.params.query;
    const chars = req.params.chars;
    const finalQuery = sqlQuery.replace("%s",chars)

    sql.query(finalQuery, (error, results) => {
      if (error){
        console.error(error);
      res.status(500).send('Error retrieving data')
    }
    else{
      res.json(results)
    }
    });
});


app.get('/logs/messages/:query', async (req,res) =>{
 const sqlQuery = req.params.query;
  // console.log(sqlQuery);
  sql.query(sqlQuery, (error,results)=>{
    if (error){
      console.error(error);
      res.status(500).send('Error retrieving data')
    }
    else{
      res.json(results)
    }
  });
});

app.get('/logs/emergency/:query', async (req,res) =>{
  const sqlQuery = req.params.query;
  // console.log(sqlQuery);
   sql.query(sqlQuery, (error,results)=>{
     if (error){
       console.error(error);
       res.status(500).send('Error retrieving data')
     }
     else{
       res.json(results)
     }
   });
 });

 app.get('/logs/notifs/:query', async (req,res) =>{
  const sqlQuery = req.params.query;
  // console.log(sqlQuery);
   sql.query(sqlQuery, (error,results)=>{
     if (error){
       console.error(error);
       res.status(500).send('Error retrieving data')
     }
     else{
       res.json(results)
     }
   });
 });

 app.get('/settings/:query', async (req,res) =>{
  const sqlQuery = req.params.query;
  // console.log(sqlQuery);
   sql.query(sqlQuery, (error,results)=>{
     if (error){
       console.error(error);
       res.status(500).send('Error retrieving data')
     }
     else{
       res.json(results)
     }
   });
 });

 app.put('/inventory/restock/:value/:id', (req, res) => {
  const value = req.params.value;
  const id = req.params.id;
  const sqlQuery = `
    UPDATE ResourceInventory
    SET Quantity = %s
    WHERE ResourceID = ?;
  `;
  const finalQuery = sqlQuery.replace("%s",value).replace("?",id)

  sql.query(finalQuery, (err, result) => {
    if (err) {
      console.error('Error updating record:', err);
      res.status(500).json({ error: 'Error updating record' });
    } else {
      // console.log('Record updated successfully');
      res.status(200).json({ success: true });
    }
  });
});

app.post('/logs/push/:radios/:subject/:body', (req, res) => {
  const radios = req.params.radios;
  const subject = req.params.subject;
  const body = req.params.body;
  var sqlQuery = "INSERT INTO CommunicationLog (MessageType,\
    MessageSubject, MessageBody, SentDate)\
    VALUES ('%x', '%y', '%z', CURRENT_TIMESTAMP);"
  sqlQuery = sqlQuery.replace("%x",radios).replace("%y",subject).replace("%z",body);
  sql.query(sqlQuery, (err, result) => {
    if (err) {
      console.error('Error adding record:', err);
      res.status(500).json({ error: 'Error updating record' });
    } else {
      // console.log('Record updated successfully');
      res.status(200).json({ success: true });
    }
  });
});

app.get('/auth', async (req,res) =>{
    const sqlQuery = 'SELECT username, hashed_pass as password, CONCAT(f_name, " ", l_name) as names FROM usr_info;'; 

    sql.query(sqlQuery, (error,results)=>{
     if (error){
       console.error(error);
       res.status(500).send('Error retrieving data')
     }
     else{
       res.json(results)
     }
   });
 });


 app.get('/auth/level/:username', async (req,res) =>{
  var sqlQuery = "SELECT auth_level FROM usr_info WHERE username='%s'";
  const username = req.params.username;
  sqlQuery = sqlQuery.replace("%s",username);
  // console.log(sqlQuery)
  sql.query(sqlQuery, (error,results)=>{
   if (error){
     console.error(error);
     res.status(500).send('Error retrieving data')
   }
   else{
     res.json(results)
   }
  });
 });

app.post('/auth/add_usr', async (req,res) => {
  if (!req.body) {
    console.log('body not present')
    return res.status(400).json({ error: 'Invalid request body' });
  }
  const values = [
      req.body.fname,
      req.body.minit,
      req.body.lname,
      req.body.username,
      req.body.hpass,
      req.body.authlvl,
      ]
const values1 = [
      req.body.fname,
      req.body.minit,
      req.body.lname,
      req.body.username,
      req.body.pass,
      req.body.authlvl
  ]
  var sqlQuery = 'INSERT INTO usr_info (f_name,minit,l_name,username,hashed_pass,auth_level) VALUES (?,?,?,?,?,?)';

  var sqlQuery1 = 'INSERT INTO usr_info1 (f_name,minit,l_name,username,hashed_pass,auth_level) VALUES (?,?,?,?,?,?)';

  sql.query('START TRANSACTION', async (startTransactionErr, startTransactionRes) => {
    if (startTransactionErr) {
      console.error('Transaction start error', startTransactionErr);
      res.status(500).json({ success: false, error: 'Transaction start error' });
      return;
    }
  
    console.log('Transaction started successfully');
  
    sql.query(sqlQuery, values, async (inserr1, insres1) => {
      if (inserr1) {
        console.error('Insertion Error', inserr1);
        await sql.query('ROLLBACK');
        res.status(500).json({ success: false, error: 'Insertion Error' });
        return;
      }
  
      sql.query(sqlQuery1, values1, async (inserr2, insres2) => {
        if (inserr2) {
          console.error('Second Insertion Error', inserr2);
          await sql.query('ROLLBACK');
          res.status(500).json({ success: false, error: 'Second Insertion Error' });
          return;
        }
  
        sql.query('COMMIT', (commitErr, commitRes) => {
          if (commitErr) {
            console.error('Commit Error', commitErr);
            res.status(500).json({ success: false, error: 'Commit Error' });
            return;
          }
  
          console.log('Transaction committed successfully');
          res.status(200).json({ success: true });
        });
      });
    });
  });
});

// Start the server
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});