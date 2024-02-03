      REM **********************************************************
      REM *                                                        *
      REM *     Prime number generator - Sieve of Eratosthenes     *
      REM *          Tim Holyoake, 3rd February 2024               *
      REM *    Written for the Digital Research CBASIC compiler    *
      REM *                CB80 - Z80 CP/M 2.2                     *
      REM *                                                        *
      REM * Compile with: CB80 PRIMES80(.BAS)                      *
      REM * Link with: LK80 PRIMES80(.REL) to produce PRIMES80.COM *
      REM *                                                        *
      REM **********************************************************

      INTEGER P(1), L, PC, X, W, J, SC, TEST
      DIM P(255)

      DEF SIEVE(NUM)
      INTEGER CT, CPR
      REAL SR
      SR = SQR(NUM)+0.5
      CT = 1
      CPR = 1
      WHILE (CT <= PC) AND (CPR = 1)
        IF P(CT) <= SR THEN \
          IF (MOD(NUM,P(CT)) = 0) THEN CPR = 0
        CT = CT+1
      WEND
      SIEVE = CPR
      FEND
    
      SC = 0
      PRINT "Enter prime number limit - greater than 7, less than 32,750 ";
      INPUT L
      PRINT
      IF ((L < 8) OR (L > 32749)) THEN GOTO FER

      REM *** Print low primes
      PRINT "      2      3      5      7";
      REM *** PC keeps track of how much space is used in array P
      SC = 4: X = 7: PC = 0

      REM *** Ignore low primes
MAIN: IF ((MOD(X,3) = 0) OR (MOD(X,5) = 0) OR (MOD(X,7) = 0)) THEN GOTO INCX
      TEST = SIEVE(X)
      IF TEST = 1 THEN \
        PRINT USING "#######";X;: SC = SC+1: IF MOD(SC,10)=0 THEN PRINT
      IF (TEST = 1) AND (PC < 255) THEN \
        PC = PC+1: \
        P(PC) = X
          
INCX: X = X+2
      IF X <= L THEN GOTO MAIN

      REM *** Normal exit when L > X
      IF (MOD(SC,10)<>0) THEN PRINT
      PRINT:PRINT SC;" primes found"
      GOTO FIN

      REM *** Exit program if limit exceeded
FER:  PRINT "Limit must be greater than 7 and less than 32,750!"
FIN:  END
