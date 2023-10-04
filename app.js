const express = require('express');
const mysql = require('mysql');
const path = require('path');
const app = express();
const port = process.env.PORT || 80;

// AWS RDS MySQL database configuration
const dbConfig = {
  host: 'database-1.cdf1dissbwe4.us-east-1.rds.amazonaws.com',
  user: 'admin',
  password: 'qwertyui',
  database: 'data',
};

// Create a MySQL database connection
const db = mysql.createConnection(dbConfig);

// Connect to the MySQL database
db.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err);
  } else {
    console.log('Connected to the database.');

    // Create the 'tasks' table if it doesn't exist
    db.query(
      'CREATE TABLE IF NOT EXISTS tasks (id INT AUTO_INCREMENT PRIMARY KEY, task TEXT)',
      (err) => {
        if (err) {
          console.error('Error creating table:', err);
        } else {
          console.log('Table created or already exists.');
        }
      }
    );
  }
});

app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

app.get('/tasks', (req, res) => {
  // Fetch tasks from the database
  db.query('SELECT * FROM tasks', (err, rows) => {
    if (err) {
      console.error('Error fetching tasks:', err);
      res.status(500).send('Internal Server Error');
      return;
    }
    res.json(rows);
  });
});

app.post('/tasks', (req, res) => {
  const { task } = req.body;
  if (!task) {
    res.status(400).send('Bad Request: Task is required.');
    return;
  }

  // Insert the new task into the database
  db.query('INSERT INTO tasks (task) VALUES (?)', [task], (err) => {
    if (err) {
      console.error('Error inserting task:', err);
      res.status(500).send('Internal Server Error');
      return;
    }
    res.status(201).send('Task added successfully');
  });
});

app.delete('/tasks/:id', (req, res) => {
  const taskId = req.params.id;

  // Delete the task from the database
  db.query('DELETE FROM tasks WHERE id = ?', [taskId], (err) => {
    if (err) {
      console.error('Error deleting task:', err);
      res.status(500).send('Internal Server Error');
      return;
    }
    res.status(204).send();
  });
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

