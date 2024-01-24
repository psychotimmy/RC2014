MODULE primes;
(************************************************************)
(*                                                          *)
(* Find primes up to input limit - 255 array size ok for    *)
(* 2.7m-ish. Modula-2 implementation.                       *)
(*                                                          *)
(* Tim Holyoake, 24th January 2024.                         *)
(*                                                          *)
(* After Trevor Lusty's BASIC program published in          *)
(* Computing Today, March 1980. This version tested on      *)
(* ftl (HiSoft) Modula-2 1.30 under CP/M 2.2                *)
(*                                                          *)
(************************************************************)
FROM SmallIO IMPORT ReadCard,WriteCard;
FROM Terminal IMPORT WriteString,WriteLn;
FROM Maths IMPORT SQRT;

TYPE PRIMEA = ARRAY [1..255] OF CARDINAL;
VAR primearray: PRIMEA;
VAR sc, limit, next, primecount: CARDINAL;

PROCEDURE sieve(number: CARDINAL; pc: CARDINAL; p: PRIMEA) :BOOLEAN;
(******************************************************************)
(*                                                                *)
(*     Sieve of Eratosthenes algorithm - complexity n log n       *)
(*                                                                *)
(******************************************************************)
VAR t3, t5, t7, t11, t13, sr, count, test: CARDINAL;
VAR foundprime: BOOLEAN;

BEGIN
   (* Remove numbers divisible by low primes for speed here *)
   foundprime := TRUE;
      t3 := 3*TRUNC(FLOAT(number)/3.0);
      t5 := 5*TRUNC(FLOAT(number)/5.0);
      t7 := 7*TRUNC(FLOAT(number)/7.0);
      t11 := 11*TRUNC(FLOAT(number)/11.0);
      t13 := 13*TRUNC(FLOAT(number)/13.0);
      IF (number = t3) OR (number = t5) OR (number = t7) OR
         (number = t11) OR (number = t13) THEN
         foundprime := FALSE
      ELSE
         (* No need to check past the square root of number *)
         (* being tested to see if it is prime *)
         sr := TRUNC(SQRT(FLOAT(number)));
         count := 1;
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
      END;
   RETURN foundprime
END sieve;

(* Main module  - handles input and output *)

BEGIN
   WriteString('Enter prime number limit - greater than 18, less than 65,536 > ');
   ReadCard(limit);
   IF (limit > 18) THEN
      sc := 7;
      primecount := 1;
      primearray[primecount] := 17;
      next := 19;
      WriteString('. 2 3 . 5 . 7 . . . 11 . 13 . . . 17 ');
      WHILE (next <= limit) DO
         IF sieve(next,primecount,primearray) THEN
            (* We have a new prime *)
            IF primecount < 255 THEN
               (* Add it to our list if there is space *)
               (* so that the sieve function can use   *)
               (* it in future prime divisor tests     *)
               primecount := primecount+1;
               primearray[primecount] := next;
            END;
            (* Write out a . for the preceeding multiple of 2, *)
            (* followed by the new prime number just found     *)
            WriteString('. ');
            WriteCard(next,2);
            WriteString(' ');
            (* Don't print too much onto the same line bodge *)
            IF (sc < 7) THEN
              sc := sc+1;
            ELSE
              sc := 1;
              WriteLn;
            END;
         ELSE
            (* Not prime *)
            WriteString('. . ');
         END;
         (* Sieve odd numbers only *)
         next := next+2;
      END;
      WriteLn;
   ELSE
      WriteString('Limit must be greater than 18!');
      WriteLn;
   END;
END primes.
