// Errores lexicos simples: 3 advertencias y 1 error lexico
{
  int  abcdefghijklmnopqrstuwxyz;           // identificador excesivo
  bool b;
  int  c#;                                  // caracter desconocido

  abcdefghijklmn = 27;
  c = 3.56;                                 // contante real
  if (abcdefghijklmnopqrstuwxyz < 27)       // identificador excesivo
    b = true;
  else b = false;
}
