// Criba de Eratostenes: calcula los numeros primos > 1 y < 150 
{
  bool a[150];
  int max;     // Numero maximo para buscar
  int n;       // Siguiente numero primo  
  int i;
  bool OK;

  read(max); 
  // Comprobamos que es un numeo admisible
  OK = false;
  while (! OK) {
    if (max > 1) 
      if (max < 150) OK = true; else read(max);
    else read(max);
  }
  // Inicializamos el vector de posible primos
  i = 2;
  while (i <= max) { a[i] = true; i++; }
  // Criba de Earatostenes
  n = 2; OK = false;
  while (! OK) {
    // Eliminamos los multiplos de "n"
    i = 2;
    while ((i * n) <= max) { a[i * n] = false; i++; }
    // Buscamos el siguiente primo
    i = n + 1;
    while (! a[i] && (i <= max)) {i++;}
    // Controlamos el fin (n * n > max)
    if ((i * i) < max) n = i;
    else OK = true;
  }
  // Visualizamos los primos obtenidos menores que "max"
  i = 2;
  while (i <= max) {
    if (a[i]) print(i); else {};
    i++;
  }
}
