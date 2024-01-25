MODULE primes;
(************************************************************)
(*                                                          *)
(* Find primes up to input limit - Modula-2 implementation. *)
(*                                                          *)
(* Tim Holyoake, 25th January 2024.                         *)
(*                                                          *)
(* After Trevor Lusty's BASIC program published in          *)
(* Computing Today, March 1980. This version tested on      *)
(* FTL (HiSoft) Modula-2 1.30 under CP/M 2.2                *)
(*                                                          *)
(************************************************************)
FROM SmallIO IMPORT ReadCard,WriteCard;
FROM Terminal IMPORT WriteString,WriteLn;
FROM Maths IMPORT SQRT;

CONST PMAX = 256;
TYPE PRIMEA = ARRAY [1..PMAX] OF CARDINAL;
VAR primearray: PRIMEA;
VAR sc, limit, next, primecount: CARDINAL;

PROCEDURE sieve(number: CARDINAL; pc: CARDINAL; p: PRIMEA) :BOOLEAN;
(******************************************************************)
(*                                                                *)
(*     Sieve of Eratosthenes algorithm - complexity n log n       *)
(*                                                                *)
(******************************************************************)
VAR t3, sr, count, test: CARDINAL;
VAR foundprime: BOOLEAN;

BEGIN
  (* No need to check past the square root of number *)
  (* being tested to see if it is prime *)
  sr := TRUNC(SQRT(FLOAT(number)));
  count := 1;
  foundprime := TRUE;
  (* If the number has no prime divisor already found *)
  (* it may be the next prime to add to our list      *)
  WHILE ((count <= pc) & (foundprime)) DO
    test := p[count];
    IF (test <= sr) THEN
      (* if test below is true, then prime divisor found *)
      (* and so number being tested is not prime         *)
      t3 := TRUNC((FLOAT(number)/FLOAT(test)));
      t3 := t3*test;
      IF (number = t3) THEN
        foundprime := FALSE;
      END;
    END;
    count := count+1;
  END;
  RETURN foundprime
END sieve;

(* Main loop - handles input and output *)
BEGIN
   WriteString('Enter prime number limit - greater than 3, less than 65,536 > ');
   ReadCard(limit);
   WriteLn;
   IF (limit > 3) THEN
      primecount := 0;
      next := 3;
      (* Write out the first prime *)
      WriteCard(2,7);
      sc := 2;
      WHILE (next <= limit) DO
         IF sieve(next,primecount,primearray) THEN
            (* We have a new prime *)
            IF primecount < PMAX THEN
               (* Add it to our list if there is space *)
               (* so that the sieve function can use   *)
               (* it in future prime divisor tests     *)
               primecount := primecount+1;
               primearray[primecount] := next;
            END;
            (* Write the new prime number just found *)
            WriteCard(next,7);
            (* Print 10 primes per line *)
            IF (sc < 10) THEN
              sc := sc+1;
            ELSE
              sc := 1;
              WriteLn;
            END;
         END;
         (* Sieve odd numbers only *)
         next := next+2;
      END;
   ELSE
      WriteString('Limit must be greater than 3!');
      WriteLn;
   END;
   WriteLn;
END primes.
