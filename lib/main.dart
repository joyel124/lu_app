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
  late List<List<double>> g;//matriz generada
  late List<List<double>> a;
  late List<List<double>> l;
  late List<List<double>> u;
  late List<List<double>>? p;
  bool isValid = false;
  _MatrixLUState() {
    n = 5; // Puedes establecer el valor inicial de 'n' aquí
    g = List.generate(n, (i) => List.generate(n, (j) => 0.0));
    a = List.generate(n, (i) => List.generate(n, (j) => 0.0));
    l = List.generate(n, (i) => List.generate(n, (j) => 0.0));
    u = List.generate(n, (i) => List.generate(n, (j) => 0.0));
    p = List.generate(n, (i) => List.generate(n, (j) => 0.0));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FactoLU',
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
                    isValid = int.tryParse(value) != null;
                    n = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: isValid? () {
                  if (n >=4 && n <= 10) {
                    setState(() {
                      /*g = [
                        [0.0, 2.0, 1.0, 7.0],
                        [4.0, 8.0, 1.0, 6.0],
                        [2.0, 7.0, 9.0, 5.0],
                        [3.0, 4.0, 5.0, 1.0]
                      ];*/
                      g = generarMatriz(n);
                      p = permute(g)[1];
                      a = permute(g)[0];
                      if(esMatrizValida(a)){
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
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('La matriz no es valida'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    });
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El valor debe estar entre 4 y 10'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }: null,
                style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Generar',
                  style: labelStyleButton
                ),
              ),
              if (a != null && l != null && u != null && p == null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Matriz A:', style: labelStyle),
                    MatrixDisplay(matrix: g),
                    const SizedBox(height: 12), // espacio entre las matrices y textos
                    const Text('Matriz L:', style: labelStyle),
                    MatrixDisplay(matrix: l),
                    const SizedBox(height: 12),
                    const Text('Matriz U:', style: labelStyle),
                    MatrixDisplay(matrix: u),
                    const Text('Matriz L*U:', style: labelStyle),
                    MatrixDisplay(matrix: multiply(l, u)),
                  ],
                ),
              if (a != null && l != null && u != null && p != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Matriz A:', style: labelStyle),
                    MatrixDisplay(matrix: g),
                    const SizedBox(height: 12), // espacio entre las matrices y textos
                    const Text('Matriz L:', style: labelStyle),
                    MatrixDisplay(matrix: l),
                    const SizedBox(height: 12),
                    const Text('Matriz U:', style: labelStyle),
                    MatrixDisplay(matrix: u),
                    const SizedBox(height: 12),
                    const Text('Matriz Pt:', style: labelStyle),
                    MatrixDisplay(matrix: p!),
                    const SizedBox(height: 12),
                    // Asumiendo que tienes una función `multiplyMatrices` que
                    // multiplica dos matrices y devuelve el resultado
                    const Text('Comprobando: Pt * L * U:', style: labelStyle),
                    MatrixDisplay(matrix: multiply(multiply(p!, l), u)),//
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
                    cell.toStringAsFixed(0),
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

bool esMatrizValida(List<List<double>> matriz) {
  int n = matriz.length;

  // Comprobación del determinante de las submatrices principales
  for (int i = 1; i < n; i++) {
    List<List<double>> subMatriz = [];
    for (int x = 0; x < i; x++) {
      subMatriz.add([]);
      for (int y = 0; y < i; y++) {
        subMatriz[x].add(matriz[x][y]);
      }
    }
    if (determinante(subMatriz) == 0) {
      return false;
    }
  }
  return true;
}

List<dynamic> permute(List<List<double>> matrix) {
  int n = matrix.length;

  if (esMatrizValida(matrix)) return [matrix, null];

  List<List<double>> pt = List.generate(n, (i) => List.generate(n, (j) => i == j ? 1.0 : 0.0));

  for (var p in permutations(pt)) {
    List<List<double>> mt = matrix.map((row) => row.map((e) => e.toDouble()).toList()).toList();
    List<List<double>> m = multiply(p, mt);
    if (esMatrizValida(m)) {
      return [m, p];
    }
  }
  return [null, null];
}

List<List<double>> multiply(List<List<double>> a, List<List<double>> b) {
  int aRowCount = a.length;
  int aColumnCount = a[0].length;
  int bRowCount = b.length;
  int bColumnCount = b[0].length;

  if (aColumnCount != bRowCount) {
    throw ArgumentError('Number of columns of Matrix A must be equal to number of rows of Matrix B.');
  }

  List<List<double>> result = List.generate(aRowCount, (i) => List<double>.filled(bColumnCount, 0));

  for (int i = 0; i < aRowCount; i++) {
    for (int j = 0; j < bColumnCount; j++) {
      for (int k = 0; k < aColumnCount; k++) {
        result[i][j] += a[i][k] * b[k][j];
      }
    }
  }

  return result;
}

List<List<List<double>>> permutations(List<List<double>> matrix, [int row = 0]) {
  if (row == matrix.length) {
    return [matrix];
  }

  List<List<List<double>>> perms = [];
  for (int i = row; i < matrix.length; i++) {
    List<List<double>> newMatrix = matrix.map((r) => List.of(r)).toList();
    newMatrix[row] = List.from(matrix[i]);
    newMatrix[i] = List.from(matrix[row]);

    perms.addAll(permutations(newMatrix, row + 1));
  }
  return perms;
}

List<List<double>> identityMatrix(int size) {
  List<List<double>> id = List.generate(size, (i) => List<double>.filled(size, 0));
  for (int i = 0; i < size; i++) {
    id[i][i] = 1;
  }
  return id;
}

double determinante(List<List<double>> matriz) {
  int n = matriz.length;
  double det = 1;

  // Registro de pivotes para cambios de fila
  List<int> pivot = List.generate(n, (i) => i);

  // Descomposición LU con pivoteo
  for (int i = 0; i < n; i++) {
    // Pivoteo: buscar el máximo en la columna actual
    double maxElement = matriz[i][i];
    int maxRow = i;
    for (int j = i + 1; j < n; j++) {
      if (matriz[j][i].abs() > maxElement.abs()) {
        maxElement = matriz[j][i];
        maxRow = j;
      }
    }

    // Intercambiar filas si se encuentra un elemento más grande
    if (maxRow != i) {
      List<double> temp = matriz[i];
      matriz[i] = matriz[maxRow];
      matriz[maxRow] = temp;

      // Cambio en el registro de pivote
      int tempPivot = pivot[i];
      pivot[i] = pivot[maxRow];
      pivot[maxRow] = tempPivot;

      // Ajuste del signo del determinante
      det *= -1;
    }

    // Descomposición LU a partir de aquí
    for (int k = i + 1; k < n; k++) {
      double factor = matriz[k][i] / matriz[i][i];
      for (int j = i; j < n; j++) {
        matriz[k][j] -= factor * matriz[i][j];
      }
    }

    // Si un elemento diagonal es 0, el determinante es 0
    if (matriz[i][i] == 0) {
      return 0;
    }

    // Factor en el producto para el cálculo del determinante
    det *= matriz[i][i];
  }

  return det;
}

