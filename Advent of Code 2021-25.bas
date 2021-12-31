10 REM *****************************************
20 REM *                                       *
30 REM * Advent of code 2021-25: Sea cucumbers *
40 REM *                                       *
50 REM *    Tim Holyoake, 31st December 2021   *
60 REM *                                       *
70 REM *****************************************
80 CLS
90 REM *** Globals
100 REM *** XM = Grid x size
110 REM *** YM = Grid y size
120 REM *** GN = Number of generations
130 REM *** CH = Number of position changes
140 REM *** SB$ = Current sea bed state
180 XM=10:YM=10:GN=0:CH=0
190 DIM SB$(XM-1,YM-1)
200 REM *** Modulo functions for X & Y
210 DEF FNX(V)=V-INT(V/XM)*XM
220 DEF FNY(V)=V-INT(V/YM)*YM
230 GOSUB 290:GOSUB 390
250 GOSUB 490:GOSUB 390
270 IF CH<>0 THEN CH=0:GOTO 250
280 END
290 REM *** Subroutine - set up sea bed grid
300 FOR X=0 TO XM-1
310 FOR Y=0 to YM-1
320 P=INT(RND(1)*3)
330 IF P=0 THEN SB$(X,Y)="."
340 IF P=1 THEN SB$(X,Y)=">"
350 IF P=2 THEN SB$(X,Y)="V"
360 NEXT Y
370 NEXT X
380 RETURN
390 REM *** Subroutine - print sea bed
400 PRINT "Generation";GN;" changes";CH:PRINT
410 FOR Y=0 TO YM-1
420 FOR X=0 TO XM-1
430 PRINT SB$(X,Y);" ";
440 NEXT X
450 PRINT
460 NEXT Y
470 PRINT
480 RETURN
490 REM *** Subroutine - move cucumbers
500 REM *** Rightwards herd moves first
510 GN=GN+1
520 FOR Y=0 TO YM-1
530 FOR X=0 TO XM-1
540 IF NOT((SB$(FNX(X+1),Y)=".") AND (SB$(X,Y)=">")) THEN 560 
550 SB$(FNX(X+1),Y)=">":SB$(X,Y)=".":CH=CH+1:X=X+1
560 NEXT X
570 NEXT Y
580 REM *** Downwards herd second
590 FOR X=0 TO XM-1
600 FOR Y=0 to YM-1
610 IF NOT((SB$(X,FNY(Y+1))=".") AND (SB$(X,Y)="V")) THEN 630 
620 SB$(X,FNY(Y+1))="V":SB$(X,Y)=".":CH=CH+1:Y=Y+1
630 NEXT Y
640 NEXT X
650 RETURN
