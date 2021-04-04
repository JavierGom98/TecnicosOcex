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

 class Tarea{
  String dato1;
  int dato2;
  Color colorvar;

    Tarea(this.dato1, this.dato2, this.colorvar);
 }

class _EstadisticasPageState extends State<EstadisticasPage> {

  List<charts.Series<Tarea, String>> _seriesPieData;

  getDatos() async{
    String id = codigoTecnico.toString();
    String enlace = "http://ns212.cablebox.co:5510/appmovil/getMateriales.php/?codigoTecnico="+id;
    //http.Response response = await http.get(enlace);
    //var data = json.decode(response.body);
    //print(data);

    var pieData = [
      new Tarea('Ordenes Realizadas', 15, Color(0xff22bb33)),
      new Tarea('Ordenes sin Realizar', 5, Color(0xffbb2124)),
    ];

    _seriesPieData.add(
      charts.Series(
        data: pieData,
        domainFn: (Tarea tarea,_)=> tarea.dato1,
        measureFn: (Tarea tarea,_)=> tarea.dato2,
        colorFn: (Tarea tarea,_)=> charts.ColorUtil.fromDartColor(tarea.colorvar),
        id: 'Esta es una prueba',
        labelAccessorFn: (Tarea row,_)=>'${row.dato2}',
      ),
    );
  }

  @override
  void initState() {
    _seriesPieData = List<charts.Series<Tarea, String>>();
    getDatos();

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
                width: MediaQuery.of(context).size.width / 1.3,
                child: Center(
                  child: Text(
                    "Ordenes Dia",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Divider(
                  color: Colors.black,
                ),
              ),

              Expanded(
                  child: Container(
                    width: 300,
                    height: 300,
                    child: charts.PieChart(
                      _seriesPieData,
                      animate: true,
                      animationDuration: Duration(seconds: 3),
                      behaviors: [
                        new charts.DatumLegend(
                            outsideJustification: charts.OutsideJustification.endDrawArea,
                            horizontalFirst: false,
                            desiredMaxRows: 2,
                            cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                            entryTextStyle: charts.TextStyleSpec(
                                color: charts.MaterialPalette.purple.shadeDefault,
                                fontFamily: 'Georgia',
                                fontSize: 15
                            )
                        )
                      ],
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 100,
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside
                            )
                          ]
                      ),
                    ),
                  )


              ),

              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Center(
                  child: Text(
                    "Ordenes Mes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Divider(
                  color: Colors.black,
                ),
              ),

              Expanded(
                  child: Container(
                    width: 300,
                    height: 300,
                    child: charts.PieChart(
                      _seriesPieData,
                      animate: true,
                      animationDuration: Duration(seconds: 3),
                      behaviors: [
                        new charts.DatumLegend(
                            outsideJustification: charts.OutsideJustification.endDrawArea,
                            horizontalFirst: false,
                            desiredMaxRows: 2,
                            cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                            entryTextStyle: charts.TextStyleSpec(
                                color: charts.MaterialPalette.purple.shadeDefault,
                                fontFamily: 'Georgia',
                                fontSize: 15
                            )
                        )
                      ],
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 100,
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside
                            )
                          ]
                      ),
                    ),
                  )


              )

            ],
          ),
        ),



      ),
    );
  }
}
