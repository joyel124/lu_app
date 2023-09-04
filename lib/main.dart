import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
    home: MatrixLU(),
  ));
}

class MatrixLU extends StatefulWidget {
  @override
  _MatrixLUState createState() => _MatrixLUState();
}

class _MatrixLUState extends State<MatrixLU> {
  late int n;
  late List<List<double>> a;
  late List<List<double>> l;
  late List<List<double>> u;
  _MatrixLUState() {
    n = 5; // Puedes establecer el valor inicial de 'n' aquí
    a = List.generate(n, (i) => List.generate(n, (j) => 0.0));
    l = List.generate(n, (i) => List.generate(n, (j) => 0.0));
    u = List.generate(n, (i) => List.generate(n, (j) => 0.0));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Factorización LU'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Ingrese el valor de N',
                ),
                onChanged: (value) {
                  setState(() {
                    n = int.tryParse(value) ?? 0;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (n > 0) {
                    setState(() {
                      a = generarMatriz(n);
                      l = List.generate(n, (i) => List.filled(n, 0.0));
                      u = List.generate(n, (i) => List.filled(n, 0.0));

                      for (int i = 0; i < n; i++) {
                        for (int j = 0; j < n; j++) {
                          if (i == j) {
                            l[i][j] = 1.0;
                            double lkj = 0.0;
                            for (int k = 0; k < j; k++) {
                              lkj += l[j][k] * u[k][j];
                            }
                            u[j][j] = a[j][j] - lkj;
                          } else if (i < j) {
                            double lijkj = 0.0;
                            for (int k = 0; k < i; k++) {
                              lijkj += l[i][k] * u[k][j];
                            }
                            u[i][j] = (a[i][j] - lijkj) / l[i][i];
                          } else {
                            double lkj = 0.0;
                            for (int k = 0; k < j; k++) {
                              lkj += l[i][k] * u[k][j];
                            }
                            l[i][j] = (a[i][j] - lkj) / u[j][j];
                          }
                        }
                      }
                    });
                  }
                },
                child: Text('Calcular Factorización LU'),
              ),
              if (a != null && l != null && u != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Matriz A:'),
                    MatrixDisplay(matrix: a),
                    Text('Matriz L:'),
                    MatrixDisplay(matrix: l),
                    Text('Matriz U:'),
                    MatrixDisplay(matrix: u),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<List<double>> generarMatriz(int n) {
    Random random = Random();
    return List.generate(n, (i) => List.generate(n, (j) => random.nextInt(10).toDouble()));
  }
}

class MatrixDisplay extends StatelessWidget {
  final List<List<double>> matrix;

  MatrixDisplay({required this.matrix});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: matrix.map((row) {
        return TableRow(
          children: row.map((cell) {
            return TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cell.toStringAsFixed(3)),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
