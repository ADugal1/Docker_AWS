'use strict';

const mysql = require('mysql');
const express = require('express');
const exphbs  = require('express-handlebars');
const helmet = require('helmet'); // see https://expressjs.com/en/advanced/best-practice-security.html
const config = require('config');

const pool  = mysql.createPool({
  connectionLimit: 8,
  host: config.get('database.host'),
  user: config.get('database.user'),
  password: config.get('database.password'),
  database: config.get('database.name')
});

const app = express();
app.use(helmet());
app.engine('handlebars', exphbs());
app.set('view engine', 'handlebars');
app.use('/css', express.static('css'));
app.use('/img', express.static('img'));

app.get('/', (req, res, next) => {
  pool.getConnection((err, connection) => {
    if (err) {
      next(err);
    } else {
      connection.query('CREATE TABLE IF NOT EXISTS site_hits (id INTEGER AUTO_INCREMENT PRIMARY KEY, date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)', (err) => {
        if (err) {
          connection.release();
          next(err);
        } else {
          connection.query('INSERT INTO site_hits () VALUES()', (err) => {
            if (err) {
              connection.release();
              next(err);
            } else {
              connection.query('SELECT COUNT(*) AS hits FROM site_hits', (err, rows, fields) => {
                connection.release();
                if (err) {
                  next(err);
                } else {
                  res.render('index', {hits: rows[0].hits});
                }
              });
            }
          });
        }
      });
    }
  });
});
app.get('/health-check', (req, res, next) => {
  res.sendStatus(200);
});

app.listen(8080, '0.0.0.0');
