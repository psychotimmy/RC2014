10 REM ** The Valley for MBASIC 5.21 under CP/M, RC2014 or RC2040
11 REM ** Based on the game published April 1982 in Computing Today 
12 REM ** All rights of the original authors gratefully acknowledged
13 REM ** 
14 REM ** Re-implemented in April 2024 by Tim Holyoake
15 REM **
16 REM ** Run game using MBASIC VALLEY2.BAS /M:55000 /F:1 (with TM=5 to 10 on line 110)
17 REM ** Location 62001 (TL) & onwards are used for storing the virtual valley screen
18 REM **
21 REM ** Useful screen handling parameters & codes
24 CLEAR:TL=62001!    : REM ** Top left corner screen memory location (single precision required as > 32767)
26 SW=40              : REM ** Playing area (valley, swamps & woods) in columns
28 SL=12              : REM ** Lines used by playing areas
30 ST=20              : REM ** Columns in castle playing areas
32 LF$=CHR$(10)       : REM ** Line feed
34 CS$=CHR$(27)+"[2J" : REM ** Clear screen & home
36 CH$=CHR$(27)+"[H"  : REM ** Cursor home (non-destructive)
38 PRINT CS$:PRINT SPC(23);"The Valley (c)1982 Computing Today":PRINT 
40 PRINT SPC(20);"RC2014 CP/M version (c)2024 Tim Holyoake":PRINT:PRINT:GOSUB 1600: REM ** Anykey
42 PRINT:PRINT "Select terminal type" :PRINT
44 PRINT "Standard VT100 (80x24) ...................... (1)"
46 PRINT "PicoTerm VT100 + PetSCII graphics (80x30) ... (2)"
48 PRINT "PicoTerm VT100 + Code Page 437 (80x30) ...... (3)":VG$="123":REM ** Keyboard mask for Uniget
50 GOSUB 1500:TT%=VAL(GC$):REM ** Uniget
54 REM ** PetSCII graphics mode ON if TT%=2
56 IF TT%=2 THEN PRINT CHR$(27)+"F" ELSE PRINT
58 PRINT "Initialising game, please wait .";
60 REM ** DD$ holds 1 to 25 cursor down codes. Note RIGHT$ trims leading blank on int to str conversion
62 DIM DD$(25):FOR I%=1 TO 25:DD$(I%)=CHR$(27)+"[":DD$(I%)=DD$(I%)+RIGHT$(STR$(I%),LEN(STR$(I%))-1):DD$(I%)=DD$(I%)+"B":NEXT I%
64 REM ** RR$ holds 1 to 45 cursor right codes
66 DIM RR$(45):FOR I%=1 TO 45:RR$(I%)=CHR$(27)+"[":RR$(I%)=RR$(I%)+RIGHT$(STR$(I%),LEN(STR$(I%))-1):RR$(I%)=RR$(I%)+"C":NEXT I%
68 REM ** UU$ holds 2 cursor up codes
70 DIM UU$(2):FOR I%=1 TO 2:UU$(I%)=CHR$(27)+"[":UU$(I%)=UU$(I%)+RIGHT$(STR$(I%),LEN(STR$(I%))-1):UU$(I%)=UU$(I%)+"A":NEXT I%:PRINT "."; 
75 REM ** User defined functions
76 DEF FNRT(I%)=INT(.067*(EX+TS/3)^.5+LOG(EX/((TN%+1)^1.5))): REM ** Rating calculation 
90 VK$="0123456789EUIOJKL": REM ** Default keyboard input mask for Uniget
99 REM ** Define major array variables
100 DIM D(3),G(75),P(8),N(8),S(4),T(2),MA%(18),WI(1,4),M$(18),MS(18),N1(18),RT$(28)
108 REM ** TM affects timings for delay (36000) & combat get (1700)
109 REM ** A value of 5-10 is good (lower = more difficult)
110 TM=8
120 DL$="":TS=0:TN%=0:CF=0:UE%=0:UB%=0:UR%=0:SU%=0
130 REM ** Set up status area positioning & blanking strings
140 IF TT%=1 THEN D$=CH$+RR$(1)+DD$(20) ELSE D$=CH$+RR$(1)+DD$(23):REM ** Scratchpad top - Cursor Home + 1 right + 20/23 down
150 IF TT%=1 THEN DM$=CH$+RR$(1)+DD$(19) ELSE DM$=CH$+RR$(1)+DD$(21):REM ** Monster power - Cursor Home + 1 right + 19/21 down
160 SP$=SPACE$(39):PRINT ".";
299 REM ** Skip scene data
300 FOR I%=1 TO 32:READ C$:NEXT I%:PRINT ".";
309 REM ** Load monster data
310 FOR I%=0 TO 18:READ M$(I%),MS(I%),N1(I%):NEXT I%:PRINT ".";
319 REM ** Load ratings data
320 FOR I%=0 TO 28:READ RT$(I%):NEXT I%:PRINT ".";
329 REM ** Load scenario date depending on screen type (V=Valley, W=Woods & Swamps, Y=Castles)
330 IF TT%=1 THEN GOTO 400:REM ** 1 - Standard 80x24 VT100, 2 - PicoTerm 80x30 PetSCII, 3 - PicoTerm 80x30 CP437
340 FOR I%=1 TO 18:READ VC%:NEXT I%:REM ** Skip Terminal type 1 data
350 IF TT%=2 THEN GOTO 400
360 FOR I%=1 TO 18:READ VC%:NEXT I%:REM ** Skip Terminal type 2 data
400 READ VC%                 :REM ** Character's code for all scenarios
410 READ VB%,VX%,VU%,VD%     :REM ** Valley borders, safe castle, path up, path down
420 READ VW%,VS%,VV%         :REM ** Valley woods, swamps, black tower
430 READ WB%,WL%,WC%,WW%,WG% :REM ** Woods/Swamps border, lake, castle. Woods tree, Swamp tufts
440 READ YW%,YS%,YD%,YF%     :REM ** Castle border & walls, stairs, doorway, treasure
450 READ SP%                 :REM ** Blank/space code for all scenarios 
799 REM ** Blank virtual screen, then compute border, valley path & scenario positions
800 GOSUB 58000:GOSUB 56310:PRINT " done.":DF%=100:DL$="D":GOSUB 36000:GOSUB 56100:REM ** Opening
999 REM ** Character choice & load
1000 PRINT:PRINT "Load your character from disk (VALCHAR.DAT) (Y/N) ?"
1010 VG$="YN":GOSUB 1500:VG$=VK$: REM ** Uniget Y/N & reset keyboard input mask
1020 IF GC$="N" GOTO 1160
1030 PRINT CS$;"Loading character from disk ...";
1040 FI$="VALCHAR.DAT":OPEN "I",1,FI$
1060 INPUT#1,J$:INPUT#1,P$:INPUT#1,TS:INPUT#1,EX:INPUT#1,TN%:INPUT#1,CS%:INPUT#1,PS%:INPUT#1,T(0):INPUT#1,T(1):INPUT#1,T(2):INPUT#1,C1%:INPUT#1,P1%
1099 REM ** Extended data input
1100 INPUT#1,UR%:INPUT#1,UB%:FOR I%=0 TO 18:INPUT#1,MA%(I%):NEXT I%:CLOSE 1
1150 PRINT " load complete.":C=150:GOTO 1400
1160 PRINT CS$:INPUT "Character's name ";J$
1170 IF J$="" GOTO 1160
1180 IF LEN(J$)>16 THEN PRINT "Name is too long (less than or equal to 16 characters)":DF%=150:DL$="D":GOSUB 36000:GOTO 1160
1240 PRINT CS$;LF$;"Character types ... choose carefully":PRINT:PRINT "Wizard     (1)":PRINT "Thinker    (2)"
1280 PRINT "Barbarian  (3)","Key 1-5":PRINT "Warrior    (4)":PRINT "Cleric     (5)"
1310 GOSUB 1500:A%=VAL(GC$):REM ** Uniget
1330 IF A%=1 THEN P$="Wizard":P1%=2:C1%=.5:CS%=22:PS%=28
1340 IF A%=2 THEN P$="Thinker":P1%=1.5:C1%=.75:CS%=24:PS%=26
1350 IF A%=3 THEN P$="Barbarian":P1%=.5:C1%=2:CS%=28:PS%=22
1360 IF A%=4 THEN P$="Warrior":P1%=1:C1%=1.25:CS%=26:PS%=24
1370 IF A%=5 THEN P$="Cleric":P1%=1.25:C1%=1:CS%=25:PS%=25
1380 IF A%<1 OR A%>5 THEN P$="Dolt":P1%=1:C1%=1:CS%=20:PS%=20
1390 EX=5:C=150
1400 PRINT LF$;"Good luck":PRINT LF$;J$;" the ";P$
1420 DF%=150:DL$="D":GOSUB 36000: REM ** Delay
1430 IV%=1:GOSUB 10000:REM ** Initial valley draw flagged by IV%
1440 DF%=5:GOSUB 36000:REM ** Delay & update
1450 GOTO 2000:REM ** Movement
1499 REM ** Uniget routine
1500 GC$=INKEY$:IF LEN(GC$) > 0 GOTO 1520
1510 GOTO 1500
1519 REM ** Convert lower to upper case
1520 IF ASC(GC$)>96 AND ASC(GC$)<123 THEN GC$=CHR$(ASC(GC$)-32)
1530 FOR I%=1 TO LEN(VG$):IF MID$(VG$,I%,1)=GC$ THEN RETURN ELSE NEXT I%
1540 GOTO 1500
1599 REM ** Anykey routine
1600 PRINT "** Press any key to continue **"
1610 TI%=INT(RND(1)*10000):GC$=INKEY$:IF LEN(GC$) > 0 THEN RETURN
1620 GOTO 1610
1699 REM ** Combat get routine
1700 TV%=0:FOR I%=1 TO 10:GC$=INKEY$:NEXT I%:REM ** Flush kbd buffer
1710 FOR I=1 TO 72*TM:GC$=INKEY$:IF LEN(GC$) > 0 GOTO 1750 ELSE NEXT I
1740 TV%=1:REM ** No key pressed
1750 PRINT D$;SP$:REM ** Wipe away message
1760 IF LEN(GC$) = 0 GOTO 1790: REM ** Can't use ASC/CHR$ on empty string
1770 REM ** Convert lower to upper case
1780 IF ASC(GC$)>96 AND ASC(GC$)<123 THEN GC$=CHR$(ASC(GC$)-32)
1790 RETURN
1999 REM ** Movement routine
2000 M=W:PK%=PEEK(W):POKE M,VC%:Q%=VC%:GOSUB 57100
2010 C=C+10
2020 IF PK%=VU% OR PK%=VD% GOTO 2040
2030 PRINT D$;"Your move...which direction ?":GOTO 2060
2040 PRINT D$;"Safe on the path...which way?":FOR I = 1 TO 10:GC$=INKEY$:NEXT I: REM ** Clear kbd buffer
2060 GOSUB 1500:IF GC$="E" GOTO 45000:  REM ** Ego
2061 REM ** Map UIOJKL keys to 456123 keys respectively
2065 IF GC$="U" THEN GC$="4" ELSE IF GC$="I" THEN GC$="5" ELSE IF GC$="O" THEN GC$="6" ELSE IF GC$="J" THEN GC$="1" ELSE IF GC$="K" THEN GC$="2" ELSE IF GC$="L" THEN GC$="3"
2069 REM ** Special routine for numeric keypads
2070 A%=VAL(GC$):IF A%=0 GOTO 2060
2080 IF A%>3 THEN A%=A%-3:GOTO 2080
2090 W=M+A%-2-SW*(INT((VAL(GC$)-1)/3)-1)
2100 TN%=TN%+1:PRINT D$;SP$
2109 REM ** Am I stepping on something ?
2110 Q%=VC%:Q1%=PEEK(W):IF Q1%=SP% OR Q1%=WG% GOTO 2190
2120 IF Q1%=VX% GOTO 48000:REM ** Quit
2130 IF Q1%=VB% OR Q1%=YW% OR Q1%=WW% THEN TN%=TN%-1:GOTO 2030:REM ** Wall or Tree
2140 IF Q1%=VW% OR Q1%=VV% OR Q1%=VS% OR Q1%=WC% GOTO 9000:REM ** Scene entry
2150 IF Q1%=YD% OR Q1%=WB% GOTO 9090:REM Scene exit
2160 IF Q1%=YS% GOTO 15000:REM ** Stairs
2170 IF Q1%=WL% OR (GC$="5" AND PK%=WL%) THEN Q%=VC%:C=C-20:IF C<=0 GOTO 55000
2180 IF Q1%=YF% GOTO 2800:REM ** Special find
2190 POKE M,PK%:GOSUB 57200:PK%=PEEK(W):M=W:POKE M,Q%:GOSUB 57100:REM ** Update character pos
2200 IF PK%=VU% OR PK%=VD% OR PK%=WG% THEN DF%=5:GOTO 2250: REM ** tufts are safe
2209 REM ** Nothing, monster or find?
2220 RF%=RND(1):IF RF%<.33 GOTO 3000: REM ** Monster selection
2230 IF RF%>.75 GOTO 2300: REM ** A find!
2240 PRINT D$;"Nothing of value...search on":DF%=80
2250 GOSUB 36000:REM ** Delay & update
2260 GOTO 2010
2299 REM ** Finds subroutine
2300 RF%=INT(RND(1)*6+1):ON RF% GOSUB 2340,2380,2380,2410,2410,2440
2320 DF%=80:GOSUB 36000:REM ** Delay & update
2330 GOTO 2010
2340 PRINT D$;"A circle of evil...depart in haste !"
2341 REM ** Original code increases CS in a circle of evil (!)
2350 CS%=CS%-INT((FL%+1)/2):PS%=PS%-INT((FL%+1)/2):C=C-20
2360 IF C<=0 GOTO 55000: REM ** Death
2370 RETURN
2380 PRINT D$;"A hoard of gold"
2390 TS=TS+INT(FL%*RND(1)*100+100)
2400 RETURN
2410 PRINT D$;"You feel the aura of the deep magic..."
2420 PRINT SPC(8);"...all around you..."
2430 GOTO 2450
2440 PRINT D$;"...A place of ancient power..."
2450 PS%=PS%+2+INT(FL%*P1%):CS%=CS%+1+INT(FL%*C1%):C=C+25
2460 RETURN
2799 REM ** Special finds subroutine
2800 PK%=SP%:POKE M,PK%:GOSUB 57200:M=W:Q%=VC%:POKE M,Q%:GOSUB 57100
2810 RN=RND(1):PRINT D$;SP$
2820 IF S=6 AND RN>.95 AND T(1)=6 AND T(2)=0 AND RT>25 THEN T(2)=1:GOTO 2870
2830 IF S=5 AND RN>.85 AND T(0)=0 THEN T(0)=1:GOTO 2880
2840 IF S=4 AND RN>.7 AND T(0)=1 AND T(1)<6 AND FL%>T(1) GOTO 2890
2850 IF RN>.43 THEN PRINT D$;"A worthless bauble":GOTO 2940
2860 PRINT D$;"A precious stone !           ":GOTO 2930
2870 PRINT D$;"You find the Helm of Evanna !":GOTO 2930
2880 PRINT D$;"The amulet of Alarian...empty...":GOTO 2930
2890 PRINT D$;"An amulet stone...           ":PRINT
2900 DF%=60:DL$="D":GOSUB 36000:REM ** Delay
2910 IF RN>.85 THEN PRINT "...but the wrong one !       ":GOTO 2940
2920 PRINT "...the stone fits !         ":T(1)=T(1)+1
2930 TS=TS+100*(T(0)+T(1)+T(2)+FL%)
2940 DF%=80:GOSUB 36000:REM ** Delay & update
2950 GOTO 2010
2999 REM ** Monster selection subroutine
3000 PRINT D$;"** Beware...thou hast encountered **"
3010 MS=0:N=0:CF=1:UE%=1:UB%=UB%+1
3020 RF%=INT(RND(1)*17):IF RF%>9 AND RND(1)>.85 GOTO 3020
3030 IF Q1%=WL% OR PK%=WL% THEN RF%=INT(RND(1)*2+17)
3040 IF RF%=16 AND RND(1)<.7 GOTO 3020
3050 IF FL%<5 AND RF%=15 GOTO 3020
3060 X$=LEFT$(M$(RF%),1)
3070 FOR I%=1 TO LEN(F$)
3080 IF MID$(F$,I%,1)=X$ GOTO 3110
3090 NEXT I%
3100 GOTO 3020
3110 M$=RIGHT$(M$(RF%),LEN(M$(RF%))-1)
3115 MA%(RF%)=MA%(RF%)+1:REM ** Update extended data
3120 IF MS(RF%)=0 GOTO 3150
3130 MS=INT((CS%*.3)+MS(RF%)+FL%^.2/(RND(1)+1))
3140 IF N1(RF%)=0 GOTO 3160
3150 N=INT(N1(RF%)*FL%^.2/(RND(1)+1))
3160 U=INT((RF%+1)*(FL%^1.5))
3170 IF RF%>23 THEN U=INT((RF%-22)*FL%^1.5)
3180 PRINT RR$(13-INT(LEN(M$)/2));:PRINT "An evil ";M$
3190 DF%=40:GOSUB 36000:REM ** Delay & update
3499 REM ** Character's combat subroutine
3500 IF RND(1)<.6 GOTO 4000:REM ** Monster's combat
3510 PRINT D$;"You have surprise...Attack or Retreat"
3520 GOSUB 1700:REM ** Combat get
3530 IF GC$="R" GOTO 3900
3540 IF TV%=1 GOTO 3600
3550 IF GC$<>"A" GOTO 4000
3560 DF%=30:DL$="D":GOSUB 36000
3570 PRINT D$;"*** Strike quickly ***"
3580 GOSUB 1700:REM ** Combat get
3590 IF TV%=0 GOTO 3620
3600 PRINT D$;"* Too slow...Too slow *"
3610 HF%=0:GOTO 3830
3620 E=39*LOG(EX)/3.14
3630 IF GC$="S" GOTO 4500:REM ** Spell control
3640 IF MS=0 THEN PRINT D$;"Your sword avails you nought here":GOTO 3830
3650 C=C-1
3660 IF C<=0 THEN PRINT D$;"You fatally exhaust yourself     ":GOTO 55000
3670 RF%=RND(1)*10
3680 IF GC$="H" AND (RF%<5 OR CS%>MS*4) THEN Z%=2:GOTO 3730
3690 IF GC$="B" AND (RF%<7 OR CS%>MS*4) THEN Z%=1:GOTO 3730
3700 IF GC$="L" AND (RF%<9 OR CS%>MS*4) THEN Z%=.3:GOTO 3730
3710 PRINT D$;"You missed it !":HF%=0:GOTO 3830
3730 IF HF%=1 THEN D=MS+INT(RND(1)*9):HF%=0:GOTO 3760
3740 D=INT((((CS%*50*RND(1))-(10*MS)+E)/100)*Z%):IF D<0 THEN D=0
3750 IF CS%>(MS-D)*4 THEN HF%=1
3760 MS=MS-D:PRINT D$;"A hit...":DF%=60:DL$="D":GOSUB 36000:REM ** Delay
3790 IF D=0 THEN PRINT D$;RR$(8);"but...no damage":HF%=0:GOTO 3830
3800 PRINT D$;RR$(8);D;" damage":IF MS<=0 GOTO 3860:REM ** Dead monster
3810 IF HF%=1 THEN DF%=30:DL$="D":GOSUB 36000
3820 IF HF%=1 THEN PRINT " The ";M$;" staggers defeated"
3830 DF%=110:GOSUB 36000
3840 IF HF%=1 GOTO 3570
3850 GOTO 4000:REM ** Monster's combat
3860 PRINT D$;LF$;" ...killing the monster..."
3870 EX=EX+U:HF%=0:CF=0
3880 DF%=80:GOSUB 36000
3890 GOTO 2010:REM ** Movement
3900 PRINT D$;"Knavish coward !":CF=0
3905 UR%=UR%+1: REM ** Extended data - update retreat count
3906 MA%(RF%)=MA%(RF%)-1: REM ** Extended data - didn't fight!
3907 UB%=UB%-1: REM ** Didn't fight!
3910 GOTO 3880
3999 REM ** Monster's combat subroutine
4000 PRINT D$;"The creature attacks..."
4010 DF%=50:DL$="W":GOSUB 36000:REM ** Delay & wipe
4020 IF MS=0 GOTO 4300:REM ** Psionic attack
4030 IF MS<N AND N>6 AND RND(1)<.5 GOTO 4300
4040 MS=MS-1:IF MS<=0 GOTO 4240
4050 RF%=INT(RND(1)*10+1)
4060 ON RF% GOTO 4070,4080,4090,4100,4110,4110,4120,4120,4130,4140
4070 PRINT D$;"It swings at you...and misses  ":GOTO 4280
4080 PRINT D$;"Your blade deflects the blow   ":GOTO 4280
4090 PRINT D$;"...but hesitates, unsure...    ":GOTO 4280
4100 Z%=3:PRINT D$;"It strikes your head !     ":GOTO 4150
4110 Z%=1.5:PRINT D$;"Your chest is struck !   ":GOTO 4150
4120 Z%=1:PRINT D$;"A strike to your swordarm !":GOTO 4150
4130 Z%=1.3:PRINT D$;"A blow to your body !    ":GOTO 4150
4140 Z%=.5:PRINT D$;"It catches your legs !   "
4150 DF%=60:DL$="D":GOSUB 36000
4160 G=INT((((MS*75*RND(1))-(10*CS%)-E)/100)*Z%)
4170 IF G<0 THEN G=0:PRINT D$;"...saved by your armour !    ":GOTO 4280
4180 C=C-G
4190 IF G>9 THEN CS%=INT(CS%-G/6)
4200 IF G=0 THEN PRINT D$;"Shaken......but no damage done":GOTO 4280
4210 PRINT D$;"You take...          ";G;" damage..."
4220 IF CS%<=0 OR C<=0 GOTO 55000:REM ** Death
4230 GOTO 4280
4240 PRINT D$;"...using its last energy in the attempt"
4250 EX=INT(EX+U/2):CF=0
4260 DF%=100:GOSUB 36000
4270 GOTO 2010:REM ** Movement
4280 DF%=100:GOSUB 36000
4290 GOTO 3570:REM ** Character's combat
4299 REM ** Monster's psionic attack
4300 PRINT D$;"...hurling a lightning bolt at you !    "
4310 G=INT(((180*N*RND(1))-(PS%+E))/100):N=N-5:IF G>9 THEN N=N-INT(G/5)
4320 DF%=80:DL$="W":GOSUB 36000
4330 IF N<=0 THEN N=0:GOTO 4240
4340 IF RND(1)<.25 GOTO 4410
4350 IF G<=0 THEN G=0:GOTO 4400
4360 PRINT D$;"It strikes home !     "
4370 DF%=110:GOSUB 36000
4380 C=C-G:IF G>9 THEN PS%=INT(PS%-G/4)
4390 GOTO 4210
4400 PRINT D$;"Your psi shield protects you":GOTO 4280
4410 PRINT D$;"...missed you !";SPC(12);" ":GOTO 4280
4499 REM ** Spell control subroutine
4500 PRINT D$;"Which spell seek ye ? ":GOSUB 1700:REM ** Combat get
4510 IF TV%=1 GOTO 3600:REM ** Too slow
4520 IF VAL(GC$)>0 AND VAL(GC$)<4 GOTO 4540
4530 PRINT D$;"No such spell...";SPC(4);" ":GOTO 4640
4540 IF 4*PS%*RND(1)<=N GOTO 4590
4550 ON VAL(GC$) GOSUB 5000,5200,5400
4559 REM ** SC contains outcome flag
4560 ON SC GOTO 4620,4640,4660,4570,4600,4580,4590
4570 PRINT D$;"It is beyond you";SPC(7);" ":GOTO 4640
4580 PRINT D$;"But the spell fails... !":GOTO 4640
4590 PRINT D$;"No use, the beast's psi shields it":GOTO 4640
4600 PRINT D$;"The spell saps all your strength"
4610 GOTO 55000:REM ** Death
4620 DF%=100:GOSUB 36000
4630 GOTO 2010:REM ** Movement
4640 DF%=60:GOSUB 36000
4650 GOTO 4000:REM ** Monster's combat
4660 DF%=60:GOSUB 36000
4670 GOTO 3570:REM ** Character's combat
4999 REM ** Spell 1 - Sleepit
5000 C=C-5:IF C<=0 THEN SC=5:RETURN
5010 PRINT D$;"Sleep you foul fiend that I may escape"
5020 PRINT " and preserve my miserable skin"
5030 DF%=180:GOSUB 36000
5040 PRINT D$;"The creature staggers..."
5050 DF%=40:DL$="D":GOSUB 36000
5060 IF RND(1)<.5 GOTO 5090
5070 PRINT " and collapses...stunned"
5080 EX=INT(EX+U/2):CF=0:SC=1:RETURN
5090 PRINT " but recovers with a snarl !"
5100 SC=2:RETURN
5199 REM ** Spell 2 - Psi lance
5200 IF MS>C OR PS%<49 OR EX<1000 THEN SC=4:RETURN
5210 C=C-10:IF C<=0 THEN SC=5:RETURN
5220 IF N=0 THEN PRINT D$;"This beast has no psi to attack":SC=2:RETURN
5230 PRINT D$;"With my mind I battle thee for my life"
5240 DF%=180:GOSUB 36000
5250 RF%=RND(1):IF RF%<.4 AND N>10 THEN SC=6:RETURN
5260 D=INT((((CS%*50*RF%)-5*(MS+N)+E)/50)/4)
5270 IF D<=0 THEN D=0:SC=7:RETURN
5280 PRINT D$;"The lance saps";D*3;"psi causing";D;"damage"
5290 N=N-3*D:IF N<=0 THEN N=0
5300 MS=MS-D:IF MS<=0 THEN MS=0
5305 DF%=80:DL$="D":GOSUB 36000
5310 IF (MS+N)>0 THEN SC=2:RETURN
5320 PRINT " ...killing the creature  "
5330 EX=EX+U:CF=0:SC=1:RETURN
5399 REM ** Spell 3 - Crispit
5400 IF PS%<77 OR EX<5000 THEN SC=4:RETURN
5410 C=C-20:IF C<=0 THEN SC=5:RETURN
5420 PRINT D$;"With the might of my sword I smite thee"
5430 PRINT " With the power of my spell I curse thee":PRINT " Burn ye spawn of hell and suffer..."
5450 DF%=240:GOSUB 36000
5460 PRINT D$;"A bolt of energy lashes at the beast..."
5470 DF%=120:DL$="W":GOSUB 36000
5480 IF RND(1)>(PS%/780)*(5*P1%)THEN PRINT D$;"Missed it !":SC=2:RETURN
5490 D=INT((CS%+PS%*RND(1))-(10*N*RND(1)))
5500 IF D<=0 THEN D=0:SC=7:RETURN
5510 IF MS=0 THEN N=N-D:GOTO 5530
5520 MS=MS-D:IF D>10 THEN N=INT(N-(D/3))
5530 PRINT D$;"It strikes home causing ";D;" damage  !"
5540 IF (MS+N)<0 GOTO 5570
5550 DF%=80:DL$="D":GOSUB 36000
5560 SC=2:RETURN
5570 PRINT:PRINT " The beast dies screaming !"
5580 EX=EX+U:CF=0:SC=1:RETURN
8999 REM ** Scenario control subroutine
9000 IF Q1%=WC% AND PK%=WL% THEN PRINT D$;"You cannot enter this way.":GOTO 9110
9010 FOR I%=2 TO 7
9020 P(I%)=0
9030 N(I%)=INT(RND(1)*5+4)
9040 IF N(I%)=5 GOTO 9030
9050 NEXT I%
9060 IF S=1 THEN MP=M
9070 P(2)=INT(RND(1)*30+1)
9080 TF%=TN%:GOTO 9130
9089 REM ** Exit from scenario
9090 IF TN%>TF%+INT(RND(1)*6+1) GOTO 9130
9100 PRINT D$;"The way is barred"
9110 TN%=TN%-1:C=C-10:DF%=100:DL$="W":GOSUB 36000
9120 GOTO 2010
9129 REM ** Scenario exits
9130 C=C-10:POKE M,SP%:POKE W,Q%:GOSUB 57300: REM ** Draw scenario exit
9140 IF Q1%=WB% THEN S=1:FL%=1
9150 IF Q1%=YD% AND S=4 THEN S=1:FL%=1
9160 IF Q1%=YD% AND S=5 OR S=6 THEN S=S-3:FL%=FL%-4:M=MW
9170 IF Q1%=VS% THEN S=2:FL%=2
9180 IF Q1%=VW% THEN S=3:FL%=3
9190 I=INT(RND(1)*7)+1:IF Q1%=VW% OR Q1%=VS% THEN D2=I:R2=P(2)
9200 IF Q1%=VV% THEN S=4:FL%=2
9210 IF Q1%=WC% THEN S=S+3:FL%=FL%+4:MW=M
9220 ON S GOSUB 10000,12000,12010,14000,14010,14010
9230 DF%=5:GOSUB 36000
9240 GOTO 2000:REM ** Movement
9999 REM ** Scenario 1 - The Valley
10000 PRINT CS$:F$="VAEGH":FL%=1:S=1
10010 IF IV%=1 THEN IV%=0:GOTO 10280: REM ** If initial draw only
10020 GOSUB 58000: REM ** Reset playing area to spaces
10029 REM ** Draw valley frame
10030 FOR I%=0 TO SW-1:POKE TL+I%,VB%:POKE TL+((SL+1)*SW)+I%,VB%:NEXT I%
10040 FOR I%=1 TO SL:POKE TL+(I%*SW),VB%:POKE TL+(I%*SW)+SW-1,VB%:NEXT I%
10189 REM ** Plot in path
10190 FOR I%=0 TO 74 STEP 2:POKE G(I%),G(I%+1):NEXT I%
10279 REM ** Plot in scenarios
10280 POKE S(0),VW%:POKE S(0)+1,VW%:POKE S(1),VW%:POKE S(1)+1,VW%
10290 POKE S(2),VS%:POKE S(2)+1,VS%:POKE S(3),VS%:POKE S(3)+1,VS%
10300 POKE S(4),VV%
10305 UE%=1:GOSUB 57000:GOSUB 40000:PRINT D$:REM ** Print valley to VT100
10310 M=MP:W=M
10320 RETURN
11999 REM ** Scenario 2 - Woods & Swamps
12000 F$="AFL":PC=WG%:GOTO 12020
12010 F$="FAEHL":PC=WW%
12020 PK%=SP%
12030 GOSUB 58000:PRINT CS$
12039 REM ** Draw random woods or swamps
12050 FOR I%=1 TO 80:UY=INT(RND(1)*SL)+1:UX=INT(RND(1)*(SW-2))+1:POKE(TL+(UY*SW)+UX),PC:NEXT I%
12079 REM ** Poke in the lake to the virtual screen
12080 POKE TL+(D2*SW)+R2+2,WL%:POKE TL+(D2*SW)+R2+3,WL%:FOR I%=1 TO 5:POKE TL+((D2+1)*SW)+R2+I%,WL%:NEXT I%
12100 POKE TL+((D2+2)*SW)+R2,WL%:POKE TL+((D2+2)*SW)+R2+1,WL%:POKE TL+((D2+2)*SW)+R2+2,SP%:POKE TL+((D2+2)*SW)+R2+3,SP%
12110 POKE TL+((D2+2)*SW)+R2+4,WL%:POKE TL+((D2+2)*SW)+R2+5,WL%
12120 POKE TL+((D2+3)*SW)+R2,WL%:POKE TL+((D2+3)*SW)+R2+1,WL%:POKE TL+((D2+3)*SW)+R2+2,WC%:POKE TL+((D2+3)*SW)+R2+3,SP%
12130 POKE TL+((D2+3)*SW)+R2+4,WL%:POKE TL+((D2+3)*SW)+R2+5,WL%:POKE TL+((D2+3)*SW)+R2+6,WL%
12140 FOR I%=1 TO 4:POKE TL+((D2+4)*SW)+R2+I%,WL%:NEXT I%:FOR I%=6 TO 7:POKE TL+((D2+4)*SW)+R2+I%,WL%:NEXT I%
12160 FOR I%=3 TO 4:POKE TL+((D2+5)*SW)+R2+I%,WL%:NEXT I%:POKE TL+((D2+6)*SW)+R2+4,WL%
12189 REM ** Draw frame
12190 FOR I%=0 TO SW-1:POKE TL+I%,WB%:POKE TL+((SL+1)*SW)+I%,WB%:NEXT I%
12200 FOR I%=1 TO SL:POKE TL+(I%*SW),WB%:POKE TL+(I%*SW)+SW-1,WB%:NEXT I%
12220 W=TL+(SL*SW)+1:POKE W,SP%
12230 IF Q1%=YD% THEN M=MW:W=M
12240 UE%=1:GOSUB 57000:GOSUB 40000:PRINT D$:REM ** Draw to VT100
12250 RETURN
13999 REM ** Scenario 3 - Castles
14000 F$="CAGE":P=0:H=N(FL%):PK%=SP%:GOTO 14020
14010 F$="CBE":P=0:H=N(FL%):PK%=SP%:P(FL%)=P(2)
14019 REM ** Draw frame
14020 GOSUB 58000:PRINT CS$;
14030 FOR I%=1 TO ST:POKE TL+1+I%,YW%:POKE TL+1+(SW*(SL+1))+I%,YW%:NEXT I%
14040 FOR I%=1 TO SL:POKE TL+2+(SW*I%),YW%:POKE TL+21+(SW*I%),YW%:NEXT I% 
14069 REM ** Draw vertical walls
14070 RESTORE:FOR I%=1 TO P(FL%)
14080 READ V:IF V=100 THEN RESTORE
14090 NEXT I%
14100 L1=TL+2
14110 FOR J%=1 TO 3
14120 READ D(J%):P=P+1
14130 IF D(J%)=100 THEN RESTORE:D(J%)=3:P=P+1
14140 NEXT J%
14150 FOR I%=0 TO H:PC=YW%
14160 L=L1+(SW*I%):IF L>TL+(SW*SL) GOTO 14260
14170 IF I%=1 THEN PC=SP%
14180 IF D(1)=0 THEN PC=YW%:GOTO 14200
14190 POKE L+D(1),PC:PC=YW%
14200 IF I%=3 THEN PC=SP%
14210 POKE L+D(1)+D(2),PC:PC=YW%
14220 IF I%=4 THEN PC=SP%
14230 POKE L+D(1)+D(2)+D(3),PC:PC=YW%
14240 NEXT I%
14250 L1=L1+(SW*H)+SW:GOTO 14110
14259 REM ** Draw horizontal walls
14260 L1=TL+2
14270 FOR J%=1 TO 4
14280 L=L1+(SW*J%*(H+1))
14290 FOR K%=1 TO 19
14300 IF L>TL+((SL-1)*SW) GOTO 14350
14310 POKE L+K%,PC
14320 IF K%=2 OR K%=3*H OR K%=17 THEN POKE L+K%,SP%:POKE L+K%-SW,SP%:POKE L+K%+SW,SP%
14330 NEXT K%
14340 NEXT J%
14349 REM ** Draw in the stairs
14350 IF S=5 OR S=6 GOTO 14380
14360 IF FL%/2=INT(FL%/2) THEN POKE TL+SW+ST,YS%:GOTO 14380
14370 POKE TL+(SW*SL)+3,YS%
14379 REM ** Doorway needed ?
14380 IF FL%=2 OR S=5 OR S=6 THEN POKE TL+(SL+1)*SW+6,YD%:POKE TL+SL*SW+6,SP%
14390 IF P(3)=0 THEN W=TL+SL*SW+6
14399 REM ** Write appropriate castle name
14400 IF S=5 GOTO 14470
14410 IF S=6 GOTO 14450
14420 PRINT CH$;RR$(24);DD$(4);"The Black Tower":PRINT RR$(27);"of Zaexon"
14440 PRINT RR$(27);DD$(3);"Floor ";FL%-1:GOTO 14490
14450 PRINT CH$;RR$(27);DD$(2);"Vounim's":PRINT RR$(29);"Lair":GOTO 14500
14470 PRINT CH$;RR$(25);DD$(2);"The Temple Of":PRINT RR$(27);"Y'Nagioth"
14490 P(FL%+1)=P(FL%)+P
14499 REM ** Scatter special finds
14500 IF FL%<4 OR RND(1)<.3 GOTO 14565
14510 FOR I%=1 TO INT(RND(1)*5)+2
14520 N1=INT(RND(1)*(ST-1)):N2=INT(RND(1)*SL)
14540 IF PEEK(TL+3+SW*N2+N1)<>SP% GOTO 14520
14550 POKE TL+3+SW*N2+N1,YF%
14560 NEXT I%
14565 UE%=1:GOSUB 57020:GOSUB 40000:PRINT D$:REM ** Draw castle area to VT100
14570 RETURN
14999 REM ** Stairs subroutine
15000 Q%=VC%:POKE W,Q%:POKE M,SP%:GOSUB 57300
15010 PRINT D$;"A stairway...Up or Down?":TV%=FL%
15020 VG$="UD":GOSUB 1500:VG$=VK$
15030 IF GC$="U" THEN FL%=FL%+1:GOTO 15050
15040 FL%=FL%-1
15050 IF FL%>7 OR FL%<2 GOTO 15080
15060 DF%=110:DL$="D":GOSUB 36000
15070 GOTO 9220
15080 PRINT D$;"These stairs are blocked "
15090 DF%=60:DL$="D":GOSUB 36000
15100 FL%=TV%:GOTO 15010
35999 REM ** Delay, wipe & update subroutine
36000 FOR DL=1 TO DF%*TM:NEXT DL
36020 IF DL$="D" THEN DL$="":RETURN
36030 PRINT D$;SP$:PRINT SP$:PRINT SP$
36060 IF DL$="W" THEN DL$="":RETURN
36070 IF CS%>77-INT(2*P1%^2.5) THEN CS%=77-INT(2*P1%^2.5)
36080 IF PS%<7 THEN PS%=7
36085 PT=INT(42*(P1%+1)^LOG(P1%^3.7))+75
36090 IF PS%>PT THEN PS%=PT
36100 IF C>125-(INT(P1%)*12.5) THEN C=125-INT(INT(P1%)*12.5)
36110 IF TT%=1 THEN I%=1 ELSE I%=2
36120 PRINT CH$;DD$(14+I%);RR$(1);J$;" the ";P$
36130 PRINT " Treasure   =";TS:PRINT " Experience =";EX:PRINT " Turns      =";TN%
36140 PRINT CH$;DD$(15+I%);RR$(21);"  Combat str =";CS%:PRINT RR$(21);"  Psi power  =";PS%:PRINT RR$(21);"  Stamina    =";C;" "
36179 REM ** If fighting update monster
36180 IF CF=1 GOTO 36210
36190 PRINT SP$:PRINT SP$
36191 REM ** If not fighting update extended data
36195 IF UE%=1 THEN GOSUB 40000
36200 RETURN
36210 PRINT DM$;">> ";M$;" <<";DM$;RR$(20);"  M Str =";MS;N;" "
36230 RETURN
39999 REM ** Extended data display in columns 41+ for RC2014/VT100
40000 IF UE%=1 THEN UE%=0
40001 REM ** UE%=0 so not called until next monster OR if scene changes
40010 PRINT CH$;DD$(1);RR$(45);"Monster type & number slain"
40020 PRINT RR$(45);SPC(33);" "
40030 FOR I%=0 TO 18:IF MA%(I%)=0 GOTO 40070
40050 PRINT UU$(1):PRINT RR$(45);SPC(34)
40060 PRINT UU$(1):PRINT RR$(45);RIGHT$(M$(I%),LEN(M$(I%))-1);RR$(28-LEN(M$(I%))-LEN(STR$(MA%(I%))));MA%(I%)
40070 NEXT I%
40080 IF TT%<>1 THEN PRINT RR$(45);SPC(33);" ": REM ** More space on a 30 line screen
40090 SU%=SU%+1:PRINT UU$(1):IF SU%>8 THEN SU%=1:REM ** Cycle through extended data status updates
40100 RT=FNRT(0):IF RT<0 THEN RT=0 ELSE IF RT>28 THEN RT=28:REM ** Call ratings function
40110 IF SU%=1 THEN PRINT RR$(44);UB%;"monster";:IF UB%<>1 THEN PRINT "s defeated       " ELSE PRINT " defeated       "
40120 IF SU%=2 THEN PRINT RR$(44);UR%;"cowardly retreat";:IF UR%<>1 THEN PRINT "s       " ELSE PRINT SPC(9);" "
40130 IF SU%=3 THEN PRINT RR$(45);:IF T(0)=1 THEN PRINT "You have Alarian's amulet..." ELSE PRINT "You must find the amulet..."
40140 IF SU%=4 THEN PRINT RR$(44);:IF T(0)=1 THEN PRINT T(1);"of 6 amulet stones found  " ELSE PRINT " Seek the Temple of Y'Nagioth..."
40150 IF SU%=5 THEN PRINT RR$(44);:IF T(1)=6 AND T(2)=0 THEN PRINT "Now raid Vounim's Lair...        " ELSE IF T(0)=1 AND T(1)<6 THEN PRINT " The Black Tower awaits...      " ELSE PRINT " Continue your quest !";SPC(9);" "
40160 IF SU%=6 THEN PRINT RR$(45);:IF T(2)=1 THEN PRINT "You have The Helm of Evanna" ELSE PRINT "Onward to victory !";SPC(13);" "
40170 IF SU%=7 THEN PRINT RR$(45);:IF (UR%+UB%)>0 THEN PRINT "Bravery";INT((UB%/(UB%+UR%))*100);"%";SPC(16);" " ELSE PRINT "Continue your quest !";SPC(8);" "
40180 IF SU%=8 THEN PRINT RR$(45);:PRINT "Rating";RT;": ";RT$(RT);SPC(13);" "
40200 RETURN
44999 REM ** Ratings subroutine
45000 DF%=5:DL$="W":GOSUB 36000
45010 RT=FNRT(0):IF RT<0 THEN RT=0 ELSE IF RT>28 THEN RT=28:REM ** Call ratings function
45030 PRINT D$;"Your rating be";RT;": ";RT$(RT)
45040 IF T(2)=1 THEN PRINT " You have the helm of Evanna"
45050 IF T(0)=1 THEN PRINT " Amulet stones...";T(1)
45060 DF%=250:DL$="W":GOSUB 36000
45070 IF GC$="E" THEN C=C-10:GC$="":GOTO 2010
45080 RETURN
47999 REM ** Quit valley
48000 PRINT D$;"Thou art safe in a castle":IF CS%<20 THEN CS%=20
48010 POKE M,PK%:GOSUB 57200:PK%=PEEK(W):M=W:POKE M,Q%:GOSUB 57100
48014 REM ** Call proper ending variation
48015 IF T(2)=1 THEN DF%=50:GOSUB 36000:GOSUB 45000:GOTO 49000
48020 PRINT D$;DD$(1);"Wilt thou leave the valley (Y/N) ?":VG$="YN":GOSUB 1500
48040 DF%=5:DL$="W":GOSUB 36000
48049 REM ** Generate rating
48050 GOSUB 45000:REM ** Rating
48060 DF%=110:DL$="W":GOSUB 36000
48070 IF GC$="Y" GOTO 50000: REM ** Save
48080 C=150:PRINT D$;"Thy wounds healed...thy sword sharp":PRINT " Go as the Gods demand...trust no other"
48100 DF%=240:GOSUB 36000
48110 VG$=VK$:GOTO 2010:REM ** Movement
48999 REM ** Proper ending variation
49000 IF TT%=1 THEN I%=1 ELSE I%=3
49010 PRINT CS$;DD$(I%):PRINT "The Wizard of Alarian pays tribute to the skill of ";J$;" the ";P$;LF$
49020 PRINT "Thou hast returned the Helm of Evanna to its rightful place in her castle.";LF$
49030 PRINT "   By this act, thou hast defeated Vounim, The Evil One";LF$
49040 PRINT SPC(10);"and ensured the safety of The Valley";LF$
49050 PRINT SPC(20);"F O R E V E R !";LF$;LF$
49060 GC$=J$+", "+RT$(RT):PRINT "I salute you, and proclaim you ";GC$:GOTO 50210:REM ** End 
49999 REM ** Save character subroutine
50000 PRINT CS$;"Do you wish to save ";J$;" ?":PRINT:PRINT "Please key Y or N"
50020 VG$="YN":GOSUB 1500:REM ** Uniget
50030 IF GC$="N" GOTO 50210
50040 FI$="VALCHAR.DAT":PRINT: PRINT "Saving ";J$;" as ";FI$;"...";:OPEN "O",1,FI$
50080 PRINT#1,J$:PRINT#1,P$:PRINT#1,TS:PRINT#1,EX:PRINT#1,TN%:PRINT#1,CS%:PRINT#1,PS%:PRINT#1,T(0):PRINT#1,T(1):PRINT#1,T(2):PRINT#1,C1%: PRINT#1,P1%
50119 REM ** Extended data output
50120 PRINT#1,UR%:PRINT#1,UB%:FOR I%=0 TO 18:PRINT#1,MA%(I%):NEXT I%:CLOSE 1:PRINT "save complete."
50205 DF%=150:DL$="D":GOSUB 36000:REM ** Delay
50210 IF TT%=2 THEN PRINT CHR$(27)+"G": REM ** PetSCII graphics mode OFF
50215 PRINT D$;SPC(12);"Type RUN to start again":CLEAR
50230 END
54999 REM ** Death subroutine
55000 C=0:CS%=0:PS%=0:CF=0:UE%=0:DF%=110:GOSUB 36000
55020 IF T(1)=6 GOTO 55070
55030 PRINT D$;"Oh what a frail shell":PRINT "  is this that we call man"
55050 DF%=300:DL$="W":GOSUB 36000
55060 PRINT CS$:GOTO 50210
55070 T(0)=0:T(1)=0:TS=0:CS%=30:C=150:PS%=30:PRINT D$;"Alarian's amulet protects thy soul":PRINT:PRINT SPC(8);"++ Live again ++"
55100 DF%=150:GOSUB 36000
55110 L=G(0):MP=L:M=W:S=1:GOTO 9220
56099 REM ** Opening titles subroutine
56100 IF TT%=1 THEN I%=1 ELSE I%=3
56110 PRINT CS$;"Welcome to The Valley, brave adventurer.";DD$(I%)
56120 PRINT "Your quest is to find the Helm of Evanna and leave"
56130 PRINT "The Valley as a hero.";LF$ 
56140 PRINT "First, trek through the swamps to find the Amulet of Alarian"
56150 PRINT "in the Temple of Y'Naigoth.";LF$
56170 PRINT "Once you have the amulet, seek the six stones that complete it"
56180 PRINT "at The Black Tower of Zaexon.";LF$ 
56200 PRINT "Finally, amulet in hand, travel to the woods and raid Vounim's Lair"
56210 PRINT "to retrieve The Helm of Evanna.";LF$
56230 PRINT "Your quest ends when you return the Helm to a safe castle on the path.";LF$
56250 PRINT "Good luck ... and watch out for the monsters!";LF$;LF$
56270 GOSUB 1600: REM ** Anykey routine also randomises RND function
56280 RETURN
56299 REM ** Initial valley draw now a subroutine to allow earlier computation
56309 REM ** Draw valley frame
56310 FOR I%=0 TO SW-1:POKE TL+I%,VB%:POKE TL+((SL+1)*SW)+I%,VB%:NEXT I%
56320 FOR I%=1 TO SL:POKE TL+(I%*SW),VB%:POKE TL+(I%*SW)+SW-1,VB%:NEXT I%
56369 REM ** Compute valley path 
56370 M=TL+INT(RND(1)*SL+1)*SW+1:L=M:MP=M:W=M:G(0)=M:G(1)=VX%:POKE G(0),G(1)
56390 FOR I%=2 TO 74 STEP 2
56400 IF RND(1)>.5 GOTO 56420
56410 PC=VD%:L1=L+SW+1:GOTO 56430
56420 PC=VU%:L1=L-SW+1
56430 IF L1>=TL+SW*(SL+1)-1 OR L1<=TL+SW+1 GOTO 56400
56440 G(I%+1)=PC
56450 IF I%>2 AND G(I%+1)<>G(I%-1)THEN L1=L+1
56460 G(I%)=L1:L=L1:POKE G(I%),G(I%+1)
56470 NEXT I%
56480 G(75)=VX%:POKE G(74),G(75)
56489 REM ** Compute scenario positions
56490 FOR I%=0 TO 4
56500 N1=INT(RND(1)*11)+1:N2=INT(RND(1)*34)+1
56510 S(I%)=TL+(SW*N1)+N2:IF PEEK(S(I%))<>SP% OR PEEK(S(I%)+1)<>SP% GOTO 56500
56530 NEXT I%
56540 RETURN
56998 REM ** VT100 drawing subroutines **
56999 REM ** Print virtual screen to VT100 - for valley, swamps and woods
57000 PRINT CH$:FOR I%=0 TO SL+1:FOR J%=0 TO SW-1:PRINT CHR$(PEEK(TL+(SW*I%)+J%));:NEXT J%:PRINT:NEXT I%:RETURN
57019 REM ** Print virtual screen to VT100 - for castles
57020 PRINT CH$:FOR I%=0 TO SL+1:FOR J%=0 TO ST+1:PRINT CHR$(PEEK(TL+(SW*I%)+J%));:NEXT J%:PRINT:NEXT I%:RETURN
57099 REM ** Move character to new position 
57100 PRINT CH$:RS=(M-TL) MOD SW:DS=INT((M-TL)/SW)
57102 IF DS>0 THEN PRINT DD$(DS);
57104 IF RS>0 THEN PRINT RR$(RS);
57106 PRINT CHR$(Q%):RETURN
57199 REM ** Repair character's last position
57200 PRINT CH$:RS=(M-TL) MOD SW:DS=INT((M-TL)/SW)
57202 IF DS>0 THEN PRINT DD$(DS);
57204 IF RS>0 THEN PRINT RR$(RS);
57206 PRINT CHR$(PK%):RETURN
57299 REM ** Deal with scenario exits and stairs
57300 PRINT CH$:RS=(M-TL) MOD SW:DS=INT((M-TL)/SW)
57302 IF DS>0 THEN PRINT DD$(DS);
57304 IF RS>0 THEN PRINT RR$(RS);
57306 PRINT CHR$(SP%)
57308 PRINT CH$:RS=(W-TL) MOD SW:DS=INT((W-TL)/SW)
57310 IF DS>0 THEN PRINT DD$(DS);
57312 IF RS>0 THEN PRINT RR$(RS);
57314 PRINT CHR$(Q%):RETURN
57999 REM ** Set virtual screen to all spaces
58000 FOR I=TL TO TL+((SL+2)*SW):POKE I,SP%:NEXT I:RETURN
59999 REM ** Data for castle type scenarios
60000 DATA 4,7,3,6,4,4,6,5,3,6,0,3,8,4,3,5,5,3,8,3,4,5,0,6,3,6,4,6,4,7,4,100
60009 REM ** Data for monsters
60010 DATA AWolfen,9,0,AHob-Goblin,9,0,AOrc,9,0,EFire-Imp,7,3,GRock-Troll,19,0
60020 DATA EHarpy,10,12,AOgre,23,0,BBarrow-Wight,0,25,HCentaur,18,14
60030 DATA EFire-Giant,26,20,VThunder-Lizard,50,0,CMinotaur,35,25,CWraith,0,30
60040 DATA FWyvern,36,12,BDragon,50,20,CRing-Wraith,0,45,ABalrog,50,50,LWater-Imp,15,15,LKraken,50,0
60059 REM ** Ratings data
60060 DATA "Worm food","Monster food","Peasant","Cadet","Cannon Fodder","Path Walker"
60070 DATA "Novice Adventurer","Survivor","Adventurer","Assassin","Apprentice Hero","Giant Killer"
60080 DATA "Hero","Sword Master","Champion","Necromancer","Loremaster","Paladin"
60090 DATA "Superhero","Dragon Slayer","Valley Knight","Master of Combat","Dominator"
60100 DATA "Valley Prince","Guardian","War Lord","Demon Killer","Valley Lord","Master of Destiny"
60198 REM ** Valley scenario data depending on screen type. First 18 for VT100, second 18 is PicoTerm PetSCII, third for CP437
60200 DATA 73,61,64,47,92,33,45,65,58,35,43,94,126,88,62,95,42,32
60210 DATA 73,166,215,206,205,94,254,193,128,239,219,250,126,160,234,168,42,32
60220 DATA 73,177,79,47,92,94,45,234,43,247,64,216,126,219,206,196,42,32
