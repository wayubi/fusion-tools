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
  athena_i : array[Word] of array[0..18] of string;
  athena_ii : array[Word] of array[0..1024] of string;

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
                athena_i[i,j] := stringreplace(sl.Strings[j], '¨', ' ', [rfReplaceAll, rfIgnoreCase]);
            end;
        end;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    //form1.eAthena_account();
    form1.eAthena_athena();
end;

{$R *.dfm}

end.
