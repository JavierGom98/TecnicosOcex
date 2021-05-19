import 'package:mysql1/mysql1.dart';

var settings = new ConnectionSettings(
  host: '51.161.73.194', 
  port: 5500,
  user: 'root',
  password: '*X8675309z*',
  db: 'mbox_ocex_CM'
);

getOrdenesBD() async {
  print('Coneccion BD');
  //var conn = await MySqlConnection.connect(settings);
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '51.161.73.194',
      port: 5500,
      user: 'root',
      password: '*X867530*',
      db: 'mbox_ocex_CM'));
  var results = await conn.query('SELECT * FROM orden');
  for (var row in results) {
    print('Name: ${row[0]}, email: ${row[1]}');
  }
  /*var result = await conn.query('insert into users (name, email, age) values (?, ?, ?)', ['Bob', 'bob@bob.com', 25]);
  print("New user's id: ${result.insertId}");
  var results = await query.queryMulti(
    'insert into users (name, email, age) values (?, ?, ?)',
    [['Bob', 'bob@bob.com', 25],
    ['Bill', 'bill@bill.com', 26],
    ['Joe', 'joe@joe.com', 37]]);
  await conn.query(
    'update users set age=? where name=?',
    [26, 'Bob']);*/
  await conn.close();
}