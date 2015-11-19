// Ejemplo (sin sentido) sobre vectores con 6 errores
{
  int  a[20];
  int  b;
  bool c;
  bool d[0];         // Talla inapropiada

  e = 27;            // Objeto no declarado
  b = c;             // Error de tipos en la "asignacion"
  c = a[2];          // Error de tipos en la "asignacion"

  a[c] = 1 ;         // Error en el indice del "array"
  b[14] = 27;        // La variable debe ser "T_ARRAY"
}

