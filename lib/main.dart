import 'dart:math';

import 'package:flutter/material.dart';

const primaryColor = Color(0xFF6200EE);
const secondaryColor = Color(0xFF03DAC5);
const backgroundColor = Color(0xFFF5F5F5);
const textColor = Color(0xFF000000);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: primaryColor,
);

const bodyStyle = TextStyle(
  fontSize: 16,
  color: textColor,
);

const labelStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: textColor,
);

const labelStyleButton = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

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
        title: const Text(
          'Factorización LU',
          style: TextStyle(
            color: backgroundColor, // Texto blanco
            fontWeight: FontWeight.w700, // Semi-Bold
          ),
        ),
        backgroundColor: primaryColor, // Fondo Morado
        elevation: 0, // Elimina la sombra
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Ingrese el valor de N',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    n = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 12),
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
                style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Calcular Factorización LU',
                  style: labelStyleButton
                ),
              ),
              if (a != null && l != null && u != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Matriz A:', style: labelStyle),
                    MatrixDisplay(matrix: a),
                    const SizedBox(height: 12), // espacio entre las matrices y textos
                    const Text('Matriz L:', style: labelStyle),
                    MatrixDisplay(matrix: l),
                    const SizedBox(height: 12),
                    const Text('Matriz U:', style: labelStyle),
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: secondaryColor, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: Table(
        border: TableBorder.symmetric(
          inside: const BorderSide(color: primaryColor, width: 1),
          outside: const BorderSide(color: secondaryColor, width: 2),
        ),
        children: matrix.map((row) {
          return TableRow(
            children: row.map((cell) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    cell.toStringAsFixed(1),
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
