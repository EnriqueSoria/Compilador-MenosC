// Calcula el factorial de un múmero > 0 y < 13
{  int n; int fac; int i;

   fac = 1; read(n);
   if ((n > 0) && (n < 13)) {
     i = 2;
     while (i <= n) {
       fac = fac * i;
       i++;
     }
     print(fac);
   }
   else {}
}
