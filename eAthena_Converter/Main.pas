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
            for j := 0 to 6 do begin
                i := i + 1;
                account[i,j] := stringreplace(sl.Strings[j], '¨', ' ', [rfReplaceAll, rfIgnoreCase]);
            end;
        end;
    end;

    sl.Free;

    edit1.Text := 'eAthena accounts.txt file has been processed ..';
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
            for j := 0 to 18 do begin
                i := i + 1;
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

        for j := 0 to 26 do begin
            i := i + 1;
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

        for j := 0 to (sl.Count - 2) do begin
            i := i + 1;
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

        for j := 0 to (sl.Count - 1) do begin
            i := i + 1;
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

        for j := 0 to (sl.Count - 2) do begin
            i := i + 1;
            storage[i,j] := stringreplace(sl.Strings[j], '¨', ' ', [rfReplaceAll, rfIgnoreCase]);
        end;
    end;

    sl.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    //form1.eAthena_account();
    //form1.eAthena_athena();
    //form1.eAthena_party();
    //form1.eAthena_guild();
    //form1.eAthena_pet();
    //form1.eAthena_storage();
    
end;

{$R *.dfm}

end.
