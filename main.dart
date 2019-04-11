import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ToNaFinal extends StatefulWidget {
  @override
  _ToNaFinalState createState() => _ToNaFinalState();
}

class _ToNaFinalState extends State<ToNaFinal> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _info = "Informe suas notas...";
  String _zoas = "";
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
        if( _media >= 7 && _media < 8 ){
          _info = "Por pouco... acho melhor você dar uma manerada na Netflix e no Instagram\nSua média foi ${_media.toStringAsPrecision(3)}";
          _zoas = "Quase na Final :)";
        }
        else{
          _info = "Parabéns você passou!!!\nSua média foi ${_media.toStringAsPrecision(3)}";
          _zoas = "Fugi da Final :)";
        }
      }
      else if( _media >= 3 && _media < 7 ){
        _NFm = (12.5 - (1.5*_media));
        if(_NFm < 3){
          _NFm = 3.0;
        }
        _info = "Que comecem os jogos, você está na Final...\nSua média foi ${_media.toStringAsPrecision(3)} e você vai precisar de no mínimo ${_NFm.toStringAsPrecision(3)} para passar na Prova Final.";
        _zoas = "Estou na Final :/";
      }
      else if( _media < 3  && _media >= 0){
        _info = "Você não alcançou a nota minima para as finais, Tente novamente no próximo semestre...\nSua média foi ${_media.toStringAsPrecision(3)}";
        _zoas = "Nem na Final :(";
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
            title: Text("To na Final?"),
            backgroundColor: Colors.indigo[900],
            centerTitle: true,
            actions: <Widget>[
              IconButton(icon: Icon(
                  Icons.refresh),
                  onPressed: _reset
              )
            ],
          ),
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
                            showDialog<String> (
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text("$_zoas"),
                                  content: Text("$_info", style: TextStyle(fontStyle: FontStyle.normal, fontSize: 20.0),),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: (){
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: Text('OK')
                                    )
                                  ],
                                );
                            }
                            ).then<String>((returnVal){
                              if(returnVal != null){
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    action: SnackBarAction(label: 'OK', onPressed: (){}),
                                    content: Text('Voce clicou no $returnVal')),
                                );
                              }
                            });
                          }
                        },
                        color: Colors.indigo[900],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.arrow_forward_ios,color: Colors.white, size: 25.0,),
                            Text("Calcular", style: TextStyle(color: Colors.white,fontSize: 25.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Mensagem para o Usuario
                  /*Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                    child: Text(
                      "$_info",
                      style: TextStyle(color: Colors.black, fontSize: 25.0, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  )*/
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
