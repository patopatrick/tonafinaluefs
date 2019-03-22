import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {

  runApp(MaterialApp(
    title: "Final UEFS",
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.indigo[900],
      primaryColor: Colors.indigo[900]
    ),
  ));

}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _info = "Informe suas notas...";
  double _NFm = 0;
  TextEditingController nota1 = TextEditingController();
  TextEditingController nota2 = TextEditingController();
  TextEditingController nota3 = TextEditingController();

  void _reset(){
    vibrate();
    nota1.text = "";
    nota2.text = "";
    nota3.text = "";
    setState(() {
      _info = "Informe suas notas...";
    });
  }

  void _calcular(){
    setState(() {
      double _notaUm = double.parse(nota1.text);
      double _notaDois = double.parse(nota2.text);
      double _notaTres = double.parse(nota3.text);
      double _media = (_notaUm + _notaDois + _notaTres) / 3;
      if( _media >= 7 ){
        if( _media == 7 ){
          _info = "Por pouco em cara acho melhor você dar uma manerada na Netflix e no Instagram, Sua média foi ${_media.toStringAsPrecision(3)}";
        }
        else{
          _info = "Parabéns você passou!!, Sua média foi ${_media.toStringAsPrecision(3)}";
        }
      }
      else if( _media >= 3 && _media < 7 ){
        _NFm = (12.5 - (1.5*_media));
        if(_NFm < 3){
          _NFm = 3.0;
        }
        _info = "Que comecem os jogos, você está nas Finais, Sua média foi ${_media.toStringAsPrecision(3)} e você vai precisar de no mínimo ${_NFm.toStringAsPrecision(3)} para passar na Prova Final.";

      }
      else if( _media < 3  && _media >= 0){
        _info = "Você não alcançou a média minima para as finais, Tente novamente no próximo semestre, Sua média foi ${_media.toStringAsPrecision(3)}";
      }
    });
  }

  static Future<void> vibrate() async {
    await SystemChannels.platform.invokeMethod('HapticFeedback.vibrate');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        /*Image.asset(
          "images/bgn1.png",
          fit: BoxFit.cover,
          height: 1000.0,
        ),*/
        Scaffold(
          appBar: AppBar(
            title: Text("Final UEFS", style: TextStyle(color: Colors.cyan[50]),),
            backgroundColor: Colors.indigo[900],
            centerTitle: true,
            actions: <Widget>[
              IconButton(icon: Icon(
                  Icons.refresh),
                  onPressed: _reset
              )
            ],
          ),
          backgroundColor: Colors.cyan[50],
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    height: 130.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "images/iconnew.png",
                          fit: BoxFit.cover,
                          height: 1000.0,
                        ),
                      ],
                    ) ,
                  ),
                  //Input Notas
                  inputNotas("Nota 1", nota1),
                  Divider(),
                  inputNotas("Nota 2", nota2),
                  Divider(),
                  inputNotas("Nota 3", nota3),
                  //Botão Calcular
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                    child: Container(
                      height: 40.0,
                      child: RaisedButton(
                        onPressed: () {
                          vibrate();
                          if( _formKey.currentState.validate()){
                            _calcular();
                          }
                        },
                        color: Colors.indigo[900],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.arrow_forward_ios, color: Colors.cyan[50], size: 25.0,),
                            Text("Calcular", style: TextStyle(color: Colors.cyan[50], fontSize: 25.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Mensagem para o Usuario
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                    child: Text(
                      "$_info",
                      style: TextStyle(color: Colors.black, fontSize: 25.0, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget inputNotas(String text, TextEditingController controller){
  return TextFormField(
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        border: OutlineInputBorder()
    ),
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.black, fontSize: 20.0),
    controller: controller,
    validator: (value) {
      if(value.isEmpty){
        return "Insira um valor";
      }
      else if(double.parse(controller.text) > 10 || double.parse(controller.text) < 0){
        return "Insira uma nota de 0 a 10";
      }
    },
  );
}