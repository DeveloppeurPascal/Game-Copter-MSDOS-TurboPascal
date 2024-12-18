program Editeur_Pass_Word;
{
Auteur: Patrick Pr�martin
Date: 15/11/1992.
Langage: Turbo Pascal 6.0
But: Choix de la formule pour obtenir des codes d'acc�s aux 16 niveaux de
     chacun des 100 data disks de COPTER.
}
uses
    crt,
    printer,
    u_code_clavier,
    u_date,
    u_time,
    cop_code_acces;

const
     num_ver = '1.0';
     dat_ver = '15/11/1992';

var
   c : char;

function read_number (min, max : byte) : byte;
var
   ch : string;
   x, y : byte;
   res, err : integer;
begin
  x := wherex;
  y := wherey;
  repeat
    gotoxy (x, y);
    clreol;
    readln (ch);
    if (ch = '')
    then
      begin
        res := succ (max);
        err := 0;
      end
    else
      {$r-}
      val (ch, res, err);
      {$r-}
    {endif}
  until (((ch = '') or (err = 0)) and (res >= min) and (res <= succ (max)));
  read_number := res;
end; { read_number }

procedure code_tableau;
var
   n, x : byte;
begin
  writeln;
  write ('Num�ro du data_disk ? ');
  n := read_number (0, 99);
  if (n < 100)
  then
    begin
      writeln;
      write ('Num�ro du tableau ? ');
      x := read_number (1, 16);
      if (x < 17)
      then
        begin
          writeln;
          writeln;
          writeln ('Le code du tableau ', x, ' du data-disk ', n, ' de COPTER ',
                   'est: ', get_code_acces (n, x));
          while keypressed do
            c := readkey;
          {endwhile}
          repeat
          until keypressed;
          while keypressed do
            c := readkey;
          {endwhile}
        end;
      {endif}
    end;
  {endif}
end; { code_tableau }

procedure inversion_code;
var
   ch : string;
   n, x, y : byte;
   res : longint;
   err : integer;
begin
  writeln;
  write ('Code � tester ? ');
  x := wherex;
  y := wherey;
  repeat
    gotoxy (x, y);
    clreol;
    readln (ch);
    if (ch <> '')
    then
      {$r-}
      val (ch, res, err);
      {$r-}
    {endif}
  until ((ch = '') or ((err = 0) and (ch [0] = #6)));
  if (ch <> '')
  then
    begin
      get_data_tab (ch, n, x);
      writeln;
      if ((n > 100) or (x < 1) or (x > 16))
      then
        writeln ('Code invalide !')
      else
        writeln ('Ce code correspond au tableau ', x, ' du data disk ', n, '.');
      {endif}
      while keypressed do
        c := readkey;
      {endwhile}
      repeat
      until keypressed;
      while keypressed do
        c := readkey;
      {endwhile}
    end;
  {endif}
end; { inversion_code }

procedure imprimer_liste_code;
var
   n, x : byte;
begin
  writeln (lst, '     *****     Date: ', get_date_chaine, '     *****     ',
                'Heure: ', get_time_chaine, '     *****');
  writeln (lst, 'Liste des codes d''acc�s pour les tableaux de COPTER');
  for n := 0 to 99 do
    begin
      writeln (lst, 'Data disk ', n);
      for x := 1 to 16 do
        write (lst, x:2, '=', get_code_acces (n, x), '*');
      {endfor}
      writeln (lst);
      writeln (lst);
    end;
  {endfor}
  writeln (lst, carac_ff);
end; { imprimer_liste_code }

procedure test_codage;
var
   n, n2, x, x2 : byte;
begin
  for n := 0 to 99 do
    for x := 1 to 16 do
      begin
        get_data_tab (get_code_acces (n, x), n2, x2);
        if ((n <> n2) or (x <> x2))
        then
          writeln ('Erreur ', n, ':', x, ' ressemblant � ', n2, ':', x2);
        {endif}
      end;
    {endfor}
  {endfor}
  writeln ('*****     Fin du test des codes.');
  while keypressed do
    c := readkey;
  {endwhile}
  repeat
  until keypressed;
  while keypressed do
    c := readkey;
  {endwhile}
end; { test_codage }

begin
  repeat
    clrscr;
    writeln ('Editeur des codes d''acc�s pour COPTER ', num_ver);
    writeln ('(c) Patrick Pr�martin ', dat_ver);
    writeln;
    writeln ('     1 - Sortie');
    writeln ('     2 - Code d''un tableau');
    writeln ('     3 - Inversion d''un code');
    writeln ('     4 - Imprimer la liste des codes');
    writeln ('     5 - Test du codage');
    writeln;
    write ('Votre choix ? ');
    repeat
      c := readkey;
    until (c in ['1'..'5']);
    writeln (c);
    case c of
      '2' : code_tableau;
      '3' : inversion_code;
      '4' : imprimer_liste_code;
      '5' : test_codage;
    end;
    writeln;
  until (c = '1');
  clrscr;
  writeln ('Editeur des codes d''acc�s pour COPTER ', num_ver);
  writeln ('(c) Patrick Pr�martin ', dat_ver);
end.
