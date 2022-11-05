import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Matematiksel işlemler için math_expressions kütüphanesi kullanıldı.

void main(List<String> args) {
  runApp(const Calculator());
}

class Calculator extends StatelessWidget {
  const Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // debug bayrağı kaldırıldı
      title: "Simple Calculator",
      theme: ThemeData.dark(), // Karanlık tema seçildi.
      home: const SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({super.key});

  @override
  State<SimpleCalculator> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;
  // butona basıldığında çağrılacak fonksiyon
  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        // Silme tuşu ile değerler sıfırlanıyor.
        equation = "0";
        result = "0";
        equationFontSize =
            38.0; // Fontsize değişkenlerini tekrar belirlememizin nedeni eski değer
        resultFontSize =
            48.0; // ile yeni değer arasında boyut farkı gözükmesi içindir.
      } else if (buttonText == "⌫") {
        // Silme işareti unicode karakter listesinden alındı -> https://www.fileformat.info/info/unicode/category/Sm/list.htm
        equation = equation.substring(
            0,
            equation.length -
                1); // Her silme tuşuna basıldığında girilen stringin son elemanını siler.
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "") {
          equation = "0";
        } // Burada boş gelme durumunda oluşacak hata önlendi.
      } else if (buttonText == "=") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;
        expression = equation;

        try {
          Parser p = Parser();
          Expression exp = p.parse(
              expression); // Burada işlemin ifadesi kütüphane için alınır.
          ContextModel cm = ContextModel(); // işlem için nesne oluşturulur.
          result =
              '${exp.evaluate(EvaluationType.REAL, cm)}'; // exp.evaluate ile işlem yapılır. Evaluationtype.Real ile işleme girecek sayıların gerçek sayılar
          // olduğu belirtilir.
        } catch (e) {
          result =
              "Hata"; // Herhangi bir matematiksel hata durumunda ekrana hata olarak yazar.
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation += buttonText;
        }
      }
    });
  }

  Widget buttoncreate(
      String buttonText, double buttonHeight, Color buttoncolor) {
    // butonları tek tek oluşturmak yerine direkt olarak widget oluşturup gerekli parametreler ile
    // kendi butonlarımızı oluşturabiliriz.
    // ignore: sized_box_for_whitespace
    return Container(
      height: MediaQuery.of(context).size.height *
          .1 *
          buttonHeight, // Mediaquery ile cihazın çözünürlük bilgileri tutulur ve taşmalara karşı responsive olarak kullanılır.
      child: ElevatedButton(
          // Yuvarlak Buton
          // ignore: sort_child_properties_last
          child: Text(buttonText, style: const TextStyle(fontSize: 18)),
          style: ButtonStyle(
              // ButtonStyle ile butonun görünüşü belirlendi. Bunun yerine ElevatedButton.fromStyle da kullanılabilir.
              foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.white), // Yazı rengi
              backgroundColor: MaterialStateProperty.all<Color>(
                  buttoncolor), // Buton arkaplan rengi
              shape: MaterialStateProperty.all<CircleBorder>(
                  // Butonun yuvarlak olarak belirlenmesi
                  CircleBorder(side: BorderSide(color: buttoncolor)))),
          onPressed: () => buttonPressed(
              buttonText)), // Butona basıldığında hangi fonskyionu çağırdığı
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Simple Calculator"), // Appbarda görünecek title
        ),
        body: Column(children: [
          // Sütun oluşturma işlemi
          Container(
            alignment: Alignment.centerRight, // Tamamen sağa yaslama işlemi
            padding: const EdgeInsets.fromLTRB(10, 20, 10,
                0), // padding değerini soldan üstten sağdan ve aşağıdan ayrı ayrı belirlemek için
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize),
            ),
          ),
          const Expanded(
            child:
                Divider(), // Araya bölücü bir çizgi konuyor. Expanded içinde olmasının sebebi ekran sonuna kadar oto genişletilebilmesi.
          ),
          Row(
            // Satır oluşturma işlemi
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .70,
                padding: const EdgeInsets.all(
                    15), // Her taraftan 15 birim sıkıştırma işlemi
                child: Table(
                  // Table oluşturma
                  children: [
                    TableRow(children: [
                      // Table satırlarında neler olması gerektiği
                      buttoncreate(
                          "AC", 1, Colors.red), // Butonlar satır satır tanımlı
                      buttoncreate("⌫", 1, Colors.lime),
                      buttoncreate("+", 1, Colors.teal)
                    ]),
                    TableRow(children: [
                      buttoncreate("1", 1, Colors.blueGrey),
                      buttoncreate("2", 1, Colors.blueGrey),
                      buttoncreate("3", 1, Colors.blueGrey)
                    ]),
                    TableRow(children: [
                      buttoncreate("4", 1, Colors.blueGrey),
                      buttoncreate("5", 1, Colors.blueGrey),
                      buttoncreate("6", 1, Colors.blueGrey)
                    ]),
                    TableRow(children: [
                      buttoncreate("7", 1, Colors.blueGrey),
                      buttoncreate("8", 1, Colors.blueGrey),
                      buttoncreate("9", 1, Colors.blueGrey)
                    ]),
                    TableRow(children: [
                      buttoncreate(".", 1, Colors.blueGrey),
                      buttoncreate("0", 1, Colors.blueGrey),
                      buttoncreate("00", 1, Colors.blueGrey)
                    ])
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .30,
                child: Table(
                  children: [
                    TableRow(children: [
                      buttoncreate("-", 1, Colors.teal),
                    ]),
                    TableRow(children: [
                      buttoncreate("*", 1, Colors.teal),
                    ]),
                    TableRow(children: [
                      buttoncreate("/", 1, Colors.teal),
                    ]),
                    TableRow(children: [
                      buttoncreate(
                          "=",
                          2,
                          Colors
                              .teal), // burda 2 vermemizin nedeni, 2 satıra tek buton denk gelmesidir.
                    ])
                  ],
                ),
              )
            ],
          )
        ]));
  }
}
