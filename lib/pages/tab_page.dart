import 'package:flutter/material.dart';
import 'package:tecnicos_cm/main.dart';
import 'package:tecnicos_cm/pages/estadisticas_page.dart';
import 'package:tecnicos_cm/pages/material_page.dart';
import 'package:tecnicos_cm/pages/ordenesRealizadas_page.dart';
import 'package:tecnicos_cm/pages/ordenes_page.dart';
import 'package:tecnicos_cm/pages/profile_page.dart';

class TabPage extends StatefulWidget {
  TabPage({this.codigoTecnico, this.nombreTecnico, this.cargoTecnico});
  final int codigoTecnico;
  final String nombreTecnico;
  final String cargoTecnico;
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Tab> myTabs = <Tab>[
    new Tab(icon: Icon(Icons.home),),
    new Tab(icon: Icon(Icons.domain_verification),),
    new Tab(icon: Icon(Icons.leaderboard),),
    new Tab(icon: Icon(Icons.construction),),
    new Tab(icon: Icon(Icons.dehaze),)
  ];

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: myTabs.length, vsync: this);
    tabController.addListener(() {
      setState(() {
        print("index ${tabController.index}");
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Tecnicos"),
        backgroundColor: Colors.black54,
        bottom: new TabBar(
          tabs: myTabs,
          controller: tabController,
        ),
      ),
      body: new TabBarView(
          children: [
            new OrdenesPage(codigoTecnico: codigoTecnico,),
            new OrdenesRealizadasPage(),
            new EstadisticasPage(),
            new MaterialesPage(codigoTecnico: codigoTecnico,),
            new ProfilePage(codigoTecnico: codigoTecnico, nombreTecnico: nombreTecnico, cargoTecnico: cargoTecnico)
          ],
        controller: tabController,
      ),
    );
  }
}
