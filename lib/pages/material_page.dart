import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tecnicos_cm/main.dart';

List materialesOrdenes;

class MaterialesPage extends StatefulWidget {
  MaterialesPage({this.codigoTecnico});
  final int codigoTecnico;
  @override
  _MaterialesPageState createState() => _MaterialesPageState();
}

class _MaterialesPageState extends State<MaterialesPage> {
  Map data;
  List materiales;

  getMateriales() async{
    String id = codigoTecnico.toString();
    String enlace = "http://ns212.cablebox.co:5510/appmovil/getMateriales.php/?codigoTecnico="+id;
    http.Response response = await http.get(enlace);
    var data = json.decode(response.body);
    //print(data);
    setState(() {
      materiales = data['materiales'];
    });
  }

  @override
  void initState() {
    getMateriales();
    setState(() {
      materialesOrdenes = materiales;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black26, Colors.white60],
            )
        ),

        child: Container(
          width: MediaQuery.of(context).size.width / 1.2,
          height: MediaQuery.of(context).size.height / 1.2,
          margin: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            //border: Border.all(color: Colors.blueAccent)
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Container(
                  //margin: EdgeInsets.only(top: 10),
                  //height: 30,
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Center(
                    child: Text(
                      "Materiales Disponibles",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Divider(
                    color: Colors.black,
                    //height: 36,
                  ),
                ),

                Expanded(
                  flex: 5,

                  child: Scrollbar(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 8),
                      shrinkWrap: true,
                      itemCount: materiales == null ? 0 : materiales.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text("${materiales[index]["nombre"]}: ${materiales[index]["cantidad"]}"),
                        );
                      },

                    ),
                  ),

                ),

                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30
                      ),
                      child: new RaisedButton(
                        child: new Text(
                          'Solicitar Materiales',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        color: Colors.blue,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        onPressed: () {

                        },
                      ),
                    ),
                  ),
                )

              ],
          ),
        ),



      ),
    );
  }
}
