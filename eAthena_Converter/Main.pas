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
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  src_txt: TextFile;
  dst_txt: TextFile;
  str: String;
  i, j: integer;
  account : array[Word] of array[0..6] of string;

implementation

procedure TForm1.eAthena_account ();
var
    sl : TStringList;
    txt : TextFile;
    i, j : Integer;
begin
    i := -1;

    sl := TStringList.Create;
    sl.Delimiter := '¦';

    AssignFile(txt, 'eAthena/account.txt');
    Reset(txt);

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

procedure TForm1.Button1Click(Sender: TObject);
begin
    form1.eAthena_account();
end;

end.
