import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:tecnicos_cm/main.dart';

class EstadisticasPage extends StatefulWidget {
  EstadisticasPage({this.codigoTecnico});
  final int codigoTecnico;
  @override
  _EstadisticasPageState createState() => _EstadisticasPageState();
}

class Tarea {
  String dato1;
  int dato2;
  Color colorvar;

  Tarea(this.dato1, this.dato2, this.colorvar);

  Map toJson() => {
    'dato1': dato1,
    'dato2': dato2,
    'colorvar': colorvar,
  };
}

class _EstadisticasPageState extends State<EstadisticasPage> {
  int ordRD = 0;
  int ordSRD = 0;
  int ordFTD = 0;


  int ordRM = 0;
  int ordSRM = 0;
  int ordFTM = 0;
  int ordNRM = 0;

  Future<String> getDatos() async {
    List dataJson;
    String id = codigoTecnico.toString();
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/getDatosEstadisticos.php?codigoTecnico=" + id;
    http.Response response = await http.get(Uri.parse(enlace));
    var data = json.decode(response.body);

    if(data['estadisticas'] != ""){
      //print(11111111);
      setState(() {
        dataJson = data['estadisticas'];
        ordRD = dataJson[0]['ordenesRD'];
        ordSRD = dataJson[1]['ordenesSRD'];
        ordFTD = dataJson[2]['ordenesRFTD'];

        ordRM = dataJson[3]['ordenesRM'];
        ordSRM = dataJson[4]['ordenesSRM'];
        ordFTM = dataJson[5]['ordenesRFTM'];
        ordNRM = dataJson[6]['ordenesNRM'];
      });
    }else{
      //print(22222222);
      setState(() {
        ordRD = 0;
        ordSRD = 1;
        ordFTD = 0;

        ordRM = 0;
        ordSRM = 1;
        ordFTM = 0;
        ordNRM = 0;
      });

    }

    //print(data['estadisticas']);
  /*
    setState(() {
      dataJson = data['estadisticas'];
      ordRD = dataJson[0]['ordenesRD'];
      ordSRD = dataJson[1]['ordenesSRD'];
      ordFTD = dataJson[2]['ordenesRFTD'];

      ordRM = dataJson[3]['ordenesRM'];
      ordSRM = dataJson[4]['ordenesSRM'];
      ordFTM = dataJson[5]['ordenesRFTM'];
      ordNRM = dataJson[6]['ordenesNRM'];
    });

   */
    return "";
  }

  @override
  void initState() {
    this.getDatos();
  }

  @override
  Widget build(BuildContext context) {
    final pieData = [
      new Tarea('Ordenes Realizadas', ordRD, Color(0xFF378f4d)),
      new Tarea('Ordenes sin Realizar', ordSRD, Color(0xFFafafaf)),
      //new Tarea('Ordenes no Realizadas', ordNR, Color(0xFFed5565)),
      new Tarea('Ordenes Fuera de Tiempo', ordFTD, Color(0xFFf8a326)),
    ];

    var series = [
      new charts.Series<Tarea, String>(
        data: pieData,
        domainFn: (Tarea tarea, _) => tarea.dato1,
        measureFn: (Tarea tarea, _) => tarea.dato2,
        colorFn: (Tarea tarea, _) => charts.ColorUtil.fromDartColor(tarea.colorvar),
        id: 'Ordenes',
        labelAccessorFn: (Tarea row, _) => '${row.dato2}',

        outsideLabelStyleAccessorFn: (Tarea sales, _) {
          final color = charts.MaterialPalette.red.shadeDefault;
          return new charts.TextStyleSpec(color: color);
        },
      )
    ];

    var char = new charts.PieChart(
      series,
      animate: true,
      animationDuration: Duration(milliseconds: 500),
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 100,
        arcRendererDecorators: [ new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside) ],
      ),
    );

    var chartWidget = new Expanded(
        child: Container(
          width: 200,
          child: char,
        )
    );


    final pieDataMes = [
      new Tarea('Ordenes Realizadas', ordRM, Color(0xFF378f4d)),
      new Tarea('Ordenes sin Realizar', ordSRM, Color(0xFFafafaf)),
      new Tarea('Ordenes no Realizadas', ordNRM, Color(0xFFed5565)),
      new Tarea('Ordenes Fuera de Tiempo', ordFTM, Color(0xFFf8a326)),
    ];

    var seriesMes = [
      new charts.Series<Tarea, String>(
        data: pieDataMes,
        domainFn: (Tarea tarea, _) => tarea.dato1,
        measureFn: (Tarea tarea, _) => tarea.dato2,
        colorFn: (Tarea tarea, _) => charts.ColorUtil.fromDartColor(tarea.colorvar),
        id: 'Ordenes',
        labelAccessorFn: (Tarea row, _) => '${row.dato2}',

        outsideLabelStyleAccessorFn: (Tarea sales, _) {
          final color = charts.MaterialPalette.red.shadeDefault;
          return new charts.TextStyleSpec(color: color);
        },
      )
    ];

    var charMes = new charts.PieChart(
      seriesMes,
      animate: true,
      animationDuration: Duration(milliseconds: 500),
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 100,
        arcRendererDecorators: [ new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside) ],
      ),
    );

    var chartWidgetMes = new Expanded(
        child: Container(
          width: 200,
          child: charMes,
        )
    );



    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white],
            )),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.2,
          height: MediaQuery.of(context).size.height / 1.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFd6d6d6),
                  border: new Border(
                    bottom: BorderSide(width: 1, color: Color(0xFFadadad)),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: Center(
                  child: AutoSizeText(
                    "Ordenes del día",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF636363), fontFamily: 'RobotoMono'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              chartWidget,
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFd6d6d6),
                  border: new Border(
                    bottom: BorderSide(width: 1, color: Color(0xFFadadad)),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: Center(
                  child: AutoSizeText(
                    "Ordenes del mes",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF636363), fontFamily: 'RobotoMono'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              chartWidgetMes,
              Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Container(
                //margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 15,
                            height: 15,
                            margin: EdgeInsets.only(top: 10, bottom: 10, right: 5),
                            decoration: new BoxDecoration(
                              color: Color(0xFF378f4d),
                              shape: BoxShape.circle,
                            ),
                          ),
                          AutoSizeText(
                            "Realizadas",
                            style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),//Text('Realizadas', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), ),
                          Container(
                            width: 15,
                            height: 15,
                            margin: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 20),
                            decoration: new BoxDecoration(
                              color: Color(0xFFed5565),
                              shape: BoxShape.circle,
                            ),
                          ),
                          AutoSizeText(
                            "No Realizadas",
                            style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),//Text('No Realizadas', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), ),
                        ]
                    ),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 15,
                            height: 15,
                            margin: EdgeInsets.only(top: 10, bottom: 10, right: 5),
                            decoration: new BoxDecoration(
                              color: Color(0xFFafafaf),
                              shape: BoxShape.circle,
                            ),
                          ),
                          AutoSizeText(
                            "Sin Realizar",
                            style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),//Text('Sin Realizar', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), ),
                          Container(
                            width: 15,
                            height: 15,
                            margin: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 20),
                            decoration: new BoxDecoration(
                              color: Color(0xFFf8a326),
                              shape: BoxShape.circle,
                            ),
                          ),
                          AutoSizeText(
                            "Fuera de tiempo",
                            style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),//Text('Fuera de tiempo', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), ),
                        ]
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
