10 REM ************************************
20 REM *                                  *
30 REM * 'Mastermind' game                *
40 REM * Tim Holyoake, 29th December 2020 *
50 REM *                                  *
60 REM * Guess the correct sequence of 4  *
70 REM * colour pegs to win               *
80 REM *                                  *
90 REM ************************************
100 REM *** Set up number of games played (G)
110 REM *** Average moves per game (M)
120 REM *** Record number of moves (R)
130 REM *** Total moves played in all games (TM)
140 G=0: M=0: R=9999: TM=0
150 CLS
160 REM *** Moves played in this game (CT)
170 CT=0
180 PRINT "Guess the colour of 4 pegs in the right order"
190 PRINT ""
200 PRINT "Peg colours are (r)ed, (g)reen, (b)lue, (p)ink"
210 PRINT "(w)hite and (y)ellow."
220 PRINT ""
300 REM *** Set up the computer's pegs
310 GOSUB 1000
320 REM *** Get the next guess from the player
330 GOSUB 2000
340 REM *** If not a win get the next guess
350 IF W = 0 GOTO 320
360 REM *** We have a winner!
370 PRINT "Congratulations, you won";
380 REM *** Update games played, total moves, average moves
390 G=G+1:TM=TM+CT:M=TM/G
400 REM *** Update record moves if justified
410 IF CT <= R THEN R=CT: PRINT " in a record";R;"moves!!"
420 IF CT > R THEN PRINT " in";CT;"moves"
430 PRINT M;"average moves per game"
440 PRINT G;"games played"
450 PRINT "Play another game"
460 INPUT YN$
470 IF YN$="y" OR YN$="yes" THEN GOTO 150
480 PRINT "Bye!"
999 END
1000 REM *** Subroutine: Set up the computer's pegs
1010 REM *** Gives each peg one of 6 different colours
1020 REM *** from 1 to 6
1030 REM *** 1 = red, 2 = blue, 3 = yellow
1040 REM *** 4 = green, 5 = white, 6 = pink
1050 C1=INT(RND(1)*6)+1
1060 C2=INT(RND(1)*6)+1
1070 C3=INT(RND(1)*6)+1
1080 C4=INT(RND(1)*6)+1
1999 RETURN
2000 REM *** Subroutine: Get the next guess from the player
2010 PRINT "Enter your four colour guess"
2020 INPUT A$,B$,C$,D$
2030 P1=0:P2=0:P3=0:P4=0
2040 IF LEFT$(A$,1)="r" THEN P1=1
2050 IF LEFT$(A$,1)="b" THEN P1=2
2060 IF LEFT$(A$,1)="y" THEN P1=3
2070 IF LEFT$(A$,1)="g" THEN P1=4
2080 IF LEFT$(A$,1)="w" THEN P1=5
2090 IF LEFT$(A$,1)="p" THEN P1=6
2100 IF LEFT$(B$,1)="r" THEN P2=1
2110 IF LEFT$(B$,1)="b" THEN P2=2
2120 IF LEFT$(B$,1)="y" THEN P2=3
2130 IF LEFT$(B$,1)="g" THEN P2=4
2140 IF LEFT$(B$,1)="w" THEN P2=5
2150 IF LEFT$(B$,1)="p" THEN P2=6
2160 IF LEFT$(C$,1)="r" THEN P3=1
2170 IF LEFT$(C$,1)="b" THEN P3=2
2180 IF LEFT$(C$,1)="y" THEN P3=3
2190 IF LEFT$(C$,1)="g" THEN P3=4
2200 IF LEFT$(C$,1)="w" THEN P3=5
2210 IF LEFT$(C$,1)="p" THEN P3=6
2220 IF LEFT$(D$,1)="r" THEN P4=1
2230 IF LEFT$(D$,1)="b" THEN P4=2
2240 IF LEFT$(D$,1)="y" THEN P4=3
2250 IF LEFT$(D$,1)="g" THEN P4=4
2260 IF LEFT$(D$,1)="w" THEN P4=5
2270 IF LEFT$(D$,1)="p" THEN P4=6
2280 REM *** Check exact matches (EX and M<n>), increment moves
2290 EX=0: M1=0: M2=0: M3=0: M4=0: W=0
2300 CT=CT+1
2310 IF C1=P1 THEN EX = EX+1: M1 = 1
2320 IF C2=P2 THEN EX = EX+1: M2 = 1
2330 IF C3=P3 THEN EX = EX+1: M3 = 1
2340 IF C4=P4 THEN EX = EX+1: M4 = 1
2350 REM *** Four exact matches = game won
2360 IF EX=4 THEN W=1: GOTO 2999
2370 REM *** Check for correct colour, wrong order
2380 NR=0
2390 IF (M1=0)AND(C1=P2 OR C1=P3 OR C1=P4) THEN NR=NR+1
2400 IF (M2=0)AND(C2=P1 OR C2=P3 OR C2=P4) THEN NR=NR+1
2410 IF (M3=0)AND(C3=P1 OR C3=P2 OR C3=P4) THEN NR=NR+1
2420 IF (M4=0)AND(C4=P1 OR C4=P2 OR C4=P3) THEN NR=NR+1
2980 REM *** Report the result
2990 PRINT EX;"exact matches and";NR;"right colour, wrong place"
2999 RETURN
