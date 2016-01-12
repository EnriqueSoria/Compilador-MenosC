// Ejemplo sencillo de manipulacion de vectores.
// Debe devolver la cuenta inversa desde 9
{ int a[10];
  int i;

  i = 0;
  while (i < 10) {
    a[i] = i; i++;
  }
  i = 9; 
  while (i >= 0) {
    print(a[i]); i--;
  }
}
