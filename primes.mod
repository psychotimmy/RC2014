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

PROCEDURE sieve(number: CARDINAL) :BOOLEAN;
(********************************************************)
(*                                                      *)
(* Sieve of Eratosthenes algorithm - complexity n log n *)
(*                                                      *)
(********************************************************)
VAR sr, count: CARDINAL;
VAR candidatePrime: BOOLEAN;
BEGIN
  (* No need to check past the square root of number *)
  (* being tested to see if it is prime *)
  sr := TRUNC(SQRT(FLOAT(number)));
  count := 1;
  candidatePrime := TRUE;
  (* If the number has no prime divisor already found *)
  (* it may be the next prime to add to our list      *)
  WHILE (count <= primecount) & candidatePrime DO
    IF primearray[count] <= sr THEN
      (* if test below is true, then prime divisor found *)
      (* and so number being tested is not prime         *)
      IF (number MOD primearray[count]) = 0 THEN
        candidatePrime := FALSE
      END
    END;
    INC(count)
  END;
  RETURN candidatePrime
END sieve;

(* Main loop - handles input and output *)
BEGIN
  WriteString('Enter prime number limit - greater than 7, less than 65,536 > ');
  ReadCard(limit);
  WriteLn;
  IF limit > 7 THEN
    primecount := 0;
    next := 11;
    (* Write out the first four primes *)
    WriteCard(2,7);
    WriteCard(3,7);
    WriteCard(5,7);
    WriteCard(7,7);
    sc := 5;
    WHILE next <= limit DO
      (* Ignore odd multiples of 3, 5 and 7 *)
      IF ((next MOD 3) # 0) & ((next MOD 5) # 0) & ((next MOD 7) # 0) THEN
        IF sieve(next) THEN
          (* We have a new prime *)
          IF primecount < PMAX THEN
            (* Add it to our list if there is space *)
            (* so that the sieve function can use   *)
            (* it in future prime divisor tests     *)
            INC(primecount);
            primearray[primecount] := next;
          END;
          (* Write the new prime number just found *)
          WriteCard(next,7);
          (* Print 10 primes per line *)
          IF sc < 10 THEN
            INC(sc)
          ELSE
            sc := 1;
            WriteLn
          END
        END
      END;
      (* Sieve odd numbers only *)
      next := next+2
    END
  ELSE
    WriteString('Limit must be greater than 7!');
    WriteLn
  END;
  WriteLn
END primes.
