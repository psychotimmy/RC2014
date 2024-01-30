/************************************************************/
/*                                                          */
/*      Prime number generator - Sieve of Eratosthenes      */ 
/*             Tim Holyoake, 30th January 2024              */           
/*         Written for Aztec C 1.06D, Z80 CP/M 2.2          */
/*                                                          */
/* Compile with: CZ PRIMES(.C)                              */
/* Assemble with: AS -ZAP PRIMES(.ASM)                      */
/* Link with: LN PRIMES.O M.LIB C.LIB to produce PRIMES.COM */
/*                                                          */
/************************************************************/
#define TRUE 1
#define FALSE 0
#define PMAX 256

/* Globals */
int primea[PMAX];
int primec;

main()
{
  int sc, limit, next;

  sc = 1;
  printf("Enter prime number limit - greater than 7, less than 32,768 > ");
  scanf("%d",&limit);
  printf("\n");
 
  if ((limit > 7) && (limit < 32768)) {
    primec = -1;
    next = 11;
    printf("%7d%7d%7d%7d",2,3,5,7);
    sc = 5;
    while (next <= limit) {
      if (((next % 3) != 0) && ((next % 5) != 0) && ((next % 7) != 0))
        if (sieve(next)) {
          if (primec < PMAX)
            primea[++primec] = next;
          printf("%7d",next);
          if ((sc++ % 10) == 0)
            printf("\n");
        }
      next = next+2;
    }
  }
  else
    printf("Limit must be greater than 7 and less than 32,768!");
  if ((sc % 10) != 1)
    printf("\n"); /* New line if not already issued after printing 10 primes */
  printf("\n%d primes found\n",sc-1);
}

sieve(number)
int number;
{
  extern double sqrt();
  int sr, count, cPrime;

  sr = (int)(sqrt((double)number)+0.5);  /* Round up */
  count = 0;
  cPrime = TRUE;
  while ((count <= primec) && (cPrime)) {
    if (primea[count] <= sr)
      if ((number % primea[count]) == 0)
        cPrime = FALSE;
    ++count;
  }
  return(cPrime);
}
