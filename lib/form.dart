import 'package:flutter/material.dart';
import 'package:tictactoe/game.dart';

class MyFormPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Home Page';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyForm(),
      ),
    );

  }
}
class MyForm extends StatefulWidget {

  @override
  MyFormState createState() {
    return MyFormState();

  }
}

class MyFormState extends State<MyForm> {

  final _formKey = GlobalKey<FormState>();
  String s="",t="";
  final myController = new TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              TextFormField(controller: myController,decoration: InputDecoration(labelText: 'Enter username of player O'),),
              TextFormField(validator: (value){

                t=value;
                if(value.isEmpty)
                  return 'Please enter some text';
                return null;
              },decoration: InputDecoration(labelText: 'Enter username of player X'),),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      s=myController.text;
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(st1: s,st2: t),));
                    }

                  },
                  child: Text('Submit'),
                ),
              ),
            ]
        )
    );
  }
}



class MyHomePage extends StatefulWidget {

  final String st1,st2;
  MyHomePage({Key key,this.st1,this.st2}) :super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {

  List<List> _matrix;

  _MyHomePageState() {
    _initMatrix();

  }

  _initMatrix() {
    _matrix = List<List>(3);
    for (var i = 0; i < _matrix.length; i++) {
      _matrix[i] = List(3);
      for (var j = 0; j < _matrix[i].length; j++) {
        _matrix[i][j] = ' ';
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildElement(0, 0),
                _buildElement(0, 1),
                _buildElement(0, 2),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildElement(1, 0),
                _buildElement(1, 1),
                _buildElement(1, 2),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildElement(2, 0),
                _buildElement(2, 1),
                _buildElement(2, 2),
              ],
            ),
          ],
        ),
      ),

    );
  }

  String _lastChar='X';

  _buildElement(int i, int j) {
    return GestureDetector(
      onTap: () {
        _changeMatrixField(i, j);

        if (_checkWinner(i, j)) {
          _showDialog(_matrix[i][j]);
        } else {
          if (_checkDraw()) {
            _showDialog(null);
          }
        }
      },
      child: Container(
        width: 90.0,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
                color: Colors.black
            )
        ),
        child: Center(
          child: Text(
            _matrix[i][j],
            style: TextStyle(
                fontSize: 92.0
            ),
          ),
        ),
      ),
    );
  }

  _changeMatrixField(int i, int j) {
    setState(() {
      if (_matrix[i][j] == ' ') {
        if (_lastChar == 'O')
          _matrix[i][j] = 'X';

        else
          _matrix[i][j] = 'O';

        _lastChar = _matrix[i][j];
      }
    });
  }

  _checkDraw() {
    var draw = true;
    _matrix.forEach((i) {
      i.forEach((j) {
        if (j == ' ')
          draw = false;
      });
    });
    return draw;
  }

  _checkWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    var n = _matrix.length-1;
    var player = _matrix[x][y];

    for (int i = 0; i < _matrix.length; i++) {
      if (_matrix[x][i] == player)
        col++;
      if (_matrix[i][y] == player)
        row++;
      if (_matrix[i][i] == player)
        diag++;
      if (_matrix[i][n-i] == player)
        rdiag++;
    }
    if (row == n+1 || col == n+1 || diag == n+1 || rdiag == n+1) {
      return true;
    }
    return false;
  }

  _showDialog(String winner) {
    String dialogText;
    if (winner == null) {
      dialogText = 'It\'s a draw';
    }
    else {
      if(winner=='O')
        dialogText=' ${widget.st1} wins';
      else
        dialogText=' ${widget.st2} wins';

    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Game over'),
            content: Text(dialogText),
            actions: <Widget>[
              FlatButton(
                child: Text('Reset Game'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _initMatrix();
                  });
                },
              )
            ],
          );
        }
    );
  }
}


