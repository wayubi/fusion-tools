unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;

    procedure eAthena_account ();
    procedure eAthena_athena ();
    procedure eAthena_party ();
    procedure eAthena_guild ();
    procedure eAthena_pet ();
    procedure eAthena_storage ();
    procedure fusion_player_create ();

    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  str: String;

  account : array[Word] of array[0..6] of string;
  athena : array[Word] of array[0..18] of string;
  character : array[Word] of array[0..8] of string;
  party : array[Word] of array[0..26] of string;
  guild : array[Word] of array[0..121] of string;
  pet : array[Word] of array[0..1] of string;
  storage : array[Word] of array[0..1] of string;

implementation

procedure TForm1.eAthena_account ();
var
    sl : TStringList;
    txt : TextFile;
    i, j : Integer;
begin
    sl := TStringList.Create;
    sl.Delimiter := '¦';

    AssignFile(txt, 'eAthena/account.txt');
    Reset(txt);

    i := -1;
    while not eof(txt) do begin
        sl.Clear;
        Readln(txt, str);
        str := stringreplace(str, chr(9), '¦', [rfReplaceAll, rfIgnoreCase]);
        str := stringreplace(str, ' ', '¨', [rfReplaceAll, rfIgnoreCase]);
        sl.DelimitedText := str;

        if sl.Count = 8 then begin
            if sl.Strings[4] <> 'S' then begin
                i := i + 1;
                for j := 0 to 6 do begin
                    account[i,j] := stringreplace(sl.Strings[j], '¨', ' ', [rfReplaceAll, rfIgnoreCase]);
                end;
            end;
        end;
    end;
    sl.Free;
end;

procedure TForm1.eAthena_athena ();
var
    sl : TStringList;
    txt : TextFile;
    i, j : Integer;
begin
    sl := TStringList.Create;
    sl.Delimiter := '¦';

    AssignFile(txt, 'eAthena/athena.txt');
    Reset(txt);

    i := -1;
    while not eof(txt) do begin
        sl.Clear;
        Readln(txt, str);
        str := stringreplace(str, chr(9), '¦', [rfReplaceAll, rfIgnoreCase]);
        str := stringreplace(str, ' ', '¨', [rfReplaceAll, rfIgnoreCase]);
        sl.DelimitedText := str;

        if (sl.Strings[1] <> '%newid%') then begin
            i := i + 1;
            for j := 0 to 18 do begin
                athena[i,j] := stringreplace(sl.Strings[j], '¨', ' ', [rfReplaceAll, rfIgnoreCase]);
            end;
        end;
    end;
    sl.Free;
end;

procedure TForm1.eAthena_party ();
var
    sl : TStringList;
    txt : TextFile;
    i, j : Integer;
begin
    sl := TStringList.Create;
    sl.Delimiter := '¦';

    AssignFile(txt, 'eAthena/party.txt');
    Reset(txt);

    i := -1;
    while not eof(txt) do begin
        sl.Clear;
        Readln(txt, str);
        str := stringreplace(str, chr(9), '¦', [rfReplaceAll, rfIgnoreCase]);
        str := stringreplace(str, ' ', '¨', [rfReplaceAll, rfIgnoreCase]);
        sl.DelimitedText := str;

        i := i + 1;
        for j := 0 to 26 do begin
            party[i,j] := stringreplace(sl.Strings[j], '¨', ' ', [rfReplaceAll, rfIgnoreCase]);
            if (party[i,j] = 'NoMember') then party[i,j] := '';
        end;
    end;
    sl.Free;
end;

procedure TForm1.eAthena_guild ();
var
    sl : TStringList;
    txt : TextFile;
    i, j : Integer;
begin
    sl := TStringList.Create;
    sl.Delimiter := '¦';

    AssignFile(txt, 'eAthena/guild.txt');
    Reset(txt);

    i := -1;
    while not eof(txt) do begin
        sl.Clear;
        Readln(txt, str);
        str := stringreplace(str, chr(9), '¦', [rfReplaceAll, rfIgnoreCase]);
        str := stringreplace(str, ' ', '¨', [rfReplaceAll, rfIgnoreCase]);
        sl.DelimitedText := str;

        i := i + 1;
        for j := 0 to (sl.Count - 2) do begin
            guild[i,j] := stringreplace(sl.Strings[j], '¨', ' ', [rfReplaceAll, rfIgnoreCase]);
        end;
    end;
    sl.Free;
end;

procedure TForm1.eAthena_pet ();
var
    sl : TStringList;
    txt : TextFile;
    i, j : Integer;
begin
    sl := TStringList.Create;
    sl.Delimiter := '¦';

    AssignFile(txt, 'eAthena/pet.txt');
    Reset(txt);

    i := -1;
    while not eof(txt) do begin
        sl.Clear;
        Readln(txt, str);
        str := stringreplace(str, chr(9), '¦', [rfReplaceAll, rfIgnoreCase]);
        str := stringreplace(str, ' ', '¨', [rfReplaceAll, rfIgnoreCase]);
        sl.DelimitedText := str;

        i := i + 1;
        for j := 0 to (sl.Count - 1) do begin
            pet[i,j] := stringreplace(sl.Strings[j], '¨', ' ', [rfReplaceAll, rfIgnoreCase]);
        end;
    end;
    sl.Free;
end;

procedure TForm1.eAthena_storage ();
var
    sl : TStringList;
    txt : TextFile;
    i, j : Integer;
begin
    sl := TStringList.Create;
    sl.Delimiter := '¦';

    AssignFile(txt, 'eAthena/storage.txt');
    Reset(txt);

    i := -1;
    while not eof(txt) do begin
        sl.Clear;
        Readln(txt, str);
        str := stringreplace(str, chr(9), '¦', [rfReplaceAll, rfIgnoreCase]);
        str := stringreplace(str, ' ', '¨', [rfReplaceAll, rfIgnoreCase]);
        sl.DelimitedText := str;

        i := i + 1;
        for j := 0 to (sl.Count - 2) do begin
            storage[i,j] := stringreplace(sl.Strings[j], '¨', ' ', [rfReplaceAll, rfIgnoreCase]);
        end;
    end;
    sl.Free;
end;

procedure TForm1.fusion_player_create ();
var
    sl : TStringList;
    txt : TextFile;
    i, j : Integer;
begin
    sl := TStringList.Create;
    CreateDir('Fusion');
    AssignFile(txt, 'Fusion/player.txt');
    Rewrite(txt);
    Writeln(txt, '##Weiss.PlayerData.0x0003');
    for i := 0 to High(athena) do begin
        if athena[i,1] <> '' then begin
            sl.Clear;
            sl.Delimiter := ',';
            sl.DelimitedText := athena[i,1];
            for j := 0 to High(account) do begin
                if sl.Strings[0] = account[j,0] then begin
                    character[j,StrToInt(sl.Strings[1])] := athena[i,2];
                end;
            end;
        end;
    end;
    for i := 0 to High(account) do begin
        if account[i,4] = 'M' then account[i,4] := stringreplace(account[i,4], 'M', '1', [])
        else if account[i,4] = 'F' then account[i,4] := stringreplace(account[i,4], 'F', '0', []);
        if account[i,0] <> '' then begin
            Writeln(txt, account[i,0] + ',' + account[i,1] + ',' + account[i,2] + ',' + account[i,4] + ',-@-,' + account[i,6] + ',' + character[i,0] + ',' + character[i,1] + ',' + character[i,2] + ',' + character[i,3] + ',' + character[i,4] + ',' + character[i,5] + ',' + character[i,6] + ',' + character[i,7] + ',' + character[i,8]);
            for j := 0 to High(storage) do begin
                if storage[j,0] <> '' then begin
                    sl.Clear;
                    sl.DelimitedText := storage[j,0];
                    if sl.Strings[0] = account[i,0] then begin
                        Writeln(txt, sl.Strings[1] + ',' + storage[j,1]);
                        break;
                    end

                    else begin
                        Writeln(txt, '0');
                        break;
                    end;
                end;
            end;
        end;
    end;
    sl.Free;
    CloseFile(txt);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    form1.eAthena_account();
    form1.eAthena_athena();
    form1.eAthena_party();
    form1.eAthena_guild();
    form1.eAthena_pet();
    form1.eAthena_storage();
    edit1.Text := 'eAthena text files processed successfully.';

    form1.fusion_player_create();
end;

{$R *.dfm}

end.
