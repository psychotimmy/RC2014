program radec(input,output);
type  PN = (Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto);
      PlanetaryData = array [Mercury..Pluto, 1..9] of real;
      str9 = string[9];
      str3 = string[3];
var   pData: PlanetaryData;
      planet: PN;
      year, month, day, epoch: integer;
      helioLong, helioLongE: real;
      sunDistance, sunDistanceE: real;
      eclipDist: real;
      earthDistance: real;
      rightAscension: real;
      declination: real;
      monthstr: str3;
      getData: char;
const pi = 3.14159;
      dayhours = 24.0;

procedure InitPlanetData;
begin
  pData[Mercury,1] := 0.071422;
  pData[Mercury,2] := 3.8484;
  pData[Mercury,3] := 0.388301;
  pData[Mercury,4] := 1.34041;
  pData[Mercury,5] := 0.3871;
  pData[Mercury,6] := 0.07974;
  pData[Mercury,7] := 2.73514;
  pData[Mercury,8] := 0.122173;
  pData[Mercury,9] := 0.836013;

  pData[Venus,1] := 0.027962;
  pData[Venus,2] := 3.02812;
  pData[Venus,3] := 0.013195;
  pData[Venus,4] := 2.28638;
  pData[Venus,5] := 0.7233;
  pData[Venus,6] := 0.00506;
  pData[Venus,7] := 3.85017;
  pData[Venus,8] := 0.059341;
  pData[Venus,9] := 1.33168;

  pData[Earth,1] := 0.017202;
  pData[Earth,2] := 1.74022;
  pData[Earth,3] := 0.032044;
  pData[Earth,4] := 1.78547;
  pData[Earth,5] := 1.0;
  pData[Earth,6] := 0.017;
  pData[Earth,7] := 3.33929;
  pData[Earth,8] := 0.0;
  pData[Earth,9] := 0.0;

  pData[Mars,1] := 0.009146;
  pData[Mars,2] := 4.51234;
  pData[Mars,3] := 0.175301;
  pData[Mars,4] := 5.85209;
  pData[Mars,5] := 1.5237;
  pData[Mars,6] := 0.141704;
  pData[Mars,7] := 1.04656;
  pData[Mars,8] := 0.03142;
  pData[Mars,9] := 0.858702;

  pData[Jupiter,1] := 0.00145;
  pData[Jupiter,2] := 4.53364;
  pData[Jupiter,3] := 0.090478;
  pData[Jupiter,4] := 0.23911;
  pData[Jupiter,5] := 5.2028;
  pData[Jupiter,6] := 0.249374;
  pData[Jupiter,7] := 1.76188;
  pData[Jupiter,8] := 0.01972;
  pData[Jupiter,9] := 1.74533;

  pData[Saturn,1] := 0.000584;
  pData[Saturn,2] := 4.89884;
  pData[Saturn,3] := 0.105558;
  pData[Saturn,4] := 1.61094;
  pData[Saturn,5] := 9.5385;
  pData[Saturn,6] := 0.534156;
  pData[Saturn,7] := 3.1257;
  pData[Saturn,8] := 0.043633;
  pData[Saturn,9] := 1.977458;

  pData[Uranus,1] := 0.000205;
  pData[Uranus,2] := 2.46615;
  pData[Uranus,3] := 0.088593;
  pData[Uranus,4] := 2.96706;
  pData[Uranus,5] := 19.182;
  pData[Uranus,6] := 0.901554;
  pData[Uranus,7] := 4.49084;
  pData[Uranus,8] := 0.01396;
  pData[Uranus,9] := 1.28805;

  pData[Neptune,1] := 0.000104;
  pData[Neptune,2] := 3.78556;
  pData[Neptune,3] := 0.016965;
  pData[Neptune,4] := 0.773181;
  pData[Neptune,5] := 30.06;
  pData[Neptune,6] := 0.27054;
  pData[Neptune,7] := 2.33498;
  pData[Neptune,8] := 0.031416;
  pData[Neptune,9] := 2.29162;

  pData[Pluto,1] := 0.000069;
  pData[Pluto,2] := 3.16948;
  pData[Pluto,3] := 0.471239;
  pData[Pluto,4] := 3.913031;
  pData[Pluto,5] := 39.44;
  pData[Pluto,6] := 9.86;
  pData[Pluto,7] := 5.23114;
  pData[Pluto,8] := 0.300197;
  pData[Pluto,9] := 1.91812
end;

function planetString(planet: PN): str9;
begin
  planetString := '         ';
  case planet of
    Mercury: planetString := 'Mercury  ';
    Venus: planetString := 'Venus    ';
    Earth: planetString := 'Earth    ';
    Mars: planetString := 'Mars     ';
    Jupiter: planetString := 'Jupiter  ';
    Saturn: planetString := 'Saturn   ';
    Uranus: planetString := 'Uranus   ';
    Neptune: planetString := 'Neptune  ';
    Pluto: planetString := 'Pluto    '
  end;
end;

function monthString(month: integer): str3;
begin
  monthString := '   ';
  case month of
    1: monthString := 'Jan';
    2: monthString := 'Feb';
    3: monthString := 'Mar';
    4: monthString := 'Apr';
    5: monthString := 'May';
    6: monthString := 'Jun';
    7: monthString := 'Jul';
    8: monthString := 'Aug';
    9: monthString := 'Sep';
    10: monthString := 'Oct';
    11: monthString := 'Nov';
    12: monthString := 'Dec';
  end;
end;

procedure GetNumI(var WholeNumber: integer; var CharFlag: char;
                  var Code: integer);
const PromptString ='? ';
var   Entry: string[30];
begin
  write(PromptString);
  readln(Entry);
  val(Entry,WholeNumber,Code);
  case length(Entry) of
    0: Code := -2;
    1: if Code > 0 then
         begin
           Code := -1;
           CharFlag := Entry
         end
  end
end;

function arcsin(x: real): real;
begin
  arcsin := arctan(x/sqrt(-x*x+1.0))
end;

function arccos(x: real): real;
begin
  arccos := -arctan (x/sqrt(-x*x+1.0))+1.5707963
end;

function rad(x: real): real;
begin
  rad := 0.01745328*x
end;

function deg(x: real): real;
begin
  deg := 57.29578*x
end;

function getYear: integer;
var i, status: integer;
    cf: char;
begin
  i := 0;
  while (i < 1901)or(i > 2048)
  do begin
    writeln('Enter a year between 1901 and 2048');
    repeat
      GetNumI(i,cf,status);
      case status of
        -2: writeln('No year entered');
        -1: writeln('Non-numeric ',cf,' entered')
      end
    until status=0
  end;
  getYear := i
end;

function getMonth: integer;
var i, status: integer;
    cf: char;
begin
  i := 0;
  while (i < 1)or(i > 12)
  do begin
    writeln('Enter a month between 1 (January) and 12 (December)');
    repeat
      GetNumI(i,cf,status);
      case status of
        -2: writeln('No month entered');
        -1: writeln('Non-numeric ',cf,' entered')
      end
    until status=0
  end;
  getMonth := i
end;

function getDay(m: integer; y: integer): integer;
var i,j,status: integer;
var cf: char;
begin
  case m of
    1,3,5,7,8,10,12: j := 31;
    4,6,9,11: j := 30;
    2: if (((y mod 4 = 0)and(y mod 100 <> 0))or(y mod 400 = 0)) then j := 29
       else j :=28
  end;
  i := 0;
  while (i < 1)or(i > j)
  do begin
    writeln('Enter a day between 1 and ',j);
    repeat
      GetNumI(i,cf,status);
      case status of
        -2: writeln('No day entered');
        -1: writeln('Non-numeric ',cf, ' entered')
      end
    until status=0
  end;
  getDay := i
end;

function getEpochDay(y: integer; m: integer; d: integer): integer;
var temp: real;
begin
  temp := 365.0*y+d+((m-1.0)*31.0);
  if (m < 3) then
    temp := temp+trunc((y-1)/4)-trunc((0.75)*trunc((y-1)/100+1))
  else
    temp := temp-trunc(m*0.4+2.3)+trunc(y/4)-trunc((0.75)*trunc((y/100)+1));
  getEpochDay := round(temp-715875.0);
end;

function getHelioLong(p: PN; e: integer): real;
var t: real;
begin
  t := e*pData[p,1]+pData[p,2];
  if (t > 2.0*pi) then t := ((t/(2.0*pi))-trunc(t/(2.0*pi)))*2.0*pi;
  while (t < 0.0) do t := t+2.0*pi;
  t := t+pData[p,3]*sin(t-pData[p,4]);
  if (t > 2.0*pi) then t := t-2.0*pi;
  while (t < 0.0) do t := t+2.0*pi;
  getHelioLong := t
end;

function getEarthDist(hl: real; hle: real; sd: real; sde:real): real;
var tempz: real;
begin
  tempz := hle-hl;
  if (abs(tempz) > pi) and (tempz < 0.0) then tempz := tempz+2.0*pi;
  if (abs(tempz) > pi) and (tempz > 0.0) then tempz := tempz-2.0*pi;
  getEarthDist := sqrt(sqr(sd)+sqr(sde)-2.0*sd*sde*cos(tempz));
end;

function getRA(hl: real; hle: real; sd: real; sde: real; edst: real): real;
var tempz: real;
var tempp: real;
var tempx: real;
var ra: real;
begin
  tempz := hle-hl;
  if (abs(tempz) > pi) and (tempz < 0.0) then tempz := tempz+2.0*pi;
  if (abs(tempz) > pi) and (tempz > 0.0) then tempz := tempz-2.0*pi;

  tempp := (sd+sde+edst)/2.0;
  tempx := 2.0*arccos(sqrt(((tempp*(tempp-sd))/(sde*edst))));

  if (tempz < 0.0) then ra := deg(hle+pi-tempx)/15.0
  else ra := deg(hle+pi+tempx)/15.0;

  while (ra > dayhours) do ra := ra-dayhours;
  while (ra < -dayhours) do ra := ra+dayhours;
  while (ra < 0.0) do ra := ra+dayhours;

  getRA := ra;
end;

function getDec(hl: real; hle: real; sd: real; sde: real;
                edst: real; eclip: real): real;
var tempz: real;
var tempp: real;
var tempx: real;
var tempv: real;
begin
  tempz := hle-hl;
  if (abs(tempz) > pi) and (tempz < 0) then tempz := tempz+2*pi;
  if (abs(tempz) > pi) and (tempz > 0) then tempz := tempz-2*pi;

  tempp := (sd+sde+edst)/2.0;
  tempx := 2.0*arccos(sqrt(((tempp*(tempp-sd))/(sde*edst))));

  if (tempz < 0) then tempv := sin(hle+pi-tempx)*23.44194+deg(eclip);
  if (tempz > 0) then tempv := sin(hle+pi+tempx)*23.44194+deg(eclip);

  getDec := tempv;
end;

begin
  writeln('');
  writeln('           -----------------');
  writeln('           |     RADEC     |');
  writeln('           -----------------');
  writeln('');
  writeln('This program gives right ascension');
  writeln('and declinations,');
  writeln('heliocentric longitudes and the');
  writeln('distances from Earth of all the');
  writeln('planets, for the date you choose.');
  writeln('');
  writeln('Based on the original BASIC code');
  writeln('by Eric Burgess F.R.A.S in the');
  writeln('book Celestial BASIC, Sybex, 1982.');
  writeln('');

  InitPlanetData;
  getData := 'Y';

  while (getData = 'Y') or (getData = 'y') do
  begin

    year := getYear;
    month := getMonth;
    monthstr := monthString(month);
    day := getDay(month,year);

    epoch :=getEpochDay(year,month,day);

    writeln('');
    writeln('Planetary data for .. ',day,' ',monthstr,' ',year);
    writeln('Which is ',epoch,' days from 1 Jan 1960');
    writeln('-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:');
    writeln('        Helio     Dist     R.A.    Dec');
    writeln('         long   to planet  Hrs     Deg');
    writeln('-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:');
    writeln('');

    planet := Earth;
    helioLongE := getHelioLong(planet,epoch);
    sunDistanceE := pData[planet,5]+pData[planet,6]*sin(helioLongE-pData[planet,7]);

    for planet := Mercury to Pluto
    do begin
      if (planet <> Earth) then
      begin
        helioLong := getHelioLong(planet,epoch);
        sunDistance := pData[planet,5]+pData[planet,6]*sin(helioLong-pData[planet,7]);
        eclipDist := pData[planet,8]*sin(helioLong-pData[planet,9]);
        earthDistance := getEarthDist(helioLong,helioLongE,
                                      sunDistance,sunDistanceE);
        rightAscension := getRA(helioLong,helioLongE,
                                sunDistance,sunDistanceE,
                                earthDistance);
        declination := getDec(helioLong,helioLongE,
                              sunDistance,sunDistanceE,
                              earthDistance,eclipDist);

        write(planetString(planet));
        write(deg(helioLong):5:1);
        write(earthDistance:9:3);
        write(rightAscension:8:2);
        write(declination:7:2);
        writeln('');
        writeln('')
      end;
    end;

  writeln('Another date (Y/N)?');
  readln(getData);
  writeln('')

  end;
end.
