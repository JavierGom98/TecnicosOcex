import 'package:flutter/material.dart';
import 'package:tecnicos_cm/pages/ordenes_page.dart';

class OrdenPage extends StatefulWidget {
  OrdenPage({this.idOrden, this.direccionOrden, this.nombresApellidos, this.identificacionAbon, this.actividadNombre});
  final String idOrden;
  final String direccionOrden;
  final String nombresApellidos;
  final String identificacionAbon;
  final String actividadNombre;
  @override
  _OrdenPageState createState() => _OrdenPageState();
}

class _OrdenPageState extends State<OrdenPage> {

  String nombresAbon = '';
  String identidadAbon = '';
  String actividadOrden = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      identidadAbon = "Abonado: "+identificacionAbon;
      nombresAbon = "Nombres: "+nombresApellidos;
      actividadOrden = "Actividad: "+actividadNombre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text(direccionOrden),
          backgroundColor: Colors.black54,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: CloseButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/tab_page');
                },
              ),
            ),
          ],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/1.3,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black26, Colors.white60],
                )
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height / 5.8,
                        width: MediaQuery.of(context).size.width /1.1,
                        margin: EdgeInsets.only(top: 10, left: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20
                                ),
                                child: Text(
                                  identidadAbon,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20
                                ),
                                child: Text(
                                  nombresAbon,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20
                                ),
                                child: Text(
                                  actividadOrden,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                  ],
                )

            )
        )
    );
  }
}
