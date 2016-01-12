// Ejemplo del uso de operadores logicos.
// Lee dos numeros (x e y) y devuelve "1" si "y"
// es menor que "x" y mayor que "0"
{ int x; int y;
  bool z; 

  z = true; read(x); 
  while (z) {
    read(y); 
    if ((y <= x) && (y >= 0))        
      if (!(y == 0))
        if (y != x)                        
          if ((y < x) || (y > 0)) {
            print(1); z = false;
          }
          else print(0);
	else {}
      else {}
    else {}
  }
}
