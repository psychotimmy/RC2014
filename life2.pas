{ Conway's life with randomiser, Turbo Pascal 3.01A, RC2014 }                   
{ Tim Holyoake, 26th March 2024 }                                               
                                                                                
program life(output);                                                           
const                                                                           
  COLUMNS   =    80; { Number of columns on board }                             
  ROWS      =    20; { Number of rows on board }                                
  RANDMAX   =     6; { For generating a random integer less than RANDMAX }      
  RANDRAN   =   800; { For generating a random integer less than RANDRAN }      
                     { Places a random ALIVE cell on the board }                
  EMPTY     = FALSE; { Empty cell is boolean value FALSE }                      
  ALIVE     =  TRUE; { Alive cell is boolean value TRUE }                       
type                                                                            
  Grid = array [1..ROWS, 1..COLUMNS] of boolean;                                
var                                                                             
  Board: Grid;                                                                  
  generation, livecells: integer;                                               
                                                                                
function PopulateBoard: integer;                                                
{ Populates the board with a random initial state }                             
var col, row, cells: integer;                                                   
begin                                                                           
  cells := 0;                                                                   
  for row := 1 to ROWS do                                                       
    for col := 1 to COLUMNS do                                                  
      begin                                                                     
        Board[row,col] := EMPTY;                                                
        if (Random(RANDMAX) < 1) then                                           
        begin                                                                   
          Board[row,col] := ALIVE;                                              
          cells := cells + 1                                                    
        end                                                                     
      end;                                                                      
  PopulateBoard := cells                                                        
end;                                                                            
                                                                                
function NextGeneration: integer;                                               
{ Calculates the number of cells in the next generation }                       
{ by creating a temporary grid based on Conway's rules  }                       
{ for birth, death and survivorship                     }                       
var row, col, x, y, cells, nextgen: integer;                                    
    cur: boolean;                                                               
    NewBoard: Grid;                                                             
begin                                                                           
  nextgen := 0;                                                                 
  for row := 1 to ROWS do                                                       
    for col := 1 to COLUMNS do                                                  
    begin                                                                       
      cur := Board[row,col];                                                    
      NewBoard[row,col] := EMPTY;                                               
      cells := 0;                                                               
      for x := row-1 to row+1 do                                                
        for y := col-1 to col+1 do                                              
          if ((y<>0) and (y<=COLUMNS) and (x<>0) and (x<=ROWS)) then            
            if (Board[x,y]=ALIVE) then cells := cells+1;                        
      if (cur=ALIVE) then cells:=cells-1;                                       
      if ((cells=3) or ((cells=2) and (cur=ALIVE))) then                        
      begin                                                                     
        NewBoard[row,col] := ALIVE;                                             
        nextgen := nextgen+1                                                    
      end                                                                       
  end;                                                                          
                                                                                
  for row := 1 to ROWS do                                                       
    for col := 1 to COLUMNS do                                                  
      Board[row,col] := NewBoard[row,col];                                      
                                                                                
  NextGeneration := nextgen                                                     
                                                                                
end;                                                                            
                                                                                
function DisplayBoard: integer;                                                 
{ Display the current board }                                                   
var col, row, cells: integer;                                                   
begin                                                                           
  cells := 0;                                                                   
  writeln(#27'[H'); { VTxxx home cursor }                                       
  for row := 1 to ROWS do                                                       
  begin                                                                         
    for col := 1 to COLUMNS do                                                  
      if (Board[row,col] = ALIVE) then                                          
        write('*')                                                              
      else                                                                      
      begin                                                                     
        if (Random(RANDRAN) < 1) then                                           
        begin                                                                   
          Board[row,col] := ALIVE;                                              
          cells := cells+1;                                                     
          write('^')                                                            
        end                                                                     
        else                                                                    
          write(' ');                                                           
      end;                                                                      
    writeln                                                                     
  end;                                                                          
                                                                                
  DisplayBoard := cells                                                         
end;                                                                            
                                                                                
{ Main program }                                                                
begin                                                                           
  write(#27'[2J'); { VTxxx clear screen }                                       
  generation := 1;                                                              
  livecells := PopulateBoard;                                                   
  repeat                                                                        
    begin                                                                       
      livecells := livecells + DisplayBoard;                                    
      writeln;                                                                  
      writeln('Generation: ',generation,' Cells: ',livecells,'    ');           
      livecells := NextGeneration;                                              
      generation := generation + 1                                              
    end                                                                         
  until KeyPressed                                                              
end.
