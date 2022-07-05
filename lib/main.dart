// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MaterialApp(
  home: Calculator(),
));

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  double result = 0;
  String display = '0';
  double firstNum = 0;
  double secondNum = 0;
  String operator = "";
  bool doubleFlag = false;

  Widget calcbutton(String btntext, Color? btncolor, Color txtcolor) {
    return Container(
        child: RaisedButton(
          onPressed: () {
            makeAction(btntext);
          },
          shape: CircleBorder(),
          color: btncolor,
          padding: EdgeInsets.all(20),
          child: Text(btntext,
            style: TextStyle(
                fontSize: 35,
                color: txtcolor
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Flutter Calculator"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(display,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 100.0,
                        )
                    )
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcbutton('AC', Colors.grey, Colors.black),
                calcbutton('+/-', Colors.grey, Colors.black),
                calcbutton('%', Colors.grey, Colors.black),
                calcbutton('/', Colors.amber[700], Colors.white),
              ],
            ),
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcbutton('7', Colors.grey[850], Colors.white),
                calcbutton('8', Colors.grey[850], Colors.white),
                calcbutton('9', Colors.grey[850], Colors.white),
                calcbutton('x', Colors.amber[700], Colors.white),
              ],
            ),
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcbutton('4', Colors.grey[850], Colors.white),
                calcbutton('5', Colors.grey[850], Colors.white),
                calcbutton('6', Colors.grey[850], Colors.white),
                calcbutton('+', Colors.amber[700], Colors.white),
              ],
            ),
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcbutton('1', Colors.grey[850], Colors.white),
                calcbutton('2', Colors.grey[850], Colors.white),
                calcbutton('3', Colors.grey[850], Colors.white),
                calcbutton('-', Colors.amber[700], Colors.white),
              ],
            ),
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  padding: EdgeInsets.fromLTRB(34, 20, 128, 20),
                  onPressed: () {
                    // button function
                    makeAction('0');
                  },
                  shape: StadiumBorder(),
                  color: Colors.grey[850],
                  child: Text('0',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
                calcbutton('.', Colors.grey[850], Colors.white),
                calcbutton('=', Colors.grey[850], Colors.white)
              ],
            ),
          ],
        ),
      ),
    );
  }

  void makeAction(String string) {
    if (string == 'AC') {
      doubleFlag = false;
      firstNum = 0;
      secondNum = 0;
      operator = "";
      result = 0;
      setState(() {
        display = '0';
      });
    }
    else if (operator == "") { // if operator isn't chosen yet
      firstNumberAction(string);
    }
    else if (operator != "") {
      secondNumberAction(string);
    }
  }

  void firstNumberAction(String string) {
    try {
      if (string == '+/-') {
        if (firstNum != 0) {
          firstNum = firstNum * -1;
        }
        setState(() {
          display = formatNum(firstNum);
        });
      }
      else if (string == '.') {
        doubleFlag = true;
        var f = NumberFormat("###.", "en_US");
        setState(() {
          display = f.format(firstNum);
        });
      }
      else {
        int first_num = int.parse(string);
        if (first_num >= 0 || first_num <= 9) {
          double displayNum = double.parse(display);
          if (!doubleFlag) {
            firstNum = firstNum * 10 + first_num;
            setState(() {
              display = formatNum(firstNum);
            });
          }
          else {
            setState(() {
              display = display + string;
            });
            firstNum = double.parse(display);
          }

        }
      }
    }
    catch (e) {
      operator = string;
      setState(() {
        display = string;
      });
      doubleFlag = false;
    }
  }

  void secondNumberAction(String string){
    if (string == '+/-') {
      if (secondNum != 0) {
        secondNum = secondNum * -1;
      }
      setState(() {
        display = formatNum(secondNum);
      });
    }
    else if (string == '.') {
      doubleFlag = true;
      var f = NumberFormat("###.", "en_US");
      setState(() {
        display = f.format(secondNum);
      });
    }
    else {
      try {
        int sec_num = int.parse(string);
        if (sec_num >= 0 || sec_num <= 9) {
          if (!doubleFlag) {
            secondNum = secondNum * 10 + sec_num;
            setState(() {
              display = formatNum(secondNum);
            });
          }
          else {
            setState(() {
              display = display + string;
            });
            secondNum = double.parse(display);
          }
        }
      }
      catch (e) {
        if (string == '=') {
          doubleFlag = false;
          switch (operator) {
            case '+':
              result = calcAdd(firstNum, secondNum);
              break;
            case '-':
              result = calcSub(firstNum, secondNum);
              break;
            case 'x':
              result = calcMul(firstNum, secondNum);
              break;
            case '/':
              result = calcDiv(firstNum, secondNum);
              break;
            case '%':
              result = calcMod(firstNum, secondNum);
              break;
          }

          setState(() {
            display = formatNum(result);
          });
          firstNum = result;
          secondNum = 0;
          print('result = $result');
          print('display = $display');
        }
        else if (string != '=') {
          doubleFlag = false;
        }
      }
    }
  }
}


double calcAdd(double firstNum, double secondNum){
  return firstNum + secondNum;
}

double calcSub(double firstNum, double secondNum){
  return firstNum - secondNum;
}

double calcMul(double firstNum, double secondNum){
  return firstNum * secondNum;
}

double calcDiv(double firstNum, double secondNum){
    return firstNum / secondNum;
}

double calcMod(double firstNum, double secondNum){
  return firstNum % secondNum;
}

String formatNum(double num){
  if (num - num.floor() == 0.0) {
    var f = NumberFormat("###", "en_US");
    return f.format(num);
  }
  else {
    return num.toString();
  }
}

